//
//  RegularPolygonLayer.m
//  StatusThing
//
//  Created by Erik on 4/22/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "RegularPolygonLayer.h"



@implementation RegularPolygonLayer

@synthesize path = _path;
@synthesize sides = _sides;
@synthesize names = _names;

#pragma mark -
#pragma mark Class Convenience Methods

+ (instancetype)layer
{
    return [super layer];
}

#define INITIAL_ANGLE(SIDES) (M_2PI/(SIDES))

+ (instancetype)Triangle
{
    RegularPolygonLayer *p = [super layer];
    p.sides = 3;
    p.initialAngle = INITIAL_ANGLE(p.sides);
    return p;
}

+ (instancetype)Square
{
    RegularPolygonLayer *p = [super layer];
    p.sides = 4;
    p.initialAngle = INITIAL_ANGLE(p.sides);
    return p;
}

+ (instancetype)Pentagon
{
    RegularPolygonLayer *p = [super layer];
    p.sides = 5;
    p.initialAngle = INITIAL_ANGLE(p.sides);
    
    return p;
}

+ (instancetype)Hexagon
{
    RegularPolygonLayer *p = [super layer];
    p.sides = 6;
    p.initialAngle = INITIAL_ANGLE(p.sides);
    return p;
}


+ (instancetype)Septagon
{
    RegularPolygonLayer *p = [super layer];
    p.sides = 7;
    return p;
}

#pragma mark -
#pragma mark Instance Methods - Init

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sides = 3;
        self.initialAngle = M_PI_2;
    }
    return self;
}

- (NSArray *)names
{
    if (_names == nil) {
        _names = [[NSArray alloc] initWithObjects:
                  GeometricShapeTriangle,
                  GeometricShapeSquare,
                  GeometricShapePentagon,
                  GeometricShapeHexagon,
                  GeometricShapeSeptagon,
                  GeometricShapeOctogon,
                  GeometricShapeNonagon,
                  GeometricShapeDecagon,
                  GeometricShapeEndecagon,nil];
    }
    return _names;
}



- (void)setSides:(NSInteger)sides
{
    _sides = sides;
    self.path = nil;
    self.name = [self.names objectAtIndex:_sides-3];

    [self setNeedsDisplay];
}

- (void)setInitialAngle:(CGFloat)angle
{
    _initialAngle = angle;
    self.path = nil;
    [self setNeedsDisplay];
}

- (CGPathRef)path
{
    if (_path == nil) {
        CGPoint *points = [self verticesCenteredInRect:self.bounds
                                     withNumberOfSides:self.sides
                             withInitialAngleInRadians:self.initialAngle];
        
        _path = [self drawClosedPathWithTransform:nil
                                      havingCount:self.sides
                                           points:points];
        free(points);
    }
    return _path;
}

- (CGPoint *)verticesCenteredAt:(CGPoint)origin withNumberOfSides:(NSInteger)sides andRadius:(CGFloat)radius andInitialAngleInRadians:(CGFloat)initialAngle
{
    NSInteger i;
    CGPoint *v = calloc(sides,sizeof(CGPoint));
    CGFloat theta;

    for(i=0;i<sides;i++) {
        theta = M_2PI * ((float)i / sides) + initialAngle ;
        v[i] = CGPointMake(origin.x + radius * cosf(theta),origin.y + radius * sinf(theta));
#if 0
        NSLog(@"v[%ld] = %7.2f %7.2f",i,v[i].x,v[i].y);
#endif
    }
    
    return v;
}

- (CGPoint *)verticesCenteredInRect:(CGRect)rect withNumberOfSides:(NSInteger)sides withInitialAngleInRadians:(CGFloat)initialAngle
{
    
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGFloat radius = MIN(CGRectGetWidth(rect)/2., CGRectGetHeight(rect)/2.);
    
    return [self verticesCenteredAt:center
                  withNumberOfSides:sides
                          andRadius:radius
           andInitialAngleInRadians:initialAngle];
}

- (CGFloat)circumradiusForRect:(CGRect)rect
{
    return 0;
}

- (CGFloat)apothamForRect:(CGRect)rect
{
    return 0;
}

- (void)updateWithDictionary:(NSDictionary *)info
{
    
}
@end
