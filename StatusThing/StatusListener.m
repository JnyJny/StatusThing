//
//  StatusListener.m
//  StatusThing
//
//  Created by Erik on 4/16/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "StatusListener.h"
#import "StatusThingUtilities.h"
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#pragma mark - Constants

static NSString * const StatusThingHelpFile                       = @"HelpText";
static NSString * const StatusThingBonjourType                    = @"_statusthing._tcp.";

static NSString * const StatusThingResponseWelcome                = @"Connected to StatusThing\nFeed Me JSON\n> ";
static NSString * const StatusThingResponseGoodbye                = @"\nBe seeing you space cowboy!\n";
static NSString * const StatusThingResponseOk                     = @"Ok\n> ";
static NSString * const StatusThingResponseErrorFormat            = @"Err: %@\n> ";
static NSString * const StatusThingResponseNoHelpText             = @"Oops: NO HELP TEXT AVAILABLE.\n> ";
static NSString * const StatusThingResponseResetUnavilable        = @"Oops: reset is unavailable.\n> ";
static NSString * const StatusThingResponseDelegateError          = @"Oops: delegate error. Author sucks.\n> ";
static NSString * const StatusThingResponseUnknownContainerFormat = @"Err: NSJSONSerialization returned something that was neither a dictionary nor an array: %@";

NSString *const PeerKeyAddress   = @"peerAddress";
NSString *const PeerKeyPort      = @"peerPort";
NSString *const PeerKeyTimestamp = @"timestamp";
NSString *const PeerKeyContent   = @"content";

@interface StatusListener()

@property (strong,nonatomic) NSSocketPort         *socketPort;
@property (strong,nonatomic) NSFileHandle         *listening;
@property (strong,nonatomic) NSNotificationCenter *noteCenter;
@property (strong,nonatomic) NSNetService         *netService;
@property (assign,nonatomic) BOOL                  running;
@property (strong,nonatomic) NSUserDefaults       *userDefaults;

@end

@implementation StatusListener



#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.running = NO;
    }
    return self;
}

#pragma mark - Properties

- (NSUserDefaults *)userDefaults
{
    if (!_userDefaults) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return _userDefaults;
}

- (unsigned short)port
{
    NSNumber *portNumber = [self.userDefaults objectForKey:StatusThingPreferencePortNumber];

    if (!portNumber) {
        portNumber = @0;
    }
    return portNumber.unsignedShortValue;
}

- (void)setPort:(unsigned short)port
{
    [self.userDefaults setObject:[NSNumber numberWithUnsignedShort:port]
                          forKey:StatusThingPreferencePortNumber];
}

- (NSString *)helpText
{
    if (!_helpText) {
        _helpText = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:StatusThingHelpFile ofType:@""]
                                              encoding:NSUTF8StringEncoding
                                                 error:nil];
        if (!_helpText)
            _helpText = StatusThingResponseNoHelpText;
    }
    return _helpText;
}



#pragma mark - Private Properties

- (NSSocketPort *)socketPort
{
    if (!_socketPort) {
        struct sockaddr_in addr;

        _socketPort = [[NSSocketPort alloc] initWithTCPPort:self.port];

        [_socketPort.address getBytes:&addr length:sizeof(addr)];
        
        self.port = ntohs(addr.sin_port);

    }
    return _socketPort;
}



- (NSNetService *)netService
{
    if (!_netService) {
        _netService = [[NSNetService alloc] initWithDomain:@""
                                                      type:StatusThingBonjourType
                                                      name:@""
                                                      port:self.port];
    }
    return _netService;
}



- (NSFileHandle *)listening
{
    if (!_listening) {
        _listening = [[NSFileHandle alloc] initWithFileDescriptor:self.socketPort.socket
                                                   closeOnDealloc:YES];
    }
    return _listening;
}

- (NSNotificationCenter *)noteCenter
{
    if (!_noteCenter) {
        _noteCenter = [NSNotificationCenter defaultCenter];
    }
    return _noteCenter;
}

#pragma mark - Methods

- (void)start
{

    if (self.running) {
        [self stop];
    }
    
    [self.noteCenter addObserver:self
                        selector:@selector(handleNewConnection:)
                            name:NSFileHandleConnectionAcceptedNotification
                          object:self.listening];
    
    [self.listening acceptConnectionInBackgroundAndNotify];
    
    if ([self.userDefaults boolForKey:StatusThingPreferenceUseBonjour]) {
        [self.netService publish];
    }
    
    self.running = YES;
}


- (void)stop
{
    if (!self.running) {
        return;
    }
    
    [self.netService stop];
    
    self.netService = nil;
    
    [self.noteCenter removeObserver:self
                               name:NSFileHandleConnectionAcceptedNotification
                             object:self.listening];
    
    [self.listening closeFile];
    self.listening = nil;
    self.socketPort = nil;
    
    self.running = NO;
}

