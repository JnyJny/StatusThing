//
//  GeometricShapeLayer.m
//  StatusThing
//
//  Created by Erik on 4/19/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "GeometricShapeLayer.h"
#import <math.h>



@implementation GeometricShapeLayer

+ (instancetype)layer
{
    return [super layer];
}

#pragma mark -
#pragma mark Overridden Properties


#pragma mark -
#pragma mark Category Overriding Methods

- (void)layoutSublayerOfLayer:(CALayer *)layer
{
    CGPoint center = CGPointMake(CGRectGetMidX(layer.bounds),
                                 CGRectGetMidY(layer.bounds));
    self.bounds = layer.bounds;
    self.position = center;
}

#pragma mark -
#pragma mark Class Methods

- (CGPathRef)drawClosedPathWithTransform:(CGAffineTransform *)transform havingCount:(NSInteger)count points:(CGPoint *)points
{
    CGMutablePathRef p = CGPathCreateMutable();
    
    CGPathMoveToPoint(p, NULL, points[0].x, points[0].y);
    
    CGPathAddLines(p, transform, points, count);
    
    CGPathCloseSubpath(p);
    
    return CGPathRetain(p);
}

- (CGRect)insetRect:(CGRect)srcRect byPercentage:(CGFloat) percentage
{
    CGFloat dx = srcRect.size.width * percentage;
    CGFloat dy = srcRect.size.height * percentage;
    
    return CGRectIntegral(CGRectInset(srcRect, dx, dy));
}





@end
