//
//  StatusShapeLayer.m
//  StatusThing
//
//  Created by Erik on 4/19/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "StatusShapeLayer.h"
@import AppKit;

@interface StatusShapeLayer()

@property (assign,nonatomic,readonly) CGPathRef circlePath;
@property (assign,nonatomic,readonly) CGPathRef trianglePath;
@property (assign,nonatomic,readonly) CGPathRef squarePath;
@property (assign,nonatomic,readonly) CGPathRef roundedSquarePath;
@property (assign,nonatomic,readonly) CGPathRef diamondPath;
@property (assign,nonatomic,readonly) CGPathRef pentagonPath;
@property (assign,nonatomic,readonly) CGPathRef hexagonPath;
@property (assign,nonatomic,readonly) CGPathRef octogonPath;

@end

@implementation StatusShapeLayer

@synthesize circlePath = _circlePath;
@synthesize trianglePath  = _trianglePath;
@synthesize squarePath = _squarePath;
@synthesize roundedSquarePath = _roundedSquarePath;
@synthesize diamondPath = _diamondPath;
@synthesize pentagonPath = _pentagonPath;
@synthesize hexagonPath = _hexagonPath;
@synthesize octogonPath = _octogonPath;

#pragma mark -
#pragma mark Initialization

@synthesize shape = _shape;

+ (instancetype)layer
{
    return [super layer];
}

- (instancetype)init
{
    self = [super init];
    if ( self) {
        self.fillColor = [[NSColor whiteColor] CGColor];
        self.name = StatusShapeLayerName;
    }
    return self;
}

#pragma mark -
#pragma mark Properties


- (NSString *)shape
{
    if ( _shape == nil ) {
        _shape = StatusShapeCircle;
    }
    return _shape;
}


- (void)setShape:(NSString *)shape
{
    _shape = shape;

    if ([_shape isEqualTo:StatusShapeCircle]) {
        self.path = self.circlePath;
    }
    
    if ([_shape isEqualTo:StatusShapeTriangle]) {
        self.path = self.trianglePath;
    }
    
    if ([_shape isEqualTo:StatusShapeSquare]) {
        self.path = self.squarePath;
    }
    
    if ([_shape isEqualTo:StatusShapeRoundedSquare]) {
        self.path = self.roundedSquarePath;
    }
    
    if ([_shape isEqualTo:StatusShapeDiamond]) {
        self.path = self.diamondPath;
    }
    
    if ([_shape isEqualTo:StatusShapePentagon]) {
        self.path = self.pentagonPath;
    }

    if ([_shape isEqualTo:StatusShapeHexagon]) {
        self.path = self.hexagonPath;
    }

    if ([_shape isEqualTo:StatusShapeOctogon]) {
        self.path = self.octogonPath;
    }

}



#pragma mark -
#pragma mark Path Properties

- (CGPathRef)circlePath
{
    if ( _circlePath == nil ) {
        CGMutablePathRef p = CGPathCreateMutable();
        NSRect rect = [self insetRect:self.bounds byPercentage:0.1];
        CGPathAddEllipseInRect(p, NULL, rect);
        _circlePath = CGPathRetain(p);
    }
    
    return _circlePath;
}

- (CGPathRef)trianglePath
{
    if ( _trianglePath == nil ) {
        CGRect rect = [self insetRect:self.bounds byPercentage:0.1];
        CGPoint v[3] =  { CGPointMake(CGRectGetMinX(rect),CGRectGetMinY(rect)),
            CGPointMake(CGRectGetMaxX(rect),CGRectGetMinY(rect)),
            CGPointMake(CGRectGetMidX(rect),CGRectGetMaxY(rect)) };
        _trianglePath = [self drawClosedPathWithTransform:nil havingCount:3 points:v];
    }
    
    return _trianglePath;
}

- (CGPathRef)squarePath
{
    if ( _squarePath == nil ) {
        CGMutablePathRef p = CGPathCreateMutable();
        CGRect rect = [self insetRect:self.bounds byPercentage:0.1];
        CGPathAddRect(p, nil, rect);
        _squarePath = CGPathRetain(p);
    }
    
    return _squarePath;
}

