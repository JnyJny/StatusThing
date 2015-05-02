//
//  StatusListener.m
//  StatusThing
//
//  Created by Erik on 4/16/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "StatusListener.h"
#include <sys/socket.h>
#include <netinet/in.h>

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


@interface StatusListener()

@property (strong,nonatomic) NSSocketPort         *socketPort;
@property (strong,nonatomic) NSFileHandle         *listening;
@property (strong,nonatomic) NSNotificationCenter *noteCenter;
@property (strong,nonatomic) NSNetService         *netService;
@property (assign,nonatomic) BOOL                  running;

@end

@implementation StatusListener

@synthesize port = _port;

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

- (NSNumber *)port
{
    if (!_port) {
        _port = @0;
    }
    return _port;
}

- (void)setPort:(NSNumber *)port
{
    if (self.running == NO) {
        _port = port;
    }
    else {
        NSLog(@"stop listener first to change ports");
    }
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
        
        _socketPort = [[NSSocketPort alloc] initWithTCPPort:self.port.unsignedIntegerValue];
        
        [_socketPort.address getBytes:&addr length:sizeof(addr)];
        
        _port = [NSNumber numberWithUnsignedShort:ntohs(addr.sin_port)];
    }
    return _socketPort;
}



- (NSNetService *)netService
{
    if (!_netService) {
        _netService = [[NSNetService alloc] initWithDomain:@""
                                                      type:StatusThingBonjourType
                                                      name:@""
                                                      port:self.port.unsignedShortValue];
    }
    return _netService;
}



- (NSFileHandle *)listening
{
    if (!_listening) {
        _listening = [[NSFileHandle alloc] initWithFileDescriptor:self.socketPort.socket
                                                   closeOnDealloc:NO];
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


- (BOOL)start
{
    [self.noteCenter addObserver:self
                        selector:@selector(handleNewConnection:)
                            name:NSFileHandleConnectionAcceptedNotification
                          object:self.listening];
    
    [self.listening acceptConnectionInBackgroundAndNotify];
    
    [self.netService publish];
    
    self.running = YES;
    
    return YES;
}

- (void)stop
{
    
    [self.netService stop];
    
    self.netService = nil;
    
    [self.noteCenter removeObserver:self
                               name:NSFileHandleConnectionAcceptedNotification
                             object:self.listening];
    
    [self.listening closeFile];
    
    self.socketPort = nil;
    
    self.running = NO;
}

#pragma mark - Notification Callbacks

- (void)handleNewConnection:(NSNotification *)note
{
    NSFileHandle *connected = [note.userInfo objectForKey:NSFileHandleNotificationFileHandleItem];
    
    [self.noteCenter addObserver:self
                        selector:@selector(sendDataToDelegate:)
                            name:NSFileHandleReadCompletionNotification
                          object:connected];

    [connected writeData:[StatusThingResponseWelcome dataUsingEncoding:NSUTF8StringEncoding]];
    
    [connected readInBackgroundAndNotify];
    
    [self.listening acceptConnectionInBackgroundAndNotify];
}


#pragma mark - Delegate Interaction

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
            if ( self.resetInfo )
                [self.delegate performSelector:@selector(processClientRequest:) withObject:self.resetInfo];
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
                [self.delegate performSelector:@selector(processClientRequest:)
                                    withObject:obj];
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
