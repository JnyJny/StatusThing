//
//  NSColor+NamedColorUtilities.m
//  StatusThing
//
//  Created by Erik on 4/18/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "NSColor+NamedColorUtilities.h"


NSString *const RGBAColorComponentRed   = @"red";
NSString *const RGBAColorComponentGreen = @"green";
NSString *const RGBAColorComponentBlue  = @"blue";
NSString *const RGBAColorComponentAlpha = @"alpha";

@implementation NSColor (NamedColorUtilities)


+ (NSColor *)colorForObject:(id)object
{
 
    if ( [object isKindOfClass:[NSString class]]) {
        return [NSColor colorForString:object];
    }
    
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
    
    red = [[info valueForKey:RGBAColorComponentRed] floatValue];
    green = [[info valueForKey:RGBAColorComponentGreen] floatValue];
    blue = [[info valueForKey:RGBAColorComponentBlue] floatValue];
    alpha = [[info valueForKey:RGBAColorComponentAlpha] floatValue];
    
    return [NSColor colorWithRed:Scale(red) green:Scale(green) blue:Scale(blue) alpha:Scale(alpha)];
}

- (NSDictionary *)dictionaryForColor
{
    NSColor *calibratedColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
    CGFloat red,green,blue,alpha;
    
    [calibratedColor getRed:&red green:&green blue:&blue alpha:&alpha];
    
    return @{ RGBAColorComponentRed:[NSNumber numberWithFloat:red],
              RGBAColorComponentGreen:[NSNumber numberWithFloat:green],
              RGBAColorComponentBlue:[NSNumber numberWithFloat:blue],
              RGBAColorComponentAlpha:[NSNumber numberWithFloat:alpha]};
}



+ (NSColor *)colorForArray:(NSArray *)rgbaValues
{
    // what to do for values with counts of 0,1,2,3
    
    NSArray *cNames = @[RGBAColorComponentRed,
                        RGBAColorComponentGreen,
                        RGBAColorComponentBlue,
                        RGBAColorComponentAlpha];
    
    NSDictionary *info = [NSDictionary dictionaryWithObjects:rgbaValues
                                                     forKeys:cNames];

    
    return [NSColor colorForDictionary:info];
    
    
    
}

@end
