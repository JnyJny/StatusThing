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



@implementation StatusView

@synthesize background = _background;
@synthesize foreground = _foreground;
@synthesize symbol =     _symbol;

#pragma mark -
#pragma mark Initialization Methods

- (instancetype)initWithFrame:(NSRect )rect
{
    self = [super initWithFrame:rect];
    if ( self ) {
        self.wantsLayer = YES;
        [self.layer addSublayer:self.background];
        [self.layer addSublayer:self.foreground];
        [self.layer addSublayer:self.symbol];

        [self.background setVisibleLayer:GeometricShapeStar];
        self.background.strokeColor = nil;
        self.background.fillColor = CGColorCreateGenericRGB(1, 0, 0, 1);
        
        [self.foreground setVisibleLayer:GeometricShapeStar];
        self.foreground.fillColor = nil;
        self.foreground.lineWidth = 2.;
        
        [self setNeedsDisplay:YES];
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

- (BOOL)opaque
{
    return NO;
}

- (BOOL)wantsUpdateLayer { return YES; }


- (void)layoutSublayersOfLayer:(CALayer *)layer
{
#define kInset(X) CGPointMake((X),(X))
    [self.background centerInRect:layer.bounds andInset:kInset(3)];
    [self.foreground centerInRect:layer.bounds andInset:kInset(3)];
    [self.symbol centerInRect:layer.bounds andInset:kInset(3)];
}



#pragma mark -
#pragma mark Properties

- (PolyShapeLayer *)background
{
    if (_background == nil) {
        _background = [PolyShapeLayer layer];
     }
    return _background;
}

- (PolyShapeLayer *)foreground
{
    if (_foreground == nil) {
        _foreground = [PolyShapeLayer layer];
    }
    return _foreground;
}

- (SymbolShapeLayer *)symbol
{
    if (_symbol == nil) {
        _symbol = [SymbolShapeLayer layer];
    }
    return _symbol;
}



#pragma mark -
#pragma mark Methods

- (void)setShapeForObject:(NSString *)name
{
    GeometricShapeLayer *s = [self.background setVisibleLayer:name];
    GeometricShapeLayer *o = [self.foreground setVisibleLayer:name];
    
    [self setNeedsDisplay:(s!=nil)||(o!=nil)];
}

- (void)setFillColorForObject:(id)object
{
    
    [self.background setFillColor:[[NSColor colorForObject:object] CGColor]];
}

- (void)setStrokeColorForObject:(id)object
{
    [self.background setStrokeColor:[[NSColor colorForObject:object] CGColor]];
}

- (void)setForegroundColorForObject:(id)object
{
    [self.symbol setForegroundColor:[[NSColor colorForObject:object] CGColor]];
}

- (void)setTextForObject:(id)object
{
    self.symbol.string = object;
}

- (void)setFontForObject:(id)object
{
    self.symbol.font = CFBridgingRetain(object);
}

- (void)setFontSizeForObject:(id)object
{
    self.symbol.fontSize = [object floatValue];
}

- (void)centerInRect:(CGRect)rect
{
    CGFloat dx = (CGRectGetWidth(rect) - CGRectGetWidth(self.frame)) / 2.;
    CGFloat dy = (CGRectGetHeight(rect) - CGRectGetHeight(self.frame)) / 2.;
    
    CGPoint newOrigin = CGPointMake(self.frame.origin.x + dx, self.frame.origin.y + dy);
    
    [self setFrameOrigin:newOrigin];
}

- (void)updateWithDictionary:(NSDictionary *)info
{
    
    [info enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        
    }];
}



@end
