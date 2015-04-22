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
        CGMutablePathRef mPath = CGPathCreateMutable();
        CGPathAddRoundedRect(mPath, nil, self.bounds, 3,3);
        _path = CGPathRetain(mPath);
    }
    return _path;
}

@end
