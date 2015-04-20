//
//  StatusView.m
//  StatusThing
//
//  Created by Erik on 4/18/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//


#import "StatusView.h"
#import <QuartzCore/QuartzCore.h>
#import "NSColor+NamedColorUtilities.h"
#import "Konstants.h"

#define StringIsTrue(S) [[S lowercaseString] isEqualToString:@"yes"] || [[(S) lowercaseString] isEqualToString:@"true"]

@interface StatusView()

@property (strong,nonatomic) StatusShapeLayer *shapeLayer;
@property (strong,nonatomic) OutlineShapeLayer *outlineLayer;
@property (strong,nonatomic) SymbolShapeLayer *symbolLayer;

@end

@implementation StatusView

@synthesize shape = _shape;

#pragma mark -
#pragma mark Initialization Methods

- (instancetype)initWithFrame:(NSRect )rect
{
    self = [super initWithFrame:rect];
    if ( self ) {
        self.wantsLayer = YES;
        [self.layer addSublayer:self.shapeLayer];
        [self.layer addSublayer:self.outlineLayer];
        [self.layer addSublayer:self.symbolLayer];
        self.outlineWidth = 0.8;
        self.fontSize = CGRectGetHeight(self.bounds) - 8;
        
        self.hideShape = NO;
        self.hideOutline = NO;
        self.hideSymbol = NO;
    }
    return self;
}

- (instancetype)init
{
    CGFloat w = [[NSStatusBar systemStatusBar] thickness];
    
    return [self initWithFrame:NSMakeRect(0, 0, w, w)];
}

// missing: - (instancetype)initWithCoder:(NSCoder *)coder

#pragma mark -
#pragma mark Layer Drawing Methods

- (BOOL)wantsUpdateLayer { return YES; }

- (void)updateLayer
{
    self.shapeLayer.shape = self.shape;
    self.outlineLayer.shape = self.shape;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    NSPoint center = NSMakePoint(CGRectGetMidX(layer.bounds), CGRectGetMidY(layer.bounds));
    
    self.shapeLayer.bounds = layer.bounds;
    self.shapeLayer.position = center;
    
    self.outlineLayer.bounds = layer.bounds;
    self.outlineLayer.position = center;
    
    self.symbolLayer.bounds = layer.bounds;
    self.symbolLayer.position = center;
}



#pragma mark -
#pragma mark Properties

- (NSArray *)properties
{
    if (_properties == nil) {
        _properties = @[ StatusViewShapeProperty,
                         StatusViewHideShapeProperty,
                         StatusViewColorProperty,
                         StatusViewHideOutlineProperty,
                         StatusViewOutlineWidthProperty,
                         StatusViewSymbolProperty,
                         StatusViewSymbolColorProperty,
                         StatusViewHideSymbolProperty,
                         StatusViewFontProperty,
                         StatusViewFontSizeProperty,
                         ];
    }
    return _properties;
}


- (NSString *)shape
{
    if (_shape == nil ) {
        _shape = self.shapeLayer.shape;
    }
    return _shape;
}

- (void)setShape:(NSString *)shape
{
    _shape = shape;
    [self setNeedsDisplay:YES];
}

- (void)setShapeForObject:(id)object
{
    [self setShape:object];
}

- (NSColor *)color
{
    return [NSColor colorWithCGColor:self.shapeLayer.fillColor];
}

- (void)setColor:(NSColor *)color
{
    self.shapeLayer.fillColor = [color CGColor];
    [self setNeedsDisplay:YES];
}

- (void)setColorForObject:(id)object
{
    [self setColor:[NSColor colorForObject:object]];
}

- (CGFloat)outlineWidth
{
    return self.outlineLayer.lineWidth;
}

- (void)setOutlineWidth:(CGFloat)outlineWidth
{
    self.outlineLayer.lineWidth = outlineWidth;
    [self setNeedsDisplay:YES];
}

- (void)setOutlineWidthForObject:(id)object
{
    [self setOutlineWidth:[object floatValue]];
}

- (NSString *)symbol
{
    return self.symbolLayer.string;
}

- (void)setSymbol:(NSString *)symbol
{
    // do some range checking here, look for \u and pass the string on unmolested
    // otherwise trim it down to one character
    
    self.symbolLayer.string = symbol;
    [self setNeedsDisplay:YES];
}

- (void)setSymbolForObject:(id)object
{
    [self setSymbol:object];
}

- (NSColor *)symbolColor
{
    return [NSColor colorWithCGColor:self.symbolLayer.foregroundColor];
}

- (void)setSymbolColor:(NSColor *)symbolColor
{
    self.symbolLayer.foregroundColor = [symbolColor CGColor];
    [self setNeedsDisplay:YES];
}

- (void)setSymbolColorForObject:(id)object
{
    [self setSymbolColor:[NSColor colorForObject:object]];
}

