//
//  NSColor+NamedColorUtilities.m
//  StatusThing
//
//  Created by Erik on 4/18/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "NSColor+NamedColorUtilities.h"

@implementation NSColor (NamedColorUtilities)


+ (NSColor *)colorForObject:(id)object
{
    if ( [object isKindOfClass:[NSString class]])
        return [NSColor colorForString:object];

    if ( [object isKindOfClass:[NSDictionary class]]) {
        return [NSColor colorForDictionary:object];
    }
    
    return nil;
}

+ (NSColor *)colorForString:(NSString *)colorString
{
    NSColor *color = nil;
    
    // XXX not especially performant, but it does find a variety of colors by name
    
    for ( NSColorList *colorList in [NSColorList availableColorLists] ) {
        color = [colorList colorWithKey:[colorString capitalizedString]];
        if (color != nil ) {
            return color;
        }
    }
    
    return nil;
}

#define NegativeToZero(V) ((V)<0)?0.0:(V)
#define ScaleFrom255(V)  ((V)>1.0)?(V)/255.f:(V)
#define Scale(V) ScaleFrom255(NegativeToZero((V)))

+ (NSColor *)colorForDictionary:(NSDictionary *)info
{
    // info may have red, blue, green, alpha key/values  empty dictionary is black
    
    CGFloat red = 0;
    CGFloat green = 0;
    CGFloat blue = 0;
    CGFloat alpha = 1.0;
    
    red = [[info valueForKey:@"red"] floatValue];
    green = [[info valueForKey:@"green"] floatValue];
    blue = [[info valueForKey:@"blue"] floatValue];
    alpha = [[info valueForKey:@"alpha"] floatValue];
    
    return [NSColor colorWithRed:Scale(red) green:Scale(green) blue:Scale(blue) alpha:Scale(alpha)];
}

@end
