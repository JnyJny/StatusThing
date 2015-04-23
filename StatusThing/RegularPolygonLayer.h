//
//  RegularPolygonLayer.h
//  StatusThing
//
//  Created by Erik on 4/22/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "GeometricShapeLayer.h"

#define GeometricShapePoint     @"point"
#define GeometricShapeLine      @"line"

#define GeometricShapeTriangle  @"triangle"
#define GeometricShapeSquare    @"square"
#define GeometricShapePentagon  @"pentagon"
#define GeometricShapeHexagon   @"hexagon"
#define GeometricShapeSeptagon  @"septagon"
#define GeometricShapeOctogon   @"octogon"
#define GeometricShapeNonagon   @"nonagon"
#define GeometricShapeDecagon   @"decagon"
#define GeometricShapeEndecagon @"endecagon"

#define M_2PI  6.283185307179586    // 2*PI

@interface RegularPolygonLayer : GeometricShapeLayer
@property (assign,nonatomic)          NSInteger sides;
@property (assign,nonatomic)          CGFloat   initialAngle;
@property (strong,nonatomic,readonly) NSArray   *names;

- (void)updateWithDictionary:(NSDictionary *)info;

- (CGPoint *)verticesCenteredAt:(CGPoint)origin withNumberOfSides:(NSInteger)sides andRadius:(CGFloat)radius andInitialAngleInRadians:(CGFloat)initialAngle;

- (CGPoint *)verticesCenteredInRect:(CGRect)rect withNumberOfSides:(NSInteger)sides withInitialAngleInRadians:(CGFloat)initialAngle;

@end
