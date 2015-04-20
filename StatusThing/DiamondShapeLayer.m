//
//  DiamondShapeLayer.m
//  StatusThing
//
//  Created by Erik on 4/20/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "DiamondShapeLayer.h"

@implementation DiamondShapeLayer

@synthesize path = _path;
- (CGPathRef)path
{
    if ( _path == nil ) {
        CGPoint points[4] = {
            CGPointMake(CGRectGetMidX(self.bounds),CGRectGetMinY(self.bounds)),
            CGPointMake(CGRectGetMaxX(self.bounds),CGRectGetMidY(self.bounds)),
            CGPointMake(CGRectGetMidX(self.bounds),CGRectGetMaxY(self.bounds)),
            CGPointMake(CGRectGetMinX(self.bounds),CGRectGetMidY(self.bounds))
        };
        
        _path = [self drawClosedPathWithTransform:nil
                                      havingCount:sizeof(points) / sizeof(CGPoint)
                                           points:points];
    }
    return _path;
}

@end
