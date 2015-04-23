//
//  PolyShapeLayer.m
//  StatusThing
//
//  Created by Erik on 4/20/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "PolyShapeLayer.h"

@implementation PolyShapeLayer

@synthesize regularPolygon = _regularPolygon;
@synthesize circle =         _circle;
@synthesize roundedSquare =  _roundedSquare;
@synthesize star =           _star;



+ (instancetype)layer
{
    return [super layer];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSublayer:self.circle];
        [self addSublayer:self.regularPolygon];
        [self addSublayer:self.roundedSquare];
        [self addSublayer:self.star];
        
        self.strokeColor = CGColorCreateGenericRGB(0, 0, 0, 1);
        self.fillColor = CGColorCreateGenericRGB(1, 0, 0, 1);
        self.backgroundColor = nil;
    }
    return self;
}



#pragma mark -
#pragma mark Properties

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    [self.sublayers enumerateObjectsUsingBlock:^(CAShapeLayer *obj, NSUInteger idx, BOOL *stop) {
        obj.bounds = bounds;
    }];
}

- (void)setPosition:(CGPoint)position
{
    [super setPosition:position];
    [self.sublayers enumerateObjectsUsingBlock:^(CAShapeLayer *obj, NSUInteger idx, BOOL *stop) {
        obj.position = position;
    }];
}

- (void)setBackgroundColor:(CGColorRef)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    [self.sublayers enumerateObjectsUsingBlock:^(CAShapeLayer *obj, NSUInteger idx, BOOL *stop) {
        obj.backgroundColor = backgroundColor;
    }];
}

- (void)setFillColor:(CGColorRef)fillColor
{
    [super setFillColor:fillColor];
    [self.sublayers enumerateObjectsUsingBlock:^(CAShapeLayer *obj, NSUInteger idx, BOOL *stop) {
        obj.fillColor = fillColor;
    }];
}

- (void)setStrokeColor:(CGColorRef)strokeColor
{
    [super setStrokeColor:strokeColor];
    [self.sublayers enumerateObjectsUsingBlock:^(GeometricShapeLayer *obj, NSUInteger idx, BOOL *stop) {
        obj.strokeColor = strokeColor;
    }];
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    [super setLineWidth:lineWidth];
    [self.sublayers enumerateObjectsUsingBlock:^(CAShapeLayer *obj, NSUInteger idx, BOOL *stop) {
        obj.lineWidth = lineWidth;
    }];
}

#pragma mark -
#pragma mark SubLayer Properties


- (CircleShapeLayer *)circle {
    if (_circle == nil) {
        _circle = [CircleShapeLayer layer];
        _circle.hidden = YES;
    }
    return _circle;
}

- (RegularPolygonLayer *)regularPolygon
{
    if (_regularPolygon == nil) {
        _regularPolygon = [RegularPolygonLayer layer];
        _regularPolygon.hidden = YES;
        _regularPolygon.sides = 4;
    }
    return _regularPolygon;
}

- (RoundedSquareShapeLayer *)roundedSquare
{
    if (_roundedSquare == nil) {
        _roundedSquare =[RoundedSquareShapeLayer layer];
        _roundedSquare.hidden = YES;
    }
    return _roundedSquare;
}

- (StarShapeLayer *)star
{
    if (_star == nil) {
        _star = [StarShapeLayer layer];
        _star.hidden = YES;
    }
    return _star;
}




#pragma mark -
#pragma mark Methods



- (GeometricShapeLayer *)setVisibleLayer:(NSString *)layerName
{
    __block GeometricShapeLayer *found = nil;
    
    [self.sublayers enumerateObjectsUsingBlock:^(GeometricShapeLayer *obj, NSUInteger idx, BOOL *stop) {
        obj.hidden = ![obj.name isEqualToString:layerName];
        if ( obj.hidden == NO) {
            found = obj;
        }
    }];
    return found;
}

- (GeometricShapeLayer *)visibleLayer
{
    __block GeometricShapeLayer *found = nil;
    
    [self.sublayers enumerateObjectsUsingBlock:^(GeometricShapeLayer *obj, NSUInteger idx, BOOL *stop) {
        if (obj.hidden == NO) {
            found = obj;
            *stop = YES;
        }
    }];
    
    return found;
}

- (void)updateWithDictionary:(NSDictionary *)info
{
    
}

@end
