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

- (void)centerInRect:(CGRect)rect
{
    self.position = CGPointMake(CGRectGetMidX(rect),
                                CGRectGetMidY(rect));
    
}

- (void)centerInRect:(CGRect)rect andInset:(CGPoint)delta
{
    [self centerInRect:rect];
    CGRect inset = CGRectInset(rect, delta.x, delta.y);
    self.bounds = CGRectIntegral(inset);
}



@end
