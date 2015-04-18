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
#import "StatusImage.h"

@interface StatusController : NSObject <StatusListenerDelegate>

@property (nonatomic, strong) StatusMenu *statusMenu;
@property (nonatomic, strong) StatusListener *statusListener;
@property (nonatomic, strong) StatusImage *statusImage;

- (instancetype)initWithPort:(NSNumber *)port;

- (void)start;
- (void)stop;

@end
