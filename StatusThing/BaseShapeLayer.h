//
//  BaseShapeLayer.h
//  StatusThing
//
//  Created by Erik on 4/19/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface BaseShapeLayer : CAShapeLayer

#define GeometricShapeNone           @"none"
#define GeometricShapeCircle         @"circle"
#define GeometricShapeSquare         @"square"
#define GeometricShapeRoundedSquare  @"roundedSquare"
#define GeometricShapeDiamond        @"diamond"
#define GeometricShapeTriangle       @"triangle"
#define GeometricShapePentagon       @"pentagon"
#define GeometricShapeHexagon        @"hexagon"
#define GeometricShapeOctogon        @"octogon"



- (CGPathRef)drawClosedPathWithTransform:(CGAffineTransform *)transform havingCount:(NSInteger)count points:(CGPoint *)points;

- (NSRect)insetRect:(NSRect)srcRect byPercentage:(CGFloat) percentage;

@end
