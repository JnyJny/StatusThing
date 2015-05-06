//
//  NSUserDefaults+HandleNSColor.m
//  StatusThing
//
//  Created by Erik on 5/5/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "NSUserDefaults+HandleNSColor.h"


@implementation NSUserDefaults (HandleNSColor)

- (void)setColor:(NSColor *)color forKey:(NSString *)key
{
    NSData *data = [NSArchiver archivedDataWithRootObject:color];
    [self setObject:data forKey:key];
 }

- (NSColor *)colorForKey:(NSString *)key
{
    NSColor *color = nil;
    NSData *data;
    
    data = [self dataForKey:key];

    if (data) {
        color = (NSColor *)[NSUnarchiver unarchiveObjectWithData:data];
    }
    return color;
}

@end
