//
//  PolyShapeLayer.m
//  StatusThing
//
//  Created by Erik on 4/28/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "PolyShapeLayer.h"
#import "NSColor+NamedColorUtilities.h"

#define M_2PI     6.283185307179586
#define M_180_PI  57.29577951308232
#define M_PI_180  0.017453292519943295

// r = d * pi/180
// d = r * 180/pi

#define DegToRad(D)  ((D)*M_PI_180)
#define RadToDeg(R)  ((R)*M_180_PI)

#define PolyShapeKeyVertices       @"vertices"
#define PolyShapeKeyAngle          @"angle"
#define PolyShapeKeyConvex         @"convex"
#define PolyShapeKeyCornerRadius   @"cornerradius"


@interface PolyShapeLayer()

@property (strong,nonatomic,readonly) NSDictionary *shapes;
@property (assign,nonatomic,readonly) NSInteger vertices;
@property (assign,nonatomic,readonly) BOOL      convex;


@end

@implementation PolyShapeLayer

@synthesize shape  = _shape;
@synthesize shapes = _shapes;
@synthesize path   = _path;


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = PolyShapeLayerName;
    }
    return self;
}




- (NSDictionary *)shapes
{
    if (_shapes == nil) {
        _shapes = @{ PolyShapeNameNone:       @{PolyShapeKeyVertices:@0,  PolyShapeKeyConvex:@YES, PolyShapeKeyAngle:@0},
                     PolyShapeNameCircle:     @{PolyShapeKeyVertices:@1,  PolyShapeKeyConvex:@YES, PolyShapeKeyAngle:@0},
                     PolyShapeNameLine:       @{PolyShapeKeyVertices:@2,  PolyShapeKeyConvex:@YES, PolyShapeKeyAngle:@0},
                     PolyShapeNameTriangle:   @{PolyShapeKeyVertices:@3,  PolyShapeKeyConvex:@YES, PolyShapeKeyAngle:@0},
                     PolyShapeNameSquare:     @{PolyShapeKeyVertices:@4,  PolyShapeKeyConvex:@YES, PolyShapeKeyAngle:@45},
                     PolyShapeNameDiamond:    @{PolyShapeKeyVertices:@4,  PolyShapeKeyConvex:@YES, PolyShapeKeyAngle:@0},
                     PolyShapeNameRoundedSquare:   @{PolyShapeKeyVertices:@4, PolyShapeKeyConvex:@YES, PolyShapeKeyAngle:@0, PolyShapeKeyCornerRadius:@3},
                     PolyShapeNamePentagon:   @{PolyShapeKeyVertices:@5,  PolyShapeKeyConvex:@YES, PolyShapeKeyAngle:@0},
                     PolyShapeNameHexagon:    @{PolyShapeKeyVertices:@6,  PolyShapeKeyConvex:@YES, PolyShapeKeyAngle:@0},
                     PolyShapeNameSeptagon:   @{PolyShapeKeyVertices:@7,  PolyShapeKeyConvex:@YES, PolyShapeKeyAngle:@0},
                     PolyShapeNameOctagon:    @{PolyShapeKeyVertices:@8,  PolyShapeKeyConvex:@YES, PolyShapeKeyAngle:@0},
                     PolyShapeNameNonagon:    @{PolyShapeKeyVertices:@9,  PolyShapeKeyConvex:@YES, PolyShapeKeyAngle:@0},
                     PolyShapeNameDecagon:    @{PolyShapeKeyVertices:@10, PolyShapeKeyConvex:@YES, PolyShapeKeyAngle:@0},
                     PolyShapeNameEndecagon:  @{PolyShapeKeyVertices:@11, PolyShapeKeyConvex:@YES, PolyShapeKeyAngle:@0},
                     PolyShapeNameTrigram:    @{PolyShapeKeyVertices:@6,  PolyShapeKeyConvex:@NO,  PolyShapeKeyAngle:@0},
                     PolyShapeNameQuadragram: @{PolyShapeKeyVertices:@8,  PolyShapeKeyConvex:@NO,  PolyShapeKeyAngle:@0},
                     PolyShapeNamePentagram:  @{PolyShapeKeyVertices:@10, PolyShapeKeyConvex:@NO,  PolyShapeKeyAngle:@0},
                     PolyShapeNameHexagram:   @{PolyShapeKeyVertices:@12, PolyShapeKeyConvex:@NO,  PolyShapeKeyAngle:@0},
                     PolyShapeNameSeptagram:  @{PolyShapeKeyVertices:@14, PolyShapeKeyConvex:@NO,  PolyShapeKeyAngle:@0},
                     PolyShapeNameOctagram:   @{PolyShapeKeyVertices:@16, PolyShapeKeyConvex:@NO,  PolyShapeKeyAngle:@0},
                     PolyShapeNameNonagram:   @{PolyShapeKeyVertices:@18, PolyShapeKeyConvex:@NO,  PolyShapeKeyAngle:@0},
                     PolyShapeNameDecagram:   @{PolyShapeKeyVertices:@20, PolyShapeKeyConvex:@NO,  PolyShapeKeyAngle:@0},
                     PolyShapeNameEndecagram: @{PolyShapeKeyVertices:@22, PolyShapeKeyConvex:@NO,  PolyShapeKeyAngle:@0} };
    }
    return _shapes;
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    self.radius = MIN(CGRectGetWidth(bounds), CGRectGetHeight(bounds));
    [self setNeedsDisplay];
}

