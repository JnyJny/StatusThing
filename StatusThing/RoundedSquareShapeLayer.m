//
//  RoundedSquareShapeLayer.m
//  StatusThing
//
//  Created by Erik on 4/20/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "RoundedSquareShapeLayer.h"

@implementation RoundedSquareShapeLayer

@synthesize path = _path;

#define kCornerMetric 3

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = GeometricShapeRoundedSquare;
    }
    return self;
}

- (CGPathRef)path
{
    if (_path == nil) {
        
        CGRect rect = CGRectInset(self.bounds, kCornerMetric/2, kCornerMetric/2);
        
        CGMutablePathRef mPath = CGPathCreateMutable();
        
        CGPathAddRoundedRect(mPath, nil, rect, kCornerMetric,kCornerMetric);

        _path = CGPathRetain(mPath);
    }
    return _path;
}

@end