- (NSFont *)font
{
    return self.symbolLayer.font;
}

- (void)setFont:(NSFont *)font
{
    self.symbolLayer.font = CFBridgingRetain(font);
    [self setNeedsDisplay:YES];
}

- (void)setFontForObject:(id)object
{
    self.symbolLayer.font = (CTFontRef)CFBridgingRetain(object);
}

- (CGFloat)fontSize
{
    return self.symbolLayer.fontSize;
}

- (void)setFontSize:(CGFloat)fontSize
{
    self.symbolLayer.fontSize = fontSize;
    [self setNeedsDisplay:YES];
}

- (void)setFontSizeForObject:(id)object
{
    [self setFontSize:[object floatValue]];
}

- (BOOL)shapeIsHidden
{
    return self.shapeLayer.hidden;
}

- (void)setHideShape:(BOOL)shapeHidden
{
    self.shapeLayer.hidden = shapeHidden;
    [self setNeedsDisplay:YES];
}

- (void)setShapeHiddenForObject:(id)object
{
    [self setShapeHidden: [object boolValue]];
}

- (BOOL)outlineIsHidden
{
    return self.outlineLayer.hidden;
}

- (void)setHideOutline:(BOOL)outlineHidden
{
    self.outlineLayer.hidden = outlineHidden;
    [self setNeedsDisplay:YES];
}

- (void)setOutlineHiddenForObject:(id)object
{
    [self setOutlineHidden:[object boolValue]];
}

- (BOOL)symbolIsHidden
{
    return self.symbolLayer.hidden;
}

- (void)setHideSymbol:(BOOL)symbolHidden
{
    self.symbolLayer.hidden = symbolHidden;
    [self setNeedsDisplay:YES];
}

- (void)setSymbolHiddenForObject:(id)object
{
    [self setSymbolHidden:[object boolValue]];
}



#pragma mark -
#pragma mark Layer Properties

- (StatusShapeLayer *)shapeLayer
{
    if ( _shapeLayer == nil ) {
        _shapeLayer = [StatusShapeLayer layer];
     }
    return _shapeLayer;
}

- (OutlineShapeLayer *)outlineLayer
{
    if ( _outlineLayer == nil ) {
        _outlineLayer = [OutlineShapeLayer layer];
    }
    return _outlineLayer;
}

- (SymbolShapeLayer *)symbolLayer
{
    if ( _symbolLayer == nil ) {
        _symbolLayer = [SymbolShapeLayer layer];
        _symbolLayer.fontSize = CGRectGetHeight(self.bounds) - 4;
    }
    return _symbolLayer;
}


#pragma mark -
#pragma mark Private Methods


#pragma mark -
#pragma mark Methods

- (void)updateWithDictionary:(NSDictionary *)info
{
    
    [info enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {

        @try {
            [self setValue:obj forKey:[key stringByAppendingString:@"ForObject"] ];
        }
        @catch (NSException *exception) {
            NSLog(@"updateWithDictionary: %@",exception);
        }
    }];
}

#pragma mark -
#pragma mark Path Reference Properties
- (CGPathRef)symbolPathRef
{
    if ( _symbolPathRef == nil) {
        _symbolPathRef = [self.symbolPath quartzPath];
    }
    return _symbolPathRef;
}

- (CGPathRef)circlePathRef
{
    if (_circlePathRef == nil ) {
        _circlePathRef = [self.circlePath quartzPath];
    }
    return _circlePathRef;
}

- (CGPathRef)trianglePathRef
{
    if (_trianglePathRef == nil ) {
        _trianglePathRef = [self.trianglePath quartzPath];
    }
    return _trianglePathRef;
}

- (CGPathRef)squarePathRef
{
    if (_squarePathRef == nil) {
        _squarePathRef = [self.squarePath quartzPath];
    }
    return _squarePathRef;
}

- (CGPathRef)roundedSquarePathRef
{
    if (_roundedSquarePathRef == nil) {
        _roundedSquarePathRef = [self.roundedSquarePath quartzPath];
    }
    return _roundedSquarePathRef;
}

- (CGPathRef)diamondPathRef
{
    if (_diamondPathRef == nil) {
        _diamondPathRef = [self.diamondPath quartzPath];
    }
    return _diamondPathRef;
}

- (CGPathRef)pentagonPathRef
{
    if (_pentagonPathRef == nil) {
        _pentagonPathRef = [self.pentagonPath quartzPath];
    }
    return _pentagonPathRef;
}

- (CGPathRef)hexagonPathRef
{
    if (_hexagonPathRef == nil) {
        _hexagonPathRef = [self.hexagonPath quartzPath];
    }
    return _hexagonPathRef;
}

- (CGPathRef)octogonPathRef
{
    if (_octogonPathRef == nil) {
        _octogonPathRef = [self.octogonPath quartzPath];
    }
    return _octogonPathRef;
}

@end
