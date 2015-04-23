//
//  GeometricShapeLayer.h
//  StatusThing
//
//  Created by Erik on 4/19/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CALayer+LayoutUtilties.h"


@interface GeometricShapeLayer : CAShapeLayer


// initialAngle is the angle between the x axis and the first vertex in the figure in radians


- (NSRect)insetRect:(NSRect)srcRect byPercentage:(CGFloat) percentage;



- (CGPathRef)drawClosedPathWithTransform:(CGAffineTransform *)transform havingCount:(NSInteger)count points:(CGPoint *)points;



@end
