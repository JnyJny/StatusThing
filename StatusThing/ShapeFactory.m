//
//  ShapeFactory.m
//  StatusThing
//
//  Created by Erik on 4/30/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "ShapeFactory.h"


#define M_2PI       6.283185307179586
#define M_180_PI    57.29577951308232
#define M_PI_180    0.017453292519943295
#define DegToRad(D) ((D)*M_PI_180)
#define RadToDeg(R) ((R)*M_180_PI)

NSString *const ShapeNameNone           = @"none";
NSString *const ShapeNameCircle         = @"circle";
NSString *const ShapeNameLine           = @"line";
NSString *const ShapeNameTriangle       = @"triangle";
NSString *const ShapeNameSquare         = @"square";
NSString *const ShapeNameDiamond        = @"diamond";
NSString *const ShapeNameRoundedSquare  = @"roundedsquare";
NSString *const ShapeNamePentagon       = @"pentagon";
NSString *const ShapeNameHexagon        = @"hexagon";
NSString *const ShapeNameSeptagon       = @"septagon";
NSString *const ShapeNameOctagon        = @"octagon";
NSString *const ShapeNameNonagon        = @"nonagon";
NSString *const ShapeNameDecagon        = @"decagon";
NSString *const ShapeNameEndecagon      = @"endecagon";
NSString *const ShapeNameTrigram        = @"trigram";
NSString *const ShapeNameQuadragram     = @"quadragram";
NSString *const ShapeNamePentagram      = @"pentagram";
NSString *const ShapeNameHexagram       = @"hexagram";
NSString *const ShapeNameSeptagram      = @"septagram";
NSString *const ShapeNameOctagram       = @"octagram";
NSString *const ShapeNameNonagram       = @"nonagram";
NSString *const ShapeNameDecagram       = @"decagram";
NSString *const ShapeNameEndecagram     = @"endecagram";

static NSString *const ShapeKeySides  = @"sides";
static NSString *const ShapeKeyConvex = @"convex";
static NSString *const ShapeKeyAngle  = @"angle";

@implementation ShapeFactory

@synthesize shapes = _shapes;

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

// These shapes are easier to generate using Core Graphics functions
//ShapeNameCircle:       @{ ShapeKeySides:@1,  ShapeKeyConvex:@YES, ShapeKeyAngle:@0 },
//ShapeNameRoundedSquare:@{ ShapeKeySides:@4,  ShapeKeyConvex:@YES, ShapeKeyAngle:@0 },

