//
//  StatusShapeLayer.h
//  StatusThing
//
//  Created by Erik on 4/19/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "BaseShapeLayer.h"

#define StatusShapeLayerName      @"StatusShapeLayer"

#define StatusShapeNone           @"none"
#define StatusShapeCircle         @"circle"
#define StatusShapeSquare         @"square"
#define StatusShapeRoundedSquare  @"roundedSquare"
#define StatusShapeDiamond        @"diamond"
#define StatusShapeTriangle       @"triangle"
#define StatusShapePentagon       @"pentagon"
#define StatusShapeHexagon        @"hexagon"
#define StatusShapeOctogon        @"octogon"


@interface StatusShapeLayer : BaseShapeLayer

@property (strong,nonatomic) NSString *shape;

@end
