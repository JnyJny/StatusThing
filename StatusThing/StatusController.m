//
//  StatusController.m
//  StatusThing
//
//  Created by Erik on 4/16/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "StatusController.h"
#import "Konstants.h"

@interface StatusController()


@property (strong, nonatomic) NSNumber *port;
@property (strong, nonatomic) NSStatusItem *statusItem;

@end

@implementation StatusController

- (instancetype)initWithPort:(NSNumber *)port
{
    if (self = [super init]) {
        self.port = port;
        self.statusItem.menu = self.statusMenu;
        self.statusItem.button.image = self.statusImage;
        self.statusItem.highlightMode = YES;
        [self.statusListener setDelegate:self];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithPort:nil];
}

#pragma mark -
#pragma mark Implementation Private Properties

- (NSNumber *)port
{
    if( _port == nil ) {
        _port = [NSNumber numberWithUnsignedInteger:kDefaultPort];
    }
    return _port;
}

- (NSStatusItem *)statusItem
{
    if( _statusItem == nil ){
        _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    }
    return _statusItem;
}

#pragma mark -
#pragma mark Public Properties



- (StatusImage *)statusImage
{
    if ( _statusImage == nil ) {
        
        CGFloat w = [[NSStatusBar systemStatusBar] thickness];
        _statusImage = [[StatusImage alloc] initWithSize:NSMakeSize(w,w)];
    }
    
    return _statusImage;
}

- (StatusMenu *)statusMenu
{
    if ( _statusMenu == nil ){
        _statusMenu = [[StatusMenu alloc]  initWithPort:self.port];
    }
    return _statusMenu;
}

- (StatusListener *)statusListener
{
    if ( _statusListener == nil ){
        _statusListener = [[StatusListener alloc] initWithPort:self.port];
    }
    return _statusListener;
}

#pragma mark -
#pragma mark Methods

- (void)start
{
    [self.statusListener start];
}

- (void)stop
{
    [[NSStatusBar systemStatusBar] removeStatusItem:self.statusItem];
    [self.statusListener stop];
}

#pragma mark -
#pragma mark StatusListenerDelegate

- (void)processClientRequest:(NSDictionary *)info
{
    //    NSLog(@"got: %@",info);
    
    [self.statusImage bulkUpdate:info];
    
    self.statusItem.button.needsDisplay = YES;
  
}





@end
