//
//  NSColor+NamedColorUtilities.h
//  StatusThing
//
//  Created by Erik on 4/18/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSColor (NamedColorUtilities)

+ (NSColor *)colorForObject:(id)object;
+ (NSColor *)colorForString:(NSString *)colorString;
+ (NSColor *)colorForDictionary:(NSDictionary *)info;
- (NSDictionary *)dictionaryForColor;
+ (NSArray *)allColorNames;

@end
