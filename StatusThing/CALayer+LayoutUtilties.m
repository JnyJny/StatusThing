//
//  CALayer+LayoutUtilties.m
//  StatusThing
//
//  Created by Erik on 4/20/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "CALayer+LayoutUtilties.h"

@implementation CALayer (CALayer_LayoutUtilties)

- (void)layoutSublayerOfLayer:(CALayer *)layer
{
    CGPoint center = CGPointMake(CGRectGetMidX(layer.bounds),
                                 CGRectGetMidY(layer.bounds));
    
    self.bounds = layer.bounds;
    self.position = center;
}

@end
