//
//  StatusView.m
//  StatusThing
//
//  Created by Erik on 4/18/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//


#import "StatusView.h"
#import <QuartzCore/QuartzCore.h>
#import "ShapeFactory.h"
#import "Konstants.h"

typedef void (^DictionaryEnumerationBlock)(NSString *key, id obj, BOOL *stop);


@interface StatusView ()

@property (strong,nonatomic) ShapeFactory *shapeFactory;
@property (copy,nonatomic) DictionaryEnumerationBlock shapeLayerBlock;
@property (copy,nonatomic) DictionaryEnumerationBlock textLayerBlock;

@end

@implementation StatusView

@synthesize background   = _background;
@synthesize foreground   = _foreground;
@synthesize symbol       = _symbol;
@synthesize shapeFactory = _shapeFactory;
@synthesize shape        = _shape;

#pragma mark - Initialization Methods


- (instancetype)initWithFrame:(NSRect )rect
{
    self = [super initWithFrame:rect];
    if ( self ) {
        self.wantsLayer = YES;
        self.layer.opaque = NO;
        [self.layer addSublayer:self.background];
        [self.layer addSublayer:self.foreground];
        [self.layer addSublayer:self.symbol];

    }
    return self;
}

- (instancetype)init
{
    CGFloat w = [[NSStatusBar systemStatusBar] thickness];
    
    return [self initWithFrame:NSMakeRect(0, 0, w, w)];
}

// missing: - (instancetype)initWithCoder:(NSCoder *)coder

#pragma mark - Initialization Methods

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    NSLog(@"layoutSublayersOfLayer:%@",layer.name);
    CGPoint center = CGPointMake(CGRectGetMidX(layer.bounds), CGRectGetMidY(layer.bounds));
    self.background.position = center;
    self.foreground.position = center;
    self.symbol.position     = center;
}


- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    NSLog(@"drawLayer:%@ inContext:",layer.name);
    
    [self createPathsInRect:self.insetRect];

    
}

- (void)drawRect:(NSRect)dirtyRect{ }

#pragma mark - Properties



- (CAShapeLayer *)background
{
    if (_background == nil) {
        _background = [CAShapeLayer layer];
        _background.name = @"BackgroundLayer";
        _background.bounds = self.layer.bounds;
        _background.fillColor = CGColorCreateGenericRGB(0, 1, 0, 1);
        _background.backgroundColor = nil;
        _background.strokeColor = nil;
     }
    return _background;
}

- (CAShapeLayer *)foreground
{
    if (_foreground == nil) {
        _foreground = [CAShapeLayer layer];
        _foreground.name = @"ForegroundLayer";
        _foreground.bounds = self.layer.bounds;
        _foreground.fillColor = nil;
        _foreground.backgroundColor = nil;
        _foreground.strokeColor = CGColorCreateGenericRGB(0, 0, 0, 1);
        _foreground.lineWidth = 2.0;
    }
    return _foreground;
}

- (CATextLayer *)symbol
{
    if (_symbol == nil) {
        _symbol = [CATextLayer layer];
        _symbol.name = @"SymbolLayer";
        _symbol.bounds = self.layer.bounds;
        _symbol.string = @"\u018f";
        _symbol.font = CFBridgingRetain(@"Courier");
        _symbol.fontSize = 12;
        _symbol.alignmentMode = kCAAlignmentCenter;
        _symbol.foregroundColor = CGColorCreateGenericRGB(0, 0, 0, 1.0);
        _symbol.backgroundColor = nil;
    }
    return _symbol;
}

- (NSString *)shape
{
    if (_shape == nil) {
        _shape = ShapeNamePentagram;
    }
    return _shape;
}

- (void)setShape:(NSString *)shape
{
    // XXX no error propagation if shape is unrecognized
    
    _shape = shape;
    
    [self setNeedsDisplay:YES];
}

- (ShapeFactory *)shapeFactory
{
    if (_shapeFactory == nil) {
        _shapeFactory = [[ShapeFactory alloc] init];
    }
    return _shapeFactory;
} 


- (CGRect)insetRect
{
    return CGRectIntegral(CGRectInset(self.layer.bounds, 3, 3));
}

#pragma mark -
#pragma mark Methods


- (void)createPathsInRect:(CGRect)rect;
{
    CGPathRef pathRef = nil;
    
    
    if ([self.shape isEqualToString:ShapeNameNone]) {
        // draw nothing
        self.foreground.path = nil;
        self.background.path = nil;
        return;
    }
    
    if ([self.shape isEqualToString:ShapeNameCircle]) {
        pathRef = CGPathCreateWithEllipseInRect(rect, nil);
        goto copyPath;
    }

    if ([self.shape isEqualToString:ShapeNameRoundedSquare]) {
        pathRef = CGPathCreateWithRoundedRect(rect, 3, 3, nil);
        goto copyPath;
    }

    if (pathRef == nil) {
        __block CGMutablePathRef mPathRef = CGPathCreateMutable();
        
        NSArray *points = [self.shapeFactory pointsForShape:self.shape
                                             centeredInRect:self.insetRect
                                                  rotatedBy:0];
        
        CGPathMoveToPoint(mPathRef, nil,
                          [[points firstObject] pointValue].x,
                          [[points firstObject] pointValue].y);

        
        [points enumerateObjectsUsingBlock:^(NSValue *obj, NSUInteger idx, BOOL *stop) {
            CGPathAddLineToPoint(mPathRef, nil, [obj pointValue].x, [obj pointValue].y);
        }];

        CGPathCloseSubpath(mPathRef);
        pathRef = mPathRef;
    }
    
copyPath:

    self.foreground.path = CGPathCreateCopy(pathRef);
    self.background.path = CGPathCreateCopy(pathRef);
    
    CGPathRelease(pathRef);
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
    NSLog(@"statusView.updateWithDictionary: %@",info);
    [info enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        
        if ([key isEqualToString:@"shape"]) {
            self.shape = obj;
        }
        
        if ([key isEqualToString:@"foreground"]) {
            //            [self.foreground updateWithDictionary:obj];
        }
        if ([key isEqualToString:@"background"]) {
            //            [self.background updateWithDictionary:obj];
        }

        if ([key isEqualToString:@"symbol"]) {
            //            [self.symbol updateWithDictionary:obj];
        }
    }];
}


@end
