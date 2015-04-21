//
//  GeometricShapeLayer.m
//  StatusThing
//
//  Created by Erik on 4/19/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "GeometricShapeLayer.h"

@implementation GeometricShapeLayer

+ (instancetype)layer
{
    return [super layer];
}

- (void)layoutSublayerOfLayer:(CALayer *)layer
{
    CGPoint center = CGPointMake(CGRectGetMidX(layer.bounds),
                                 CGRectGetMidY(layer.bounds));
    self.bounds = self.bounds;
    self.position = center;
    
}


- (CGRect)insetRect:(CGRect)srcRect byPercentage:(CGFloat) percentage
{
    CGFloat dx = srcRect.size.width * percentage;
    CGFloat dy = srcRect.size.height * percentage;
    
    return CGRectIntegral(CGRectInset(srcRect, dx, dy));
}

#pragma mark -
#pragma mark Utility Method

- (CGPathRef)drawClosedPathWithTransform:(CGAffineTransform *)transform havingCount:(NSInteger)count points:(CGPoint *)points
{
    CGMutablePathRef p = CGPathCreateMutable();
    
    CGPathMoveToPoint(p, NULL, points[0].x, points[0].y);
    
    CGPathAddLines(p, transform, points, count);
    
    CGPathCloseSubpath(p);
    
    return CGPathRetain(p);
}

@end
