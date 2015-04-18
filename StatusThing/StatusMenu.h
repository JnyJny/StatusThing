//
//  StatusMenu.h
//  StatusThing
//
//  Created by Erik on 4/16/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface StatusMenu : NSMenu


- (instancetype)initWithPort:(NSNumber *)port;
- (instancetype)initWithPort:(NSNumber *)port andMessage:(NSString *)message;

- (void)setMessage:(NSString *)message;


@end
