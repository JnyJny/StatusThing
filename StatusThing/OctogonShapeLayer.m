//
//  OctogonShapeLayer.m
//  StatusThing
//
//  Created by Erik on 4/20/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "OctogonShapeLayer.h"

@implementation OctogonShapeLayer

@synthesize path = _path;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = GeometricShapeOctogon;
    }
    return self;
}

- (CGPathRef)path
{
    if (_path == nil) {
        CGFloat dx = CGRectGetWidth(self.bounds) / 3;
        CGFloat dy = CGRectGetHeight(self.bounds) / 3;
        CGPoint points[8] = {
            CGPointMake(CGRectGetMinX(self.bounds) + dx,CGRectGetMinY(self.bounds)),
            CGPointMake(CGRectGetMaxX(self.bounds) - dx,CGRectGetMinY(self.bounds)),
            CGPointMake(CGRectGetMaxY(self.bounds),     CGRectGetMinY(self.bounds) + dy),
            CGPointMake(CGRectGetMaxX(self.bounds),     CGRectGetMaxY(self.bounds) - dy),
            CGPointMake(CGRectGetMaxX(self.bounds) - dx,CGRectGetMaxY(self.bounds)),
            CGPointMake(CGRectGetMinX(self.bounds) + dx,CGRectGetMaxY(self.bounds)),
            CGPointMake(CGRectGetMinX(self.bounds),     CGRectGetMaxY(self.bounds) - dy),
            CGPointMake(CGRectGetMinX(self.bounds),     CGRectGetMinY(self.bounds) + dy)
        };
        
        _path = [self drawClosedPathWithTransform:nil
                                      havingCount:sizeof(points)/sizeof(CGPoint)
                                           points:points];
    }
    return _path;
}
@end
