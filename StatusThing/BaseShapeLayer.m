//
//  BaseShapeLayer.m
//  StatusThing
//
//  Created by Erik on 4/19/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "BaseShapeLayer.h"

@implementation BaseShapeLayer


- (CGRect)insetRect:(CGRect)srcRect byPercentage:(CGFloat) percentage
{
    CGFloat dx = srcRect.size.width * percentage;
    CGFloat dy = srcRect.size.height * percentage;
    
    return CGRectIntegral(CGRectInset(srcRect, dx, dy));
}

@end
