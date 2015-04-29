//
//  StatusMenu.h
//  StatusThing
//
//  Created by Erik on 4/16/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface StatusMenu : NSMenu


@property (strong, nonatomic) NSNumber *port;
@property (strong, nonatomic) NSMenu *messageSubmenu;

- (void)setMessage:(NSString *)message;


@end
