//
//  SymbolShapeLayer.m
//  StatusThing
//
//  Created by Erik on 4/19/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "SymbolShapeLayer.h"
#import "NSColor+NamedColorUtilities.h"

@implementation SymbolShapeLayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = SymbolShapeLayerName;
        self.backgroundColor = nil;
        self.alignmentMode = kCAAlignmentCenter;
        self.string = @"";
        self.font = CFBridgingRetain(@"Courier");
        self.fontSize = 12;
    }
    return self;
}

- (void)setFontSize:(CGFloat)fontSize
{
    [super setFontSize:fontSize];
    [self setNeedsLayout];
}


- (void)rotateBy:(CGFloat)degrees
{
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    rotate.duration = 10;
    rotate.fromValue = [NSNumber numberWithFloat:0];
    rotate.toValue = [NSNumber numberWithFloat:M_PI * 2];
    [self addAnimation:rotate forKey:@"rotate"];

}

- (void)updateWithDictionary:(NSDictionary *)info
{

    [info enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        BOOL handled = NO;
        
        if (!handled && [key isEqualToString:@"background"]) {
            self.backgroundColor = [[NSColor colorForObject:obj] CGColor];
            handled = YES;
        }
        
        if (!handled && [key isEqualToString:@"font"]) {
            self.font = CFBridgingRetain(obj);
            handled = YES;
        }
        
        if (!handled && [key isEqualToString:@"fontSize"]) {
            self.fontSize = [obj floatValue];
            handled = YES;
        }


        
        if (!handled && [key isEqualToString:@"foreground"]) {
            self.foregroundColor = [[NSColor colorForObject:obj] CGColor];
            handled = YES;
        }

        if (!handled && [key isEqualToString:@"string"]) {
            self.string = obj;
            handled = YES;
        }
        
        if (!handled && [key isEqualToString:@"hidden"]) {
            self.hidden = [obj boolValue];
            handled = YES;
        }

        if (!handled && [key isEqualToString:@"rotate"]) {
            [self rotateBy:[obj floatValue]];
        }

        
        
        
        
    }];
    
}




@end