- (NSString *)shape
{
    if (_shape == nil) {
        _shape = PolyShapeNameNone;
    }
    return _shape;
}

- (void)setShape:(NSString *)shape
{
    shape = [shape lowercaseString];
    
    NSDictionary *info = [self.shapes objectForKey:shape];
    
    if (info == nil ) {
        NSLog(@"PolyShapeLayer setShape:%@ unrecognized shape",shape);
        return;
    }
    
    //NSLog(@"shape:%@  info: %@",shape,info);
    
    _convex = [[info valueForKey:PolyShapeKeyConvex] boolValue];
    _angle = [[info valueForKey:PolyShapeKeyAngle] floatValue];
    _vertices = [[info valueForKey:PolyShapeKeyVertices] integerValue];
    self.cornerRadius = [[info valueForKey:PolyShapeKeyCornerRadius] floatValue];
    _shape = shape;
    _path = nil;
    [self setNeedsDisplay];
}


- (CGPathRef)convexRegularPolygonWithNumberOfVertices:(NSInteger)vertices startingAtAngle:(CGFloat)degrees
{
    CGPoint   *points;
    
    CGRect rect = CGRectIntegral(CGRectInset(self.bounds, 0, 0));
    
    switch (vertices) {
        case 0:
            // None
            break;
        case 1:
            // Circle
            return CGPathCreateWithEllipseInRect(rect, nil);
            // NOTREACHED
        case 4:
            // Square
            if ( self.cornerRadius > 0) {
                return CGPathCreateWithRoundedRect(rect, self.cornerRadius, self.cornerRadius, nil);
                // NOTREACHED
            }
        case 2:
        case 3:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
        case 10:
        case 11:
            points = [self verticesCenteredInRect:rect
                                withNumberOfSides:vertices
                                        withAngle:DegToRad(degrees)];
            
            return [self createClosedPathWithTransform:nil
                                           havingCount:vertices
                                                points:points
                                         andFreePoints:YES];
            // NOTREACHED
        default:
            NSLog(@"convexRegularPolygonWithNumberOfVertices:%ld startingAtAngle:%f",vertices,degrees);
            break;
    }
    return nil;
}

