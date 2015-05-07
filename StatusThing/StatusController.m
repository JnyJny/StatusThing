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

static NSString *const PortMenuItemTitleFormat = @"     Listening On Port %hu";

@interface StatusController()
@property (strong,nonatomic) NSNotificationCenter *notificationCenter;
@end


@implementation StatusController

- (void)awakeFromNib
{
    [self.statusItem setMenu:self.statusMenu];
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
        [self updateWithDictionary:[NSUserDefaults standardUserDefaults].dictionaryRepresentation];
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

- (NSNotificationCenter *)notificationCenter
{
    if (!_notificationCenter) {
        _notificationCenter = [NSNotificationCenter defaultCenter];
    }
    return _notificationCenter;
}

#pragma mark - Methods

- (void)start
{
    [self.statusListener start];
    NSLog(@"listening on port %u",self.statusListener.port);
    
    [self.portMenuItem setTitle:[NSString stringWithFormat:PortMenuItemTitleFormat,self.statusListener.port]];

    [self.notificationCenter addObserver:self
                                selector:@selector(resetToIdleAppearance:)
                                    name:StatusThingIdleConfigurationChangedNotification
                                  object:nil];
    
    [self.notificationCenter addObserver:self
                                selector:@selector(restartStatusListner:)
                                    name:StatusThingNetworkConfigurationChangedNotification
                                  object:nil];

}

- (void)stop
{
    [self.notificationCenter removeObserver:self];
    
    [[NSStatusBar systemStatusBar] removeStatusItem:self.statusItem];
    [self.statusListener stop];
}

#pragma mark - IBAction Methods
// resetToIdleAppearance: does double duty as an IBAction and a notificationCenter callback

- (IBAction)resetToIdleAppearance:(id)sender
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [self.statusView removeAllAnimations];
    [self.statusView updateWithDictionary:[userDefaults dictionaryForKey:StatusThingPreferenceStatusViewDictionary]];
}

#pragma mark - StatusThing Notification Handling Methods

- (void)restartStatusListner:(NSNotification *)note
{
    
    [self.notificationCenter removeObserver:self];
    
    [self start];
}


#pragma mark - StatusListenerDelegate Methods

- (void)processRequest:(NSDictionary *)info fromClient:(NSDictionary *)clientInfo  
{
    //NSLog(@"clientInfo %@",clientInfo);
    // PeerAddressKey
    // PeerContentKey
    // PeerTimestampKey
    
    //NSLog(@"stausController.processRequest:FromClient %@",info);
    
    [self.statusView updateWithDictionary:info];
}


- (void)updateWithDictionary:(NSDictionary *)info
{

    [info enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        if ( [key isEqualToString:StatusThingPreferenceStatusViewDictionary]) {
            [self.statusView updateWithDictionary:obj];
        }

        if ( [key isEqualToString:StatusThingPreferencePortNumber]) {
            // if new port != old port, stop, re-configure, start?
            //self.statusListener.port = obj;
            //NSLog(@"newPort %@ oldPort %hu",obj,self.statusListener.port);
        }
        
    }];
}

@end
