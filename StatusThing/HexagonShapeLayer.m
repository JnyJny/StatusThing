//
//  HexagonShapeLayer.m
//  StatusThing
//
//  Created by Erik on 4/20/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "HexagonShapeLayer.h"

@implementation HexagonShapeLayer

@synthesize path = _path;

- (CGPathRef)path
{
    if (_path == nil) {
        CGFloat dx = CGRectGetWidth(self.bounds) / 4;
        CGPoint points[6] = {
            CGPointMake(CGRectGetMinX(self.bounds) + dx,CGRectGetMinY(self.bounds)),
            CGPointMake(CGRectGetMaxX(self.bounds) - dx,CGRectGetMinY(self.bounds)),
            CGPointMake(CGRectGetMaxX(self.bounds),     CGRectGetMidY(self.bounds)),
            CGPointMake(CGRectGetMaxX(self.bounds) - dx,CGRectGetMaxY(self.bounds)),
            CGPointMake(CGRectGetMinX(self.bounds) + dx,CGRectGetMaxY(self.bounds)),
            CGPointMake(CGRectGetMinX(self.bounds),     CGRectGetMidY(self.bounds))
        };
        
        _path = [self drawClosedPathWithTransform:nil
                                      havingCount:sizeof(points)/sizeof(CGPoint)
                                           points:points];
    }
    return _path;
}
@end
