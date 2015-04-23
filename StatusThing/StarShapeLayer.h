//
//  StarShapeLayer.h
//  StatusThing
//
//  Created by Erik on 4/20/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "RegularPolygonLayer.h"

#define GeometricShapeStar @"star"

@interface StarShapeLayer : RegularPolygonLayer

@property (assign,nonatomic) CGFloat points;
@property (assign,nonatomic) CGFloat minorRadius;
@property (assign,nonatomic,readonly) CGFloat minorTheta;
@end
