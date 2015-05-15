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


static NSString * const StatusThingBonjourType                    = @"_statusthing._tcp.";

// moves to StatusController

NSString *const RequestKeyAddress   = @"address";
NSString *const RequestKeyPort      = @"port";
NSString *const RequestKeyTimestamp = @"timestamp";
NSString *const RequestKeyContent   = @"content";

NSString *const ResponseKeyAction   = @"action";
NSString *const ResponseKeyData     = @"data";
NSString *const ResponseKeyPrompt   = @"prompt";

NSString *const ResponseActionError = @"error";
NSString *const ResponseActionOk    = @"ok";
NSString *const ResponseActionDone  = @"done";



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
    
    [self.netService publish];
    
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
    NSDictionary *response = nil;
    
    if (!self.delegate) {
        [self shutdownFileHandle:connected];
        [self.listening acceptConnectionInBackgroundAndNotify];
        return;
        //NOTREACHED
    }
    
    response = [self.delegate performSelector:@selector(clientDidConnect:)
                                   withObject:[self peerInfoForFileHandle:connected
                                                              withContent:nil]];

    if (!response ||
        ([ResponseActionDone caseInsensitiveCompare:response[ResponseKeyAction]] == NSOrderedSame) ) {
        [self shutdownFileHandle:connected];
        [self.listening acceptConnectionInBackgroundAndNotify];
        return;
        // NOTREACHED
    }
    
    if ( response[ResponseKeyData] ) {
        
        BOOL handled = NO;
        
        if ( [response[ResponseKeyData] isKindOfClass:NSData.class] ) {
            [connected writeData:response[ResponseKeyData]];
            handled = YES;
        }
        
        if ( !handled && [response[ResponseKeyData] isKindOfClass:NSString.class] ) {
            [connected writeData:[response[ResponseKeyData] dataUsingEncoding:NSUTF8StringEncoding]];
            handled = YES;
        }
        
        if (!handled) {
            // XXX if delegate sends something other than NSString or NSData in ResponseKeyData
            //     maybe we should shutdown? at least make an error noise
            NSLog(@"StatusListener.handleNewConnection: delegate ResponseKeyData = %@",
                  response[ResponseKeyData]);
        }
    }
    
    [connected readInBackgroundAndNotify];
    
    [self.noteCenter addObserver:self
                        selector:@selector(informDelegate:)
                            name:NSFileHandleReadCompletionNotification
                          object:connected];
    
    [self.listening acceptConnectionInBackgroundAndNotify];
}


#pragma mark - Delegate Interaction

- (NSDictionary *)peerInfoForFileHandle:(NSFileHandle*)fileHandle withContent:(NSData *)optionalContent
{
    struct sockaddr_in ip4;
    socklen_t ip4len = sizeof(ip4);
    NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
    
    // XXX error checking on return value of getpeername
    getpeername(fileHandle.fileDescriptor, (struct sockaddr *)&ip4,&ip4len);
    
    info[RequestKeyAddress]   = [NSString stringWithCString:inet_ntoa(ip4.sin_addr)
                                                   encoding:NSUTF8StringEncoding];
    info[RequestKeyPort]      = [NSNumber numberWithUnsignedShort:ntohs(ip4.sin_port)];
    info[RequestKeyTimestamp] = [NSDate date];
    
    if (optionalContent) {
        info[RequestKeyContent] = optionalContent;
    }
    
    return info;
}

- (void)shutdownFileHandle:(NSFileHandle *)fileHandle
{
    [self.noteCenter removeObserver:self
                               name:NSFileHandleReadCompletionNotification
                             object:fileHandle];
    [fileHandle closeFile];
}




- (void)informDelegate:(NSNotification *)note
{
    NSFileHandle *connected = [note object];
    NSData       *dataIn    = [[note userInfo] objectForKey:NSFileHandleNotificationDataItem];
    NSDictionary *request;
    NSDictionary *response;
    
    if (!self.delegate) {
        // kill the connection, there is nobody to talk to on our side.
        [self shutdownFileHandle:connected];
        return;
        // NOTREACHED
    }
    
    request = [self peerInfoForFileHandle:connected withContent:dataIn];
    
    response = [self.delegate performSelector:@selector(processRequest:) withObject:request];
    
    if (response) {
        
        if (response[ResponseKeyData]) {
            if ([response[ResponseKeyData] isKindOfClass:NSString.class]) {
                [connected writeData:[response[ResponseKeyData] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            if ([response[ResponseKeyData] isKindOfClass:NSData.class]) {
                [connected writeData:response[ResponseKeyData]];
            }
        }
    }
    else {
        // No news is good news?
    }
    
    if ([response[ResponseKeyAction] isEqualToString:ResponseActionDone]) {
        [self shutdownFileHandle:connected];
        return;
        // NOTREACHED
    }

    [[note object] readInBackgroundAndNotify];
}



@end
