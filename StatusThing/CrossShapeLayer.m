//
//  CrossShapeLayer.m
//  StatusThing
//
//  Created by Erik on 4/20/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "CrossShapeLayer.h"

@implementation CrossShapeLayer

@synthesize path = _path;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = GeometricShapeCross;
    }
    return self;
}

- (CGPathRef)path {
    if (_path == nil) {
        CGMutablePathRef mPath = CGPathCreateMutable();
        
        // draw a +
        CGPathMoveToPoint(mPath, nil, CGRectGetMinX(self.bounds), CGRectGetMidY(self.bounds));
        CGPathAddLineToPoint(mPath, nil, CGRectGetMaxX(self.bounds), CGRectGetMidY(self.bounds));
        CGPathMoveToPoint(mPath, nil, CGRectGetMidX(self.bounds), CGRectGetMinY(self.bounds));
        CGPathAddLineToPoint(mPath, nil, CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds));

        _path = CGPathRetain(mPath);
    }
    return _path;
}

@end