- (NSDictionary *)shapes
{
    
    if (_shapes ==nil) {
        _shapes = @{ShapeNameNone:         @{ ShapeKeySides:@0,  ShapeKeyConvex:@NO,  ShapeKeyAngle:@0 },
                    ShapeNameLine:         @{ ShapeKeySides:@2,  ShapeKeyConvex:@YES, ShapeKeyAngle:@0 },
                    ShapeNameTriangle:     @{ ShapeKeySides:@3,  ShapeKeyConvex:@YES, ShapeKeyAngle:@90 },
                    ShapeNameSquare:       @{ ShapeKeySides:@4,  ShapeKeyConvex:@YES, ShapeKeyAngle:@0 },
                    ShapeNameDiamond:      @{ ShapeKeySides:@4,  ShapeKeyConvex:@YES, ShapeKeyAngle:@0 },
                    ShapeNamePentagon:     @{ ShapeKeySides:@5,  ShapeKeyConvex:@YES, ShapeKeyAngle:@0 },
                    ShapeNameHexagon:      @{ ShapeKeySides:@6,  ShapeKeyConvex:@YES, ShapeKeyAngle:@0 },
                    ShapeNameSeptagon:     @{ ShapeKeySides:@7,  ShapeKeyConvex:@YES, ShapeKeyAngle:@0 },
                    ShapeNameOctagon:      @{ ShapeKeySides:@8,  ShapeKeyConvex:@YES, ShapeKeyAngle:@0 },
                    ShapeNameNonagon:      @{ ShapeKeySides:@9,  ShapeKeyConvex:@YES, ShapeKeyAngle:@0 },
                    ShapeNameDecagon:      @{ ShapeKeySides:@10, ShapeKeyConvex:@YES, ShapeKeyAngle:@0 },
                    ShapeNameEndecagon:    @{ ShapeKeySides:@11, ShapeKeyConvex:@YES, ShapeKeyAngle:@0 },
                    ShapeNameTrigram:      @{ ShapeKeySides:@3,  ShapeKeyConvex:@NO,  ShapeKeyAngle:@0 },
                    ShapeNameQuadragram:   @{ ShapeKeySides:@4,  ShapeKeyConvex:@NO,  ShapeKeyAngle:@0 },
                    ShapeNamePentagram:    @{ ShapeKeySides:@5,  ShapeKeyConvex:@NO,  ShapeKeyAngle:@0 },
                    ShapeNameHexagram:     @{ ShapeKeySides:@6,  ShapeKeyConvex:@NO,  ShapeKeyAngle:@0 },
                    ShapeNameSeptagram:    @{ ShapeKeySides:@7,  ShapeKeyConvex:@NO,  ShapeKeyAngle:@0 },
                    ShapeNameOctagram:     @{ ShapeKeySides:@8,  ShapeKeyConvex:@NO,  ShapeKeyAngle:@0 },
                    ShapeNameNonagram:     @{ ShapeKeySides:@9,  ShapeKeyConvex:@NO,  ShapeKeyAngle:@0 },
                    ShapeNameDecagram:     @{ ShapeKeySides:@10, ShapeKeyConvex:@NO,  ShapeKeyAngle:@0 },
                    ShapeNameEndecagram:   @{ ShapeKeySides:@11, ShapeKeyConvex:@NO,  ShapeKeyAngle:@0 } };
    }
    return _shapes;
}

- (NSArray *)pointsForConvex:(BOOL)convex shapeWithSides:(NSInteger)sides centeredInRect:(CGRect)rect rotatedBy:(CGFloat)degrees
{
    NSMutableArray *points = [[NSMutableArray alloc] init];
    CGFloat theta;
    CGFloat deltaTheta;
    CGFloat radius;
    CGPoint origin;
    CGPoint p;
    
    origin = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    radius = MIN(CGRectGetWidth(rect), CGRectGetHeight(rect)) / 2.;
    deltaTheta = (M_2PI / sides) / 2.;
    
    for (int i=0; i<sides; i++) {
        theta = M_2PI * ( i / (float)sides) + DegToRad(degrees);
        p.x = origin.x + radius * cosf(theta);
        p.y = origin.y + radius * sinf(theta);
        [points addObject:[NSValue valueWithPoint:p]];
        
        if (convex == NO) {
            // drawing inside vertices of a star thing
            p.x = origin.x + (radius/2.) * cosf(theta + deltaTheta);
            p.y = origin.y + (radius/2.) * sinf(theta + deltaTheta);
            [points addObject:[NSValue valueWithPoint:p]];
        }
    }
    
    return (NSArray *)points;
}


- (NSArray *)pointsForShape:(NSString *)shape centeredInRect:(CGRect)rect rotatedBy:(CGFloat)degrees
{
    
    NSDictionary *info = [self.shapes valueForKey:shape];
    
    if ( info == nil) {
        NSLog(@"pointsForShape:%@ not defined",shape);
        return nil;
    }
    
    return [self pointsForConvex:[[info valueForKey:ShapeKeyConvex] boolValue]
                  shapeWithSides:[[info valueForKey:ShapeKeySides] integerValue]
                  centeredInRect:rect
                       rotatedBy:[[info valueForKey:ShapeKeyAngle] floatValue] + degrees];
}



@end
