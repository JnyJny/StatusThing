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
@property (strong,nonatomic,readonly) RegularPolygonLayer     *regularPolygon;
@property (strong,nonatomic,readonly) RoundedSquareShapeLayer *roundedSquare;
@property (strong,nonatomic,readonly) StarShapeLayer          *star;




- (GeometricShapeLayer *)setVisibleLayer:(NSString *)layerName;

- (GeometricShapeLayer *)visibleLayer;



@end
