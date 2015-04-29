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

- (instancetype)initWithPreferences:(NSDictionary *)preferences
{
    self = [super init];
    if (self) {
        [self.statusListener setDelegate:self];
        self.statusListener.resetInfo = [preferences objectForKey:StatusThingStatusView];
        
        self.statusItem.menu          = self.statusMenu;
        self.statusItem.highlightMode = YES;
        self.statusItem.button.image  = nil;
        
        [self.statusItem.button addSubview:self.statusView];

        [self.statusView centerInRect:self.statusItem.button.bounds];
        
        [self updateWithDictionary:preferences];

        // connect statusView and statusMenu
    }
    
    return self;
}



#pragma mark -
#pragma mark Implementation Private Properties


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
        _statusMenu = [[StatusMenu alloc]  init];
    }
    return _statusMenu;
}

- (StatusListener *)statusListener
{
    if ( _statusListener == nil ){
        _statusListener = [[StatusListener alloc] init];

    }
    return _statusListener;
}

#pragma mark -
#pragma mark Methods

- (void)start
{
    [self.statusListener start];
    NSLog(@"listening on port %@",self.statusListener.port);
    
    self.statusMenu.port = self.statusListener.port;
}

- (void)stop
{
    [[NSStatusBar systemStatusBar] removeStatusItem:self.statusItem];
    [self.statusListener stop];
}

- (void)updateWithDictionary:(NSDictionary *)info
{
    
 [info enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
     if ( [key isEqualToString:StatusThingStatusView]) {
         [self.statusView updateWithDictionary:obj];
     }
     
     if ( [key isEqualToString:@"port"]) {
         self.statusListener.port = obj;
     }
     
 }];
}

#pragma mark -
#pragma mark StatusListenerDelegate

- (void)processClientRequest:(NSDictionary *)info
{
    NSLog(@"processClientRequest: %@",info);
    
    [self.statusView updateWithDictionary:info];
}





@end