- (CGPathRef)concaveRegularPolygramWithNumberOfVertices:(NSInteger)vertices startingAtAngle:(CGFloat)degrees
{
    CGRect rect;
    CGPoint *points;
    CGPoint *exterior;
    CGPoint *interior;
    NSInteger npoints = vertices / 2;
    CGFloat interiorThetaOffset = (M_2PI / npoints)/2.;
    
    // concave, ASSERT( (nverts % 2 == 0) && (nverts>2) &&(nverts<23))
    
    if ( vertices%2 || (vertices<3) || (vertices>22)) {
        NSLog(@"concaveRegularPlolygramWithNumberOfVertices:%ld startingAtAngle:%f",vertices,degrees);
        return nil;
    }

    rect = CGRectInset(self.bounds, self.radius/4, self.radius/4);
    
    interior = [self verticesCenteredInRect:rect
                          withNumberOfSides:npoints
                                  withAngle:DegToRad(degrees) + interiorThetaOffset];
    
    exterior = [self verticesCenteredInRect:self.bounds
                          withNumberOfSides:npoints
                                  withAngle:DegToRad(degrees)];
    
    points = calloc(vertices, sizeof(CGPoint));
    
    for (int i=0; i<npoints; i++) {
        points[i*2]     = exterior[i];
        points[(i*2)+1] = interior[i];
    }
    
    free(interior);
    free(exterior);

    return [self createClosedPathWithTransform:nil
                                   havingCount:vertices
                                        points:points
                                 andFreePoints:YES];
}

- (CGPathRef)path
{
    if (_path == nil) {
        if ( self.convex) {
            _path = [self convexRegularPolygonWithNumberOfVertices:self.vertices
                                                   startingAtAngle:self.angle];
        }
        else {
            _path = [self concaveRegularPolygramWithNumberOfVertices:self.vertices
                                                     startingAtAngle:self.angle];
        }
    }
    return _path;
}

#pragma mark -
#pragma mark Path Creation Methods

- (CGPathRef)createClosedPathWithTransform:(CGAffineTransform *)transform havingCount:(size_t)count points:(CGPoint *)points andFreePoints:(BOOL)freePoints
{
    CGMutablePathRef newPath = CGPathCreateMutable();
    
    CGPathMoveToPoint(newPath, nil, points[0].x, points[0].y);
    CGPathAddLines(newPath, transform, points, count);
    CGPathCloseSubpath(newPath);
    
    if (freePoints)
        free(points);
    
    return CGPathRetain(newPath);
}

#pragma mark -
#pragma mark Vertices Generation for regular polygons

- (CGPoint *)verticesCenteredAt:(CGPoint)origin withNumberOfSides:(NSInteger)sides andRadius:(CGFloat)radius withAngle:(CGFloat)radians
{
    CGPoint *v = calloc(sides,sizeof(CGPoint));
    CGFloat theta;

    for(int i=0;i<sides;i++) {
        theta = M_2PI * ((float)i / sides) + radians;
        v[i] = CGPointMake(origin.x + radius * cosf(theta),
                           origin.y + radius * sinf(theta));
        //NSLog(@"%@ %d = %f,%f",self.shape,i,v[i].x,v[i].y);
    }
    return v;
}

- (CGPoint *)verticesCenteredInRect:(CGRect)rect withNumberOfSides:(NSInteger)sides withAngle:(CGFloat)radians
{
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGFloat radius = MIN(CGRectGetWidth(rect)/2.,CGRectGetHeight(rect)/2.);
    
    return [self verticesCenteredAt:center
                  withNumberOfSides:sides
                          andRadius:radius
                          withAngle:radians];
    
}

#pragma mark -
#pragma mark Configuration Method

- (void)updateWithDictionary:(NSDictionary *)info
{
    [info enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        BOOL handled = NO;
        
        if (!handled && [key isEqualToString:@"hidden"]) {
            self.hidden = [obj boolValue];
            handled = YES;
        }
        
        if (!handled && [key isEqualToString:@"fill"]) {
            self.fillColor = [[NSColor colorForObject:obj] CGColor];
            handled = YES;
        }
        
        if (!handled && [key isEqualToString:@"stroke"]) {
            self.strokeColor = [[NSColor colorForObject:obj] CGColor];
            handled = YES;
        }

        if (!handled && [key isEqualToString:@"lineWidth"]) {
            self.lineWidth = [obj floatValue];
            handled = YES;
        }

        if (!handled && [key isEqualToString:@"background"]) {
            self.backgroundColor = [[NSColor colorForObject:obj] CGColor];
            handled = YES;
        }

    }];
    
}


@end
