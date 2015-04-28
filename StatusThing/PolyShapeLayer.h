//
//  PolyShapeLayer.h
//  StatusThing
//
//  Created by Erik on 4/28/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#define PolyShapeLayerName         @"PolyShapeLayer"

#define PolyShapeNameNone          @"none"
#define PolyShapeNameCircle        @"circle"
#define PolyShapeNameLine          @"line"
#define PolyShapeNameTriangle      @"triangle"
#define PolyShapeNameSquare        @"square"
#define PolyShapeNameDiamond       @"diamond"
#define PolyShapeNameRoundedSquare @"roundedsquare"
#define PolyShapeNamePentagon      @"pentagon"
#define PolyShapeNameHexagon       @"hexagon"
#define PolyShapeNameSeptagon      @"septagon"
#define PolyShapeNameOctagon       @"octagon"
#define PolyShapeNameNonagon       @"nonagon"
#define PolyShapeNameDecagon       @"decagon"
#define PolyShapeNameEndecagon     @"endecagon"
#define PolyShapeNameTrigram       @"trigram"
#define PolyShapeNameQuadragram    @"quadragram"
#define PolyShapeNamePentagram     @"pentagram"
#define PolyShapeNameHexagram      @"hexagram"
#define PolyShapeNameSeptagram     @"septagram"
#define PolyShapeNameOctagram      @"octagram"
#define PolyShapeNameNonagram      @"nonagram"
#define PolyShapeNameDecagram      @"decagram"
#define PolyShapeNameEndecagram    @"endecagram"

@interface PolyShapeLayer : CAShapeLayer

@property (strong,nonatomic) NSString *shape;
@property (assign,nonatomic) CGFloat   radius;
@property (assign,nonatomic) CGFloat   angle;

- (void)updateWithDictionary:(NSDictionary *)info;

@end
