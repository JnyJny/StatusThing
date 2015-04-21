//
//  PolyShapeLayer.h
//  StatusThing
//
//  Created by Erik on 4/20/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "GeometricShapes.h"
#import "CALayer+LayoutUtilties.h"


@interface PolyShapeLayer : CAShapeLayer

@property (strong,nonatomic,readonly) CircleShapeLayer        *circle;
@property (strong,nonatomic,readonly) TriangleShapeLayer      *triangle;
@property (strong,nonatomic,readonly) SquareShapeLayer        *square;
@property (strong,nonatomic,readonly) RoundedSquareShapeLayer *roundedSquare;
@property (strong,nonatomic,readonly) DiamondShapeLayer       *diamond;
@property (strong,nonatomic,readonly) PentagonShapeLayer      *pentagon;
@property (strong,nonatomic,readonly) StarShapeLayer          *star;
@property (strong,nonatomic,readonly) HexagonShapeLayer       *hexagon;
@property (strong,nonatomic,readonly) OctogonShapeLayer       *octogon;
@property (strong,nonatomic,readonly) CrossShapeLayer         *cross;
@property (strong,nonatomic,readonly) StrikeShapeLayer        *strike;
@property (strong,nonatomic,readonly) BarredCircleShapeLayer  *barredCircle;



- (GeometricShapeLayer *)setVisibleShape:(NSString *)shapeName;

- (GeometricShapeLayer *)visibleShape;



@end
