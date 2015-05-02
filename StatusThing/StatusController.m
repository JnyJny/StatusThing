//
//  StatusController.m
//  StatusThing
//
//  Created by Erik on 4/16/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "StatusController.h"
#import "NSColor+NamedColorUtilities.h"

#pragma mark - String Constants

static NSString *const StatusThingStatusView = @"statusView";
static NSString *const StatusThingStatusMenu = @"statusMenu";
static NSString *const StatusThingPort       = @"port";

@implementation StatusController

#pragma mark - Lifecycle
- (instancetype)initWithPreferences:(NSDictionary *)preferences
{
    self = [super init];
    if (self) {
        [self.statusListener setDelegate:self];
        self.statusListener.resetInfo = [preferences objectForKey:StatusThingStatusView];
        
        self.statusItem.menu          = self.statusMenu;
        self.statusItem.highlightMode = YES;
        [self.statusItem.button addSubview:self.statusView];

        [self.statusView centerInRect:self.statusItem.button.bounds];
        
        [self updateWithDictionary:preferences];

        // connect statusView and statusMenu
    }
    
    return self;
}


#pragma mark - Implementation Private Properties


- (NSStatusItem *)statusItem
{
    if (!_statusItem) {
        _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    }
    return _statusItem;
}

#pragma mark - Public Properties


- (StatusView *)statusView
{
    if (!_statusView) {
        _statusView = [[StatusView alloc] init];
    }
    return _statusView;
}

- (StatusMenu *)statusMenu
{
    if (!_statusMenu) {
        _statusMenu = [[StatusMenu alloc]  init];
    }
    return _statusMenu;
}

- (StatusListener *)statusListener
{
    if (!_statusListener) {
        _statusListener = [[StatusListener alloc] init];

    }
    return _statusListener;
}


#pragma mark - Methods

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



#pragma mark - StatusListenerDelegate Methods

- (void)processClientRequest:(NSDictionary *)info
{
    [self.statusView updateWithDictionary:info];
}


- (void)updateWithDictionary:(NSDictionary *)info
{
    
    [info enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        if ( [key isEqualToString:StatusThingStatusView]) {
            [self.statusView updateWithDictionary:obj];
        }
        
        if ( [key isEqualToString:StatusThingStatusMenu]) {
            [self.statusMenu updateWithDictionary:obj];
        }
        
        if ( [key isEqualToString:StatusThingPort]) {
            self.statusListener.port = obj;
        }
        
    }];
}





@end