- (CGPathRef)roundedSquarePath
{
    if ( _roundedSquarePath == nil ) {
        CGMutablePathRef p = CGPathCreateMutable();
        CGRect rect = [self insetRect:self.bounds byPercentage:0.1];
        CGPathAddRoundedRect(p, nil, rect, 4, 4);
        //CGPathAddRect(p, nil, rect);
        _roundedSquarePath = CGPathRetain(p);
    }
    
    return _roundedSquarePath;
}

- (CGPathRef)diamondPath
{
    if ( _diamondPath == nil ) {
        CGRect rect = [self insetRect:self.bounds byPercentage:0.1];
        CGPoint v[4] = { CGPointMake(CGRectGetMidX(rect),CGRectGetMinY(rect)),
            CGPointMake(CGRectGetMaxX(rect),CGRectGetMidY(rect)),
            CGPointMake(CGRectGetMidX(rect),CGRectGetMaxY(rect)),
            CGPointMake(CGRectGetMinX(rect),CGRectGetMidY(rect)) };
        
        _diamondPath = [self drawClosedPathWithTransform:nil havingCount:4 points:v];
    }
    
    return _diamondPath;
}

- (CGPathRef)pentagonPath
{
    if ( _pentagonPath == nil ) {

        NSRect rect = [self insetRect:self.bounds byPercentage:0.1];
        CGFloat dx = rect.size.width / 4;
        CGPoint v[5] = { CGPointMake(CGRectGetMinX(rect) + dx,CGRectGetMinY(rect)),
            CGPointMake(CGRectGetMaxX(rect) - dx,CGRectGetMinY(rect)),
            CGPointMake(CGRectGetMaxX(rect),CGRectGetMidY(rect)),
            CGPointMake(CGRectGetMidX(rect),CGRectGetMaxY(rect)),
            CGPointMake(CGRectGetMinX(rect),CGRectGetMidY(rect)) };
        
        _pentagonPath = [self drawClosedPathWithTransform:nil havingCount:5 points:v];
    }
    
    return _pentagonPath;
}

- (CGPathRef)hexagonPath
{
    if ( _hexagonPath == nil ) {
        NSRect rect = [self insetRect:self.bounds byPercentage:0.1];
        CGFloat dx = rect.size.width / 4;
        CGPoint v[6] = {CGPointMake(CGRectGetMinX(rect) + dx,CGRectGetMinY(rect)),
            CGPointMake(CGRectGetMaxX(rect) - dx,CGRectGetMinY(rect)),
            CGPointMake(CGRectGetMaxX(rect),CGRectGetMidY(rect)),
            CGPointMake(CGRectGetMaxX(rect) - dx,CGRectGetMaxY(rect)),
            CGPointMake(CGRectGetMinX(rect) + dx,CGRectGetMaxY(rect)),
            CGPointMake(CGRectGetMinX(rect),CGRectGetMidY(rect)) };
        
        _hexagonPath = [self drawClosedPathWithTransform:nil havingCount:6 points:v];
    }
    
    return _hexagonPath;
}

- (CGPathRef)octogonPath
{
    if ( _octogonPath == nil ) {

        NSRect rect = [self insetRect:self.bounds byPercentage:0.1];
        CGFloat dx = rect.size.width / 3;
        CGFloat dy = rect.size.height / 3;
        CGPoint v[8] = { CGPointMake(CGRectGetMinX(rect) + dx,CGRectGetMinY(rect)),
            CGPointMake(CGRectGetMaxX(rect) - dx,CGRectGetMinY(rect)),
            CGPointMake(CGRectGetMaxY(rect),CGRectGetMinY(rect) + dy),
            CGPointMake(CGRectGetMaxX(rect),CGRectGetMaxY(rect) - dy),
            CGPointMake(CGRectGetMaxX(rect) - dx,CGRectGetMaxY(rect)),
            CGPointMake(CGRectGetMinX(rect) + dx,CGRectGetMaxY(rect)),
            CGPointMake(CGRectGetMinX(rect),CGRectGetMaxY(rect) - dy),
            CGPointMake(CGRectGetMinX(rect),CGRectGetMinY(rect) + dy) };
        _octogonPath = [self drawClosedPathWithTransform:nil havingCount:8 points:v];
    }
    
    return _octogonPath;
}


@end
