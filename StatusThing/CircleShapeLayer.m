//
//  CircleShapeLayer.m
//  StatusThing
//
//  Created by Erik on 4/20/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "CircleShapeLayer.h"

@implementation CircleShapeLayer

@synthesize path = _path;

- (CGPathRef)path
{
    if ( _path == nil ) {
        CGMutablePathRef mPath = CGPathCreateMutable();
        CGPathAddEllipseInRect(mPath, nil, self.bounds);
        _path = CGPathRetain(mPath);
    }
    return _path;
}

@end
