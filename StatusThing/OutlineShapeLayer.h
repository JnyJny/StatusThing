//
//  OutlineShapeLayer.h
//  StatusThing
//
//  Created by Erik on 4/19/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "StatusShapeLayer.h"

#define OutlineShapeLayerName @"OutlineShapeLayer"


@interface OutlineShapeLayer : StatusShapeLayer {
    CGColorRef _light;
    CGColorRef _dark;
}


@end
