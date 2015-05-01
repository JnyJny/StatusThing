//
//  ShapeFactory.h
//  StatusThing
//
//  Created by Erik on 4/30/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import <Foundation/Foundation.h>


#define ShapeNameNone          @"none"
#define ShapeNameCircle        @"circle"
#define ShapeNameLine          @"line"
#define ShapeNameTriangle      @"triangle"
#define ShapeNameSquare        @"square"
#define ShapeNameDiamond       @"diamond"
#define ShapeNameRoundedSquare @"roundedsquare"
#define ShapeNamePentagon      @"pentagon"
#define ShapeNameHexagon       @"hexagon"
#define ShapeNameSeptagon      @"septagon"
#define ShapeNameOctagon       @"octagon"
#define ShapeNameNonagon       @"nonagon"
#define ShapeNameDecagon       @"decagon"
#define ShapeNameEndecagon     @"endecagon"
#define ShapeNameTrigram       @"trigram"
#define ShapeNameQuadragram    @"quadragram"
#define ShapeNamePentagram     @"pentagram"
#define ShapeNameHexagram      @"hexagram"
#define ShapeNameSeptagram     @"septagram"
#define ShapeNameOctagram      @"octagram"
#define ShapeNameNonagram      @"nonagram"
#define ShapeNameDecagram      @"decagram"
#define ShapeNameEndecagram    @"endecagram"

@interface ShapeFactory : NSObject

@property (strong,nonatomic,readonly) NSDictionary *shapes;

- (NSArray *)pointsForShape:(NSString *)shape centeredInRect:(CGRect)rect rotatedBy:(CGFloat)degrees;

@end
