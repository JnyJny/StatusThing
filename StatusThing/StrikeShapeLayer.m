//
//  StrikeShapeLayer.m
//  StatusThing
//
//  Created by Erik on 4/20/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "StrikeShapeLayer.h"

@implementation StrikeShapeLayer

@synthesize path = _path;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = GeometricShapeStrike;
    }
    return self;
}

- (CGPathRef)path {
    if (_path == nil) {
        CGMutablePathRef mPath = CGPathCreateMutable();
        
        // draw a x
        CGPathMoveToPoint(mPath, nil, CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds));
        CGPathAddLineToPoint(mPath, nil, CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds));
        CGPathMoveToPoint(mPath, nil, CGRectGetMaxX(self.bounds), CGRectGetMinY(self.bounds));
        CGPathAddLineToPoint(mPath, nil, CGRectGetMinX(self.bounds), CGRectGetMaxY(self.bounds));

        _path = CGPathRetain(mPath);
    }
    return _path;
}
@end
