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
        
        [self.shape setVisibleShape:GeometricShapeCircle];
        
        self.shape.strokeColor = nil;
        
        [self.outline setVisibleShape:GeometricShapeCircle];
        self.outline.fillColor = nil;
        self.outline.lineWidth = 2.;
        
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

- (void)updateLayer
{
    NSLog(@"updateLayer");


}


- (void)layoutSublayersOfLayer:(CALayer *)layer
{

    [self.shape centerInRect:layer.bounds andInset:CGPointMake(2, 2)];
    [self.outline centerInRect:layer.bounds andInset:CGPointMake(2, 2)];
    [self.symbol centerInRect:layer.bounds andInset:CGPointMake(2, 2)];
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
    }
    return _outline;
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
    [self.shape setVisibleShape:name];
    [self.outline setVisibleShape:name];
}

- (void)setFillColorForObject:(id)object
{
    
    [self.shape setFillColor:[[NSColor colorForObject:object] CGColor]];
}

- (void)setStrokeColorForObject:(id)object
{
    [self.shape setStrokeColor:[[NSColor colorForObject:object] CGColor]];
}

- (void)setForegroundColorForObject:(id)object
{
    [self.symbol setForegroundColor:[[NSColor colorForObject:object] CGColor]];
}

- (void)centerInRect:(CGRect)rect
{
    CGFloat dx = (CGRectGetWidth(rect) - CGRectGetWidth(self.frame)) / 2.;
    CGFloat dy = (CGRectGetHeight(rect) - CGRectGetHeight(self.frame)) / 2.;
    
    CGPoint newOrigin = CGPointMake(self.frame.origin.x + dx, self.frame.origin.y + dy);
    
    [self setFrameOrigin:newOrigin];
}

- (void)updateKeyPathsWithDictionary:(NSDictionary *)info
{
    
    [info enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {

        @try {
            [self setValue:obj forKey:[key stringByAppendingString:@"ForObject"] ];
        }
        @catch (NSException *exception) {
            //NSLog(@"%@ForObject - updateWithDictionary: %@",key,exception);
        }
    
        @try {
            [self setValue:obj forKeyPath:key];
        }
        @catch (NSException *exception) {
            //NSLog(@"%@ - updateKeyPathsWithDictionary: %@",key,exception);
        }
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    NSLog(@"statusView got %@ %@",keyPath,change);
}

@end
