//
//  GeometricShapeLayer.h
//  StatusThing
//
//  Created by Erik on 4/19/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CALayer+LayoutUtilties.h"


#define GeometricShapeNone           @"none"
#define GeometricShapeCircle         @"circle"
#define GeometricShapeSquare         @"square"
#define GeometricShapeRoundedSquare  @"roundedSquare"
#define GeometricShapeDiamond        @"diamond"
#define GeometricShapeTriangle       @"triangle"
#define GeometricShapePentagon       @"pentagon"
#define GeometricShapeHexagon        @"hexagon"
#define GeometricShapeOctogon        @"octogon"


@interface GeometricShapeLayer : CAShapeLayer

- (NSRect)insetRect:(NSRect)srcRect byPercentage:(CGFloat) percentage;

- (CGPathRef)drawClosedPathWithTransform:(CGAffineTransform *)transform havingCount:(NSInteger)count points:(CGPoint *)points;



@end
