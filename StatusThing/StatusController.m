//
//  StatusController.m
//  StatusThing
//
//  Created by Erik on 4/16/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "StatusController.h"
#import "NSColor+NamedColorUtilities.h"
#import "Konstants.h"

/* StatusController
 *
 * Coordinates the input from StatusListener and updates 
 * StatusView and StatusMenu accordingly.
 */

@implementation StatusController

- (instancetype)initWithPort:(NSNumber *)port
{
    self = [super init];
    if (self) {
        self.port = port;
        [self.statusListener setDelegate:self];
        self.statusItem.menu = self.statusMenu;
        self.statusItem.highlightMode = YES;
        self.statusItem.button.image = nil;
        [self.statusItem.button addSubview:self.statusView];

        [self.statusView centerInRect:self.statusItem.button.bounds];

        // connect statusView and statusMenu
        // get userDefaults
        // invoke updateConfigurationWithDictionary: on statusView with userDefaults
        //
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
        _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    }
    return _statusItem;
}

#pragma mark -
#pragma mark Public Properties


- (StatusView *)statusView
{
    if ( _statusView == nil ) {
        _statusView = [[StatusView alloc] init];
    }
    return _statusView;
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
    
    [self.statusView updateWithDictionary:info];
}





@end
