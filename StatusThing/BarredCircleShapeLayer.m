//
//  BarredCircleShapeLayer.m
//  StatusThing
//
//  Created by Erik on 4/21/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "BarredCircleShapeLayer.h"

@implementation BarredCircleShapeLayer

@synthesize path = _path;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = GeometricShapeBarredCircle;
    }
    return self;
}

- (CGPathRef)path
{
    if (_path == nil) {
        CGMutablePathRef mPath = CGPathCreateMutable();
        
        // draw a circle
        CGPathAddEllipseInRect(mPath, nil, self.bounds);
        // draw a bar
        CGPathMoveToPoint(mPath, nil, CGRectGetMinX(self.bounds), CGRectGetMidY(self.bounds));
        CGPathAddLineToPoint(mPath, nil, CGRectGetMaxX(self.bounds), CGRectGetMidY(self.bounds));
        _path = CGPathRetain(mPath);
    }
    return _path;
}

@end
