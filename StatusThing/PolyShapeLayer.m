//
//  PolyShapeLayer.m
//  StatusThing
//
//  Created by Erik on 4/20/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "PolyShapeLayer.h"

@implementation PolyShapeLayer

@synthesize circle = _circle;
@synthesize triangle = _triangle;
@synthesize square = _square;
@synthesize roundedSquare = _roundedSquare;
@synthesize diamond = _diamond;
@synthesize pentagon = _pentagon;
@synthesize star = _star;
@synthesize hexagon = _hexagon;
@synthesize octogon = _octogon;
@synthesize cross = _cross;
@synthesize strike = _strike;
@synthesize barredCircle = _barredCircle;

+ (instancetype)layer
{
    return [super layer];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSublayer:self.circle];
        [self addSublayer:self.triangle];
        [self addSublayer:self.square];
        [self addSublayer:self.roundedSquare];
        [self addSublayer:self.diamond];
        [self addSublayer:self.pentagon];
        [self addSublayer:self.star];
        [self addSublayer:self.hexagon];
        [self addSublayer:self.octogon];
        [self addSublayer:self.cross];
        [self addSublayer:self.strike];
        [self addSublayer:self.barredCircle];
        
        self.strokeColor = CGColorCreateGenericRGB(0, 0, 0, 1);
        self.fillColor = CGColorCreateGenericRGB(1, 0, 0, 1);
        self.backgroundColor = nil;
    }
    return self;
}

- (void)drawInContext:(CGContextRef)ctx
{
    [super drawInContext:ctx];
    
    NSLog(@"draw in context");
}


#pragma mark -
#pragma mark Properties

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    [self.sublayers enumerateObjectsUsingBlock:^(GeometricShapeLayer *obj, NSUInteger idx, BOOL *stop) {
        obj.bounds = bounds;
    }];
}

- (void)setPosition:(CGPoint)position
{
    [super setPosition:position];
    [self.sublayers enumerateObjectsUsingBlock:^(GeometricShapeLayer *obj, NSUInteger idx, BOOL *stop) {
        obj.position = position;
    }];
}

- (void)setBackgroundColor:(CGColorRef)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    [self.sublayers enumerateObjectsUsingBlock:^(GeometricShapeLayer *obj, NSUInteger idx, BOOL *stop) {
        obj.backgroundColor = backgroundColor;
    }];
}

- (void)setFillColor:(CGColorRef)fillColor
{
    [super setFillColor:fillColor];
    [self.sublayers enumerateObjectsUsingBlock:^(GeometricShapeLayer *obj, NSUInteger idx, BOOL *stop) {
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
    [self.sublayers enumerateObjectsUsingBlock:^(GeometricShapeLayer *obj, NSUInteger idx, BOOL *stop) {
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

- (TriangleShapeLayer *)triangle
{
    if (_triangle == nil) {
        _triangle = [TriangleShapeLayer layer];
        _triangle.hidden = YES;
    }
    return _triangle;
}

- (SquareShapeLayer *)square
{
    if (_square == nil) {
        _square =[SquareShapeLayer layer];
        _square.hidden = YES;
    }
    return _square;
}

- (RoundedSquareShapeLayer *)roundedSquare
{
    if (_roundedSquare == nil) {
        _roundedSquare =[RoundedSquareShapeLayer layer];
        _roundedSquare.hidden = YES;
    }
    return _roundedSquare;
}

- (DiamondShapeLayer *)diamond
{
    if (_diamond == nil) {
        _diamond = [DiamondShapeLayer layer];
        _diamond.hidden = YES;
    }
    return _diamond;
}

- (PentagonShapeLayer *)pentagon
{
    if (_pentagon == nil) {
        _pentagon = [PentagonShapeLayer layer];
        _pentagon.hidden = YES;
    }
    return _pentagon;
}

- (StarShapeLayer *)star
{
    if (_star == nil) {
        _star = [StarShapeLayer layer];
        _star.hidden = YES;
    }
    return _star;
}

- (HexagonShapeLayer *)hexagon
{
    if (_hexagon == nil) {
        _hexagon = [HexagonShapeLayer layer];
        _hexagon.hidden = YES;
    }
    return _hexagon;
}

- (OctogonShapeLayer *)octogon
{
    if (_octogon == nil) {
        _octogon = [OctogonShapeLayer layer];
        _octogon.hidden = YES;
    }
    return _octogon;
}

- (CrossShapeLayer *)cross
{
    if (_cross == nil) {
        _cross = [CrossShapeLayer layer];
        _cross.hidden = YES;
    }
    return _cross;
}

- (StrikeShapeLayer *)strike
{
    if (_strike == nil) {
        _strike = [StrikeShapeLayer layer];
        _strike.hidden = YES;
    }
    return _strike;
}

- (BarredCircleShapeLayer *)barredCircle
{
    if (_barredCircle == nil) {
        _barredCircle = [BarredCircleShapeLayer layer];
        _barredCircle.hidden = YES;
    }
    return _barredCircle;
}


#pragma mark -
#pragma mark Methods



- (GeometricShapeLayer *)setVisibleShape:(NSString *)shapeName
{
    __block GeometricShapeLayer *found = nil;
    
    [self.sublayers enumerateObjectsUsingBlock:^(GeometricShapeLayer *obj, NSUInteger idx, BOOL *stop) {
        obj.hidden = ![obj.name isEqualToString:shapeName];
        if ( obj.hidden == NO) {
            found = obj;
        }
    }];
    return found;
}

- (GeometricShapeLayer *)visibleShape
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

@end
