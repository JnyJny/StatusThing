//
//  RoundedSquareLayer.m
//  StatusThing
//
//  Created by Erik on 4/20/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "RoundedSquareLayer.h"

@implementation RoundedSquareLayer

@synthesize path = _path;

- (CGPathRef)path
{
    if (_path == nil) {
        CGMutablePathRef mPath = CGPathCreateMutable();
        CGPathAddRoundedRect(mPath, nil, self.bounds, 4.0, 4.0);
        _path = CGPathRetain(mPath);
    }
    return _path;
}

@end
