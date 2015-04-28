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

@synthesize shape      = _shape;
@synthesize background = _background;
@synthesize foreground = _foreground;
@synthesize symbol     = _symbol;

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

        self.foreground.fillColor = nil;
        self.foreground.backgroundColor = nil;
        self.foreground.lineWidth = 2.0;
        self.foreground.strokeColor = [[NSColor blackColor] CGColor];
        
        self.background.strokeColor = nil;
        self.background.backgroundColor = nil;
        self.background.fillColor = [[NSColor redColor] CGColor];
        
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
    CGPoint d = kInset(3);
    [self.background centerInRect:layer.bounds andInset:d];
    [self.foreground centerInRect:layer.bounds andInset:d];
    [self.symbol     centerInRect:layer.bounds andInset:d];
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

- (void)setShape:(NSString *)shape
{
    // XXX no error propagation if shape is unrecognized
    _shape = shape;
    
    self.foreground.shape = shape;
    self.background.shape = shape;

    [self setNeedsDisplay:YES];

}


#pragma mark -
#pragma mark Methods

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
        BOOL handled = NO;
        
        if (!handled && [key isEqualToString:@"shape"]) {
            self.shape = obj;
            handled = YES;
        }
        
        if (!handled && [key isEqualToString:@"foreground"]) {
            [self.foreground updateWithDictionary:obj];
            handled = YES;
        }
        if (!handled && [key isEqualToString:@"background"]) {
            [self.background updateWithDictionary:obj];
            handled = YES;
        }

        if (!handled && [key isEqualToString:@"symbol"]) {
            [self.symbol updateWithDictionary:obj];
            handled = YES;
        }

    }];
}


@end