#pragma mark - Notification Callbacks

- (void)handleNewConnection:(NSNotification *)note
{
    NSFileHandle *connected = [note.userInfo objectForKey:NSFileHandleNotificationFileHandleItem];
    
    if (![self.userDefaults boolForKey:StatusThingPreferenceAllowRemoteConnections]) {
        NSDictionary *info = [self peerInfoForFileHandle:connected withContent:nil];
        if (![@"127.0.0.1" isEqualToString:info[PeerKeyAddress]]) {
            NSLog(@"connection from remote client denied: %@",info);
            [connected closeFile];
            [self.listening acceptConnectionInBackgroundAndNotify];
            return;
        }
    }
    
    
    [self.noteCenter addObserver:self
                        selector:@selector(sendDataToDelegate:)
                            name:NSFileHandleReadCompletionNotification
                          object:connected];

    [connected writeData:[StatusThingResponseWelcome dataUsingEncoding:NSUTF8StringEncoding]];
    
    [connected readInBackgroundAndNotify];
    
    [self.listening acceptConnectionInBackgroundAndNotify];
}


#pragma mark - Delegate Interaction




- (NSDictionary *)peerInfoForFileHandle:(NSFileHandle*)fileHandle withContent:(NSData *)optionalContent
{
    struct sockaddr_in ip4;
    socklen_t ip4len = sizeof(ip4);
    NSString *content = @"";
    
    getpeername(fileHandle.fileDescriptor, (struct sockaddr *)&ip4,&ip4len);
    
    if (optionalContent) {
        content = [[NSString alloc] initWithData:optionalContent encoding:NSUTF8StringEncoding];
    }

    return @{ PeerKeyAddress:[NSString stringWithCString:inet_ntoa(ip4.sin_addr) encoding:NSUTF8StringEncoding],
              PeerKeyPort:[NSNumber numberWithUnsignedShort:ntohs(ip4.sin_port)],
              PeerKeyTimestamp:[NSDate date],
              PeerKeyContent:content};
}

- (void)sendDataToDelegate:(NSNotification *)note
{
    NSFileHandle *connected = [note object];
    NSData *data = [[note userInfo] objectForKey:NSFileHandleNotificationDataItem];
    NSString *response;
    NSError *error;
    char c;
    id obj;

    if (data.length)
        [data getBytes:&c length:sizeof(c)];
    else {
        c = 'q';
    }
    

    switch (c) {
        case 0x4:
        case 'q':
        case 'Q':
            // q|Q|ctl-D|zero length read - tell the client goodbye and hang up
            [connected writeData:[StatusThingResponseGoodbye dataUsingEncoding:NSUTF8StringEncoding]];
            [self.noteCenter removeObserver:self
                                       name:NSFileHandleReadCompletionNotification
                                     object:connected];
            [connected closeFile];
            return;
            // NOTREACHED
            
        case 'h':
        case 'H':
        case '?':
            response = self.helpText;
            break;
            
        case 'r':
        case 'R':
            if ( self.resetInfo ) {
                [self.delegate performSelector:@selector(processRequest:fromClient:)
                                    withObject:self.resetInfo
                                    withObject:[self peerInfoForFileHandle:connected withContent:nil]];
            }
            response = self.resetInfo?StatusThingResponseOk:StatusThingResponseResetUnavilable;
            break;
            
        default:
            
            if (!self.delegate) {
                response = StatusThingResponseDelegateError;
                break;
            }
            
            obj = [NSJSONSerialization JSONObjectWithData:data
                                                  options:0
                                                    error:&error];
            

            if (!obj) {
                response = [NSString stringWithFormat:StatusThingResponseErrorFormat,error.localizedFailureReason];
                break;
            }
            
            if ([obj isKindOfClass:[NSDictionary class]]){
                
                [self.delegate performSelector:@selector(processRequest:fromClient:)
                                    withObject:obj
                                    withObject:[self peerInfoForFileHandle:connected withContent:data]];
                
                response = StatusThingResponseOk;
                break;
            }
            
            if ([obj isKindOfClass:[NSArray class]]) {
                [self.delegate performSelector:@selector(updateWithArray:)
                                    withObject:obj];
                response = StatusThingResponseOk;
                break;
            }
            
            
            response = [NSString stringWithFormat:StatusThingResponseUnknownContainerFormat,[obj class]];
            break;
    }
    
    [connected writeData:[response dataUsingEncoding:NSUTF8StringEncoding]];

    [[note object] readInBackgroundAndNotify];
}





@end
