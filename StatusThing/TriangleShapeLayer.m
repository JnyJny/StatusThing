//
//  TriangleShapeLayer.m
//  StatusThing
//
//  Created by Erik on 4/20/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "TriangleShapeLayer.h"

@implementation TriangleShapeLayer

@synthesize path = _path;

- (CGPathRef)path
{
    if (_path == nil) {
        CGPoint points[3] = {
            CGPointMake(CGRectGetMinX(self.bounds),CGRectGetMinY(self.bounds)),
            CGPointMake(CGRectGetMaxX(self.bounds),CGRectGetMinY(self.bounds)),
            CGPointMake(CGRectGetMidX(self.bounds),CGRectGetMaxY(self.bounds))
        };

        _path = [self drawClosedPathWithTransform:nil
                                      havingCount:sizeof(points)/sizeof(CGPoint)
                                           points:points];
    }
    return _path;
}
@end
