//
//  StarShapeLayer.m
//  StatusThing
//
//  Created by Erik on 4/20/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "StarShapeLayer.h"

@implementation StarShapeLayer

@synthesize path = _path;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = GeometricShapeStar;
        self.fillRule = kCAFillRuleEvenOdd;
    }
    return self;
}

- (CGPathRef)path
{
    if (_path == nil) {
        CGFloat dx = CGRectGetWidth(self.bounds) / 3.;
        CGPoint points[5] = {
            CGPointMake(CGRectGetMinX(self.bounds) + dx,CGRectGetMinY(self.bounds)), //0
            CGPointMake(CGRectGetMaxX(self.bounds),     CGRectGetMidY(self.bounds)), //2
            CGPointMake(CGRectGetMinX(self.bounds),     CGRectGetMidY(self.bounds)),  //4
            CGPointMake(CGRectGetMaxX(self.bounds) - dx,CGRectGetMinY(self.bounds)), //1
            CGPointMake(CGRectGetMidX(self.bounds),     CGRectGetMaxY(self.bounds)), //3
        };
        
        _path = [self drawClosedPathWithTransform:nil
                                      havingCount:sizeof(points) / sizeof(CGPoint)
                                           points:points];
    }
    return _path;
}
@end
