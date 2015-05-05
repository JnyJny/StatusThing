//
//  StatusController.m
//  StatusThing
//
//  Created by Erik on 4/16/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "StatusController.h"
#import <Foundation/Foundation.h>
#import "NSColor+NamedColorUtilities.h"
#import "PreferencesWindowController.h"
#import "StatusThingUtilities.h"

#pragma mark - String Constants

static NSString *const StatusThingStatusView   = @"statusView";
static NSString *const StatusThingStatusMenu   = @"statusMenu";
static NSString *const StatusThingPort         = @"port";
static NSString *const PortMenuItemTitleFormat = @"     Listening On Port %@";

@interface StatusController()

@end


@implementation StatusController

- (void)awakeFromNib
{
    NSDictionary *preferences = [StatusThingUtilities preferences];
    [self.statusItem setMenu:self.statusMenu];
    [self.statusListener setResetInfo:preferences];
    [self updateWithDictionary:preferences];
}

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.statusListener setDelegate:self];
        self.statusItem.highlightMode = YES;
        [self.statusItem.button addSubview:self.statusView];
        [self.statusView centerInRect:self.statusItem.button.bounds];
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
    
    [self.portMenuItem setTitle:[NSString stringWithFormat:PortMenuItemTitleFormat,self.statusListener.port]];
    //[self.portMenuItem setImage: [NSImage imageNamed:NSImageNameBonjour]];

}

- (void)stop
{
    [[NSStatusBar systemStatusBar] removeStatusItem:self.statusItem];
    [self.statusListener stop];
}




#pragma mark - StatusListenerDelegate Methods

- (void)processRequest:(NSDictionary *)info fromClient:(NSDictionary *)clientInfo  
{
    //NSLog(@"clientInfo %@",clientInfo);
    // PeerAddressKey
    // PeerContentKey
    // PeerTimestampKey
    
    [self.statusView updateWithDictionary:info];
}


- (void)updateWithDictionary:(NSDictionary *)info
{
    
    [info enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        if ( [key isEqualToString:StatusThingStatusView]) {
            [self.statusView updateWithDictionary:obj];
        }
        
#if 0
        if ( [key isEqualToString:StatusThingStatusMenu]) {
            [self.statusMenu updateWithDictionary:obj];
        }
#endif
        
        if ( [key isEqualToString:StatusThingPort]) {
            self.statusListener.port = obj;
        }
        
    }];
}

@end
