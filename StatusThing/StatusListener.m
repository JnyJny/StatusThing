//
//  StatusListener.m
//  StatusThing
//
//  Created by Erik on 4/16/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "StatusListener.h"
#import "Konstants.h"
#include <sys/socket.h>
#include <netinet/in.h>

@interface StatusListener()

@property (strong,nonatomic) NSSocketPort *sock;
@property (strong,nonatomic) NSFileHandle *listening;
@property (strong,nonatomic) NSNotificationCenter *noteCenter;
@end

@implementation StatusListener

@synthesize port = _port;

- (instancetype)initWithPort:(NSNumber *)port
{
    self = [super init];
    if (self) {
        _port = port;

    }
    return self;
}

#pragma mark -
#pragma mark Properties

- (NSNumber *)port
{
    if (_port == nil) {
        _port = [NSNumber numberWithUnsignedInteger:kDefaultPort];
    }
    return _port;
}

- (void)setPort:(NSNumber *)port
{
    _port = port;
    // shutdown existing socket? restart with new port?
    // or wait for caller to "start" again.
}

#pragma mark -
#pragma mark Private Properties
- (NSSocketPort *)sock
{
    if ( _sock == nil ) {
        _sock = [[NSSocketPort alloc] initWithTCPPort:self.port.unsignedIntValue];
    }
    return _sock;
}

/* this method exists for debugging. creating the socket the long way allows
 * us to set SO_REUSEADDR which must be done before the socket is allocated.
 *
 */
- (int)socket
{
    int fd = -1;
    CFSocketRef socket;
    
    socket = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_STREAM,
                            IPPROTO_TCP, 0, NULL, NULL);
    if( socket ) {
        fd = CFSocketGetNative(socket);
        int yes = 1;
        setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, (void *)&yes, sizeof(yes));
        struct sockaddr_in addr;
        memset(&addr, 0, sizeof(addr));
        addr.sin_len = sizeof(addr);
        addr.sin_family = AF_INET;
        addr.sin_port = htons(self.port.unsignedIntValue);
        addr.sin_addr.s_addr = htonl(INADDR_ANY);
        NSData *address = [NSData dataWithBytes:&addr length:sizeof(addr)];
        if( CFSocketSetAddress(socket, (CFDataRef)address) !=
           kCFSocketSuccess ) {
            NSLog(@"Could not bind to address");
            return -1;
        }
    } else {
        NSLog(@"No server socket");
        return -1;
    }
    
    return fd;
}

- (NSFileHandle *)listening
{
    if (_listening == nil) {
#if 0
        _listening = [[NSFileHandle alloc] initWithFileDescriptor:[self.sock socket]];
#else
        _listening = [[NSFileHandle alloc] initWithFileDescriptor:[self socket]
                                                   closeOnDealloc:YES];
#endif
    }
    return _listening;
}

- (NSNotificationCenter *)noteCenter
{
    if ( _noteCenter == nil ) {
        _noteCenter = [NSNotificationCenter defaultCenter];
    }
    return _noteCenter;
}

#pragma mark -
#pragma mark Methods


- (void)start
{
    [self.noteCenter addObserver:self
                        selector:@selector(handleNewConnection:)
                            name:NSFileHandleConnectionAcceptedNotification
                          object:self.listening];
    
    [self.listening acceptConnectionInBackgroundAndNotify];

}

- (void)handleNewConnection:(NSNotification *)note
{
    NSFileHandle *connected = [note.userInfo objectForKey:NSFileHandleNotificationFileHandleItem];

    [self.noteCenter addObserver:self
                        selector:@selector(sendDataToDelegate:)
                            name:NSFileHandleReadCompletionNotification
                          object:connected];

    [connected writeData:[kWelcome dataUsingEncoding:NSUTF8StringEncoding]];
    [connected readInBackgroundAndNotify];
    
    [self.listening acceptConnectionInBackgroundAndNotify];
}

- (void)sendDataToDelegate:(NSNotification *)note
{
    NSFileHandle *connected = [note object];
    NSData *data = [[note userInfo] objectForKey:NSFileHandleNotificationDataItem];
    NSError *error;
    

    if ( data.length == 0 ) {
        [self.noteCenter removeObserver:self
                                   name:NSFileHandleReadCompletionNotification
                                 object:connected];
        [connected closeFile];
        return;
    }
    
    id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if ( obj == nil ) {
        NSLog(@"NSJSONSerialization error: %@",error);
    }
    else {
        if ( self.delegate != nil ) {
            [self.delegate performSelector:@selector(processClientRequest:)
                                withObject:obj];
        }
    }
    
    [[note object] readInBackgroundAndNotify];
}


- (void)stop
{
    [self.noteCenter removeObserver:self
                               name:NSFileHandleConnectionAcceptedNotification
                             object:self.listening  ];

    [self.listening closeFile];
}


@end
