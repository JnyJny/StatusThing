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

@synthesize shape = _shape;
@synthesize outline = _outline;
@synthesize symbol = _symbol;

#pragma mark -
#pragma mark Initialization Methods

- (instancetype)initWithFrame:(NSRect )rect
{
    self = [super initWithFrame:rect];
    if ( self ) {
        self.wantsLayer = YES;
        [self.layer addSublayer:self.shape];
        [self.layer addSublayer:self.outline];
        [self.layer addSublayer:self.symbol];
        
        GeometricShapeLayer *sl = [self.shape setVisibleShape:GeometricShapeBarredCircle];
        sl.fillColor = [[NSColor redColor] CGColor];
        sl.strokeColor = [[NSColor whiteColor] CGColor];
        sl.lineWidth = 2.;
        
        GeometricShapeLayer *ol = [self.outline setVisibleShape:GeometricShapeCircle];
        ol.strokeColor = [[NSColor blackColor] CGColor];
        ol.fillColor = nil;
        ol.lineWidth = 2.;

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

- (BOOL)wantsUpdateLayer { return YES; }

- (void)updateLayer
{
    NSLog(@"updateLayer");
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    [self.shape centerInRect:layer.bounds andInset:CGPointMake(2, 2)];
    [self.outline centerInRect:layer.bounds andInset:CGPointMake(2, 2)];
    [self.symbol centerInRect:layer.bounds andInset:CGPointMake(2, 2)];
    
    self.symbol.bounds = layer.bounds;
    self.symbol.position = CGPointMake(CGRectGetMidX(layer.bounds), CGRectGetMidY(layer.bounds));
}



#pragma mark -
#pragma mark Properties

- (PolyShapeLayer *)shape
{
    if (_shape == nil) {
        _shape = [PolyShapeLayer layer];
     }
    return _shape;
}

- (PolyShapeLayer *)outline
{
    if (_outline == nil) {
        _outline = [PolyShapeLayer layer];
        _outline.lineWidth = 0.8;
    }
    return _outline;
}

- (SymbolShapeLayer *)symbol
{
    if (_symbol == nil) {
        _symbol = [SymbolShapeLayer layer];
        _symbol.fontSize = CGRectGetHeight(self.bounds);
    }
    return _symbol;
}

#pragma mark -
#pragma mark Methods

- (void)updateKeyPathsWithDictionary:(NSDictionary *)info
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


@end
