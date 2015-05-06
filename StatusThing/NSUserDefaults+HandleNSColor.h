//
//  NSUserDefaults+HandleNSColor.h
//  StatusThing
//
//  Created by Erik on 5/5/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface NSUserDefaults (HandleNSColor)
- (void)setColor:(NSColor *)color forKey:(NSString *)key;
- (NSColor *)colorForKey:(NSString *)key;
@end
