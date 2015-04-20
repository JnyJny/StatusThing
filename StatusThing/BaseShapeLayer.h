//
//  BaseShapeLayer.h
//  StatusThing
//
//  Created by Erik on 4/19/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface BaseShapeLayer : CAShapeLayer

- (NSRect)insetRect:(NSRect)srcRect byPercentage:(CGFloat) percentage;

@end
