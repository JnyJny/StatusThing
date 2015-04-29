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

@property (strong,nonatomic) NSSocketPort         *socketPort;
@property (strong,nonatomic) NSFileHandle         *listening;
@property (strong,nonatomic) NSNotificationCenter *noteCenter;
@property (strong,nonatomic) NSNetService         *netService;
@property (assign,nonatomic) BOOL                  running;

@end

@implementation StatusListener

@synthesize port = _port;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.running = NO;
    }
    return self;
}

#pragma mark -
#pragma mark Properties

- (NSNumber *)port
{
    if (_port == nil) {
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
    if (_helpText == nil) {
        _helpText = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:StatusThingHelpFile ofType:@""]
                                              encoding:NSUTF8StringEncoding
                                                 error:nil];
        if (_helpText == nil)
            _helpText = @"NO HELP TEXT AVAILABLE.\n> ";
    }
    return _helpText;
}


#pragma mark -
#pragma mark Private Properties

- (NSSocketPort *)socketPort
{
    if ( _socketPort == nil ) {
        struct sockaddr_in addr;
        
        _socketPort = [[NSSocketPort alloc] initWithTCPPort:self.port.unsignedIntegerValue];
        
        [_socketPort.address getBytes:&addr length:sizeof(addr)];
        
        _port = [NSNumber numberWithUnsignedShort:ntohs(addr.sin_port)];
    }
    return _socketPort;
}



- (NSNetService *)netService
{
    if (_netService == nil) {
        _netService = [[NSNetService alloc] initWithDomain:@""
                                                      type:StatusThingBonjourType
                                                      name:@""
                                                      port:self.port.unsignedShortValue];
    }
    return _netService;
}



- (NSFileHandle *)listening
{
    if (_listening == nil) {
        _listening = [[NSFileHandle alloc] initWithFileDescriptor:self.socketPort.socket
                                                   closeOnDealloc:NO];
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

- (void)handleNewConnection:(NSNotification *)note
{
    NSFileHandle *connected = [note.userInfo objectForKey:NSFileHandleNotificationFileHandleItem];
    
    [self.noteCenter addObserver:self
                        selector:@selector(sendDataToDelegate:)
                            name:NSFileHandleReadCompletionNotification
                          object:connected];

    [connected writeData:[StatusThingWelcome dataUsingEncoding:NSUTF8StringEncoding]];
    
    [connected readInBackgroundAndNotify];
    
    [self.listening acceptConnectionInBackgroundAndNotify];
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
            [connected writeData:[StatusThingGoodbye dataUsingEncoding:NSUTF8StringEncoding]];
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
            response = self.resetInfo?StatusThingResponseOK:@"reset is unavailable.";
            break;
            
        default:
            
            if (self.delegate == nil) {
                response = [NSString stringWithFormat:StatusThingResponseErrFmt,@"author forgot to set the delegate. Author sucks."];
                break;
            }
            
            obj = [NSJSONSerialization JSONObjectWithData:data
                                                  options:0
                                                    error:&error];
    
            if ( obj == nil ) {
                response = [NSString stringWithFormat:StatusThingResponseErrFmt,error.localizedFailureReason];
                break;
            }

            if ([obj isKindOfClass:[NSDictionary class]]){
                [self.delegate performSelector:@selector(processClientRequest:)
                                    withObject:obj];
                response = StatusThingResponseOK;
                break;
            }
            
            if ([obj isKindOfClass:[NSArray class]]) {
                [self.delegate performSelector:@selector(updateWithArray:)
                                    withObject:obj];
                response = StatusThingResponseOK;
            }
            break;
    }
    
    [connected writeData:[response dataUsingEncoding:NSUTF8StringEncoding]];

    [[note object] readInBackgroundAndNotify];
}





@end
