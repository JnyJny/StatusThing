//
//  StatusController.h
//  StatusThing
//
//  Created by Erik on 4/16/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "StatusMenu.h"
#import "StatusListener.h"
#import "StatusView.h"

#define StatusThingStatusView @"statusView"

@interface StatusController : NSObject <StatusListenerDelegate>

@property (strong, nonatomic) NSStatusItem *statusItem;
@property (strong, nonatomic) StatusView *statusView;
@property (strong, nonatomic) StatusMenu *statusMenu;
@property (strong, nonatomic) StatusListener *statusListener;

- (instancetype)initWithPreferences:(NSDictionary *)preferences;

- (void)start;
- (void)stop;

@end
