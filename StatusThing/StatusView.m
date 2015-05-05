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
#import "StatusThingUtilities.h"
#import "BlockUtilities.h"
#import "ShapeFactory.h"
#import "AnimationFactory.h"

#pragma mark - String Constants

static NSString * const StatusViewPropertyNameShape            = @"shape";
static NSString * const StatusViewPropertyNameForeground       = @"foreground";
static NSString * const StatusViewPropertyNameBackground       = @"background";
static NSString * const StatusViewPropertyNameSymbol           = @"symbol";

static NSString * const CALayerPropertyNameHidden              = @"hidden";
static NSString * const CALayerPropertyNameBackgroundColor     = @"backgroundColor";

static NSString * const CAShapeLayerPropertyNameFillColor      = @"fillColor";
static NSString * const CAShapeLayerPropertyNameStrokeColor    = @"strokeColor";
static NSString * const CAShapeLayerPropertyNameLineWidth      = @"lineWidth";

static NSString * const CATextLayerPropertyNameString          = @"string";
static NSString * const CATextLayerPropertyNameForegroundColor = @"foreground";
static NSString * const CATextLayerPropertyNameBackgroundColor = @"background";
static NSString * const CATextLayerPropertyNameFont            = @"font";
static NSString * const CATextLayerPropertyNameFontSize        = @"fontSize";

static NSString * const BackgroundLayerName                    = @"BackgroundLayer";
static NSString * const ForegroundLayerName                    = @"ForegroundLayer";
static NSString * const SymbolLayerName                        = @"SymbolLayer";
static NSString * const DefaultFontName                        = @"Courier";
static CGFloat    const DefaultFontSize                        = 12.;
static NSString * const DefaultString                          = @"\u018f";



typedef void (^ApplyDictionaryBlock)(id target,NSDictionary *info);

@interface StatusView ()

@property (strong,nonatomic) ShapeFactory         *shapeFactory;
@property (strong,nonatomic) AnimationFactory     *animationFactory;
@property (copy,nonatomic  ) ApplyDictionaryBlock  updateShapeLayer;
@property (copy,nonatomic  ) ApplyDictionaryBlock  updateTextLayer;

@end

@implementation StatusView

@synthesize background   = _background;
@synthesize foreground   = _foreground;
@synthesize symbol       = _symbol;
@synthesize shapeFactory = _shapeFactory;
@synthesize shape        = _shape;

#pragma mark - Lifecycle Methods

- (instancetype)initWithFrame:(NSRect )rect
{
    self = [super initWithFrame:rect];
    if ( self ) {
        self.wantsLayer = YES;
        self.layer.opaque = NO;
        [self.layer addSublayer:self.background];
        [self.layer addSublayer:self.foreground];
        [self.layer addSublayer:self.symbol];

        //        [self.animationFactory rotateLayer:self.symbol];
    }
    return self;
}

- (instancetype)init
{
    CGFloat w = [[NSStatusBar systemStatusBar] thickness];
    
    return [self initWithFrame:NSMakeRect(0, 0, w, w)];
}

// missing: - (instancetype)initWithCoder:(NSCoder *)coder

#pragma mark - CALayerDelegate Methods

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    CGPoint center = CGPointMake(CGRectGetMidX(layer.bounds), CGRectGetMidY(layer.bounds));
    self.background.position = center;
    self.foreground.position = center;
    
    self.symbol.bounds   = CGRectMake(0, 0, self.symbol.fontSize, self.symbol.fontSize);
    self.symbol.position = center;
    self.symbol.anchorPoint = CGPointMake(0.5, 0.3);

    
}


- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    // XXX this will hinder per-layer shape assignments later on
    
    CGPathRef path = [self createShapePath:self.shape inRect:self.insetRect];
    
    if (path) {
        self.foreground.path = CGPathCreateCopy(path);
        self.background.path = CGPathCreateCopy(path);
        CGPathRelease(path);
    }
    else {
        self.foreground.path = nil;
        self.background.path = nil;
    }
}

// drawLayer:inContext isn't called unless there is an empty drawRect:
- (void)drawRect:(NSRect)dirtyRect{ }

#pragma mark - Event Handling

- (void)mouseDown:(NSEvent *)theEvent
{


    // cancel animations here..
    [self.background removeAllAnimations];
    [self.foreground removeAllAnimations];
    [self.symbol     removeAllAnimations];

    [super mouseDown:theEvent];
}

#pragma mark - Overridden Properties

// removes the opaque border around the view
// when the NSStatusItem highlight mode is activated.

- (BOOL)allowsVibrancy { return YES; }

// XXX need to do some work here:
//     switch to contrasting stroke color for UI dark mode
//     and mouse down.


#pragma mark - Properties
- (CAShapeLayer *)background
{
    if (!_background) {
        _background = [CAShapeLayer layer];
        _background.name = BackgroundLayerName;
        _background.bounds = self.layer.bounds;
        _background.fillColor = CGColorCreateGenericRGB(0, 1, 0, 1);
        _background.backgroundColor = nil;
        _background.strokeColor = nil;
     }
    return _background;
}

- (CAShapeLayer *)foreground
{
    if (!_foreground) {
        _foreground = [CAShapeLayer layer];
        _foreground.name = ForegroundLayerName;
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
    if (!_symbol) {
        _symbol = [CATextLayer layer];
        _symbol.name = SymbolLayerName;
        _symbol.bounds = self.layer.bounds;
        _symbol.string = DefaultString;
        _symbol.font = CFBridgingRetain(DefaultFontName);
        _symbol.fontSize = DefaultFontSize;
        _symbol.alignmentMode = kCAAlignmentCenter;
        _symbol.foregroundColor = CGColorCreateGenericRGB(0, 0, 0, 1.0);
        
        //        _symbol addAnimation:[self.animationFactory ] forKey:<#(NSString *)#>
    }
    return _symbol;
}

- (NSString *)shape
{
    if (!_shape) {
        _shape = ShapeNameLine;
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
    if (!_shapeFactory) {
        _shapeFactory = [[ShapeFactory alloc] init];
    }
    return _shapeFactory;
}

- (AnimationFactory *)animationFactory
{
    if (!_animationFactory) {
        _animationFactory = [[AnimationFactory alloc] init];
    }
    return _animationFactory;
}

- (CGRect)insetRect
{
    return CGRectIntegral(CGRectInset(self.layer.bounds, 3, 3));
}


#pragma mark - Block Properties

- (ApplyDictionaryBlock)updateShapeLayer
{
    return ^void(CAShapeLayer *target,NSDictionary *info) {
        [info enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
            if ([key isEqualToString:CAShapeLayerPropertyNameFillColor]) {
                target.fillColor = [NSColor colorForObject:obj].CGColor;
            }
            if ([key isEqualToString:CAShapeLayerPropertyNameStrokeColor]) {
                target.strokeColor = [NSColor colorForObject:obj].CGColor;
            }
            if ([key isEqualToString:CALayerPropertyNameBackgroundColor]) {
                target.backgroundColor = [NSColor colorForObject:obj].CGColor;
            }
            if ([key isEqualToString:CAShapeLayerPropertyNameLineWidth]) {
                target.lineWidth = [obj floatValue];
            }
            

            if ([key isEqualToString:CALayerPropertyNameHidden]) {
                target.hidden = [obj boolValue];
            }
            
            if (self.animationFactory.animations[key]) {
                if ([obj boolValue]) {
                    [target addAnimation:[self.animationFactory animationForLayer:target withName:key]
                                  forKey:key];
                }
                else {
                    [target removeAnimationForKey:key];
                }
            }
        }];
    };
}

- (ApplyDictionaryBlock)updateTextLayer
{
    return ^void(CATextLayer *target,NSDictionary *info) {
        [info enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
            if ([key isEqualToString:CATextLayerPropertyNameString]) {
                target.string = obj;
                [target setNeedsLayout];
            }
            if ([key isEqualToString:CATextLayerPropertyNameForegroundColor]) {
                target.foregroundColor = [NSColor colorForObject:obj].CGColor;
            }
            if ([key isEqualToString:CATextLayerPropertyNameBackgroundColor]) {
                target.backgroundColor = [NSColor colorForObject:obj].CGColor;
            }
            if ([key isEqualToString:CATextLayerPropertyNameFont]) {
                target.font = CFBridgingRetain(obj);
                [target setNeedsLayout];
            }
            if ([key isEqualToString:CATextLayerPropertyNameFontSize]) {
                target.fontSize = [obj floatValue];
                [target setNeedsLayout];
            }
            if ([key isEqualToString:CALayerPropertyNameHidden]) {
                target.hidden = [obj boolValue];
            }
            
            if ([self.animationFactory hasAnimationNamed:key]) {
                if ([obj boolValue]) {
                    [target addAnimation:[self.animationFactory animationForLayer:target withName:key]
                                  forKey:key];
                }
                else {
                    [target removeAnimationForKey:key];
                }
            }
        }];
    };
}





#pragma mark - Methods


- (CGPathRef)createShapePath:(NSString *)shape inRect:(CGRect)rect;
{
    CGPathRef pathRef = nil;
    
    shape = [shape lowercaseString];
    
    if ([shape isEqualToString:ShapeNameNone]) {
        // draw nothing
        self.foreground.path = nil;
        self.background.path = nil;
 
        return nil;
    }
    
    if ([shape isEqualToString:ShapeNameCircle]) {
        pathRef = CGPathCreateWithEllipseInRect(rect, nil);
        return pathRef;
    }

    if ([shape isEqualToString:ShapeNameRoundedSquare]) {
        pathRef = CGPathCreateWithRoundedRect(rect, 3, 3, nil);
        return pathRef;
    }

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
    
    return mPathRef;
}

#pragma mark - Utility


- (void)centerInRect:(CGRect)rect
{
    CGFloat dx = (CGRectGetWidth(rect) - CGRectGetWidth(self.frame)) / 2.;
    CGFloat dy = (CGRectGetHeight(rect) - CGRectGetHeight(self.frame)) / 2.;
    
    CGPoint newOrigin = CGPointMake(self.frame.origin.x + dx, self.frame.origin.y + dy);
    
    [self setFrameOrigin:newOrigin];
}

#pragma mark - Update using blocks

- (void)updateWithDictionary:(NSDictionary *)info
{
    //NSLog(@"statusView.updateWithDictionary: %@",info);
    
    BlockWeakSelf weakSelf = self;
    
    [info enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        
        if ([key isEqualToString:StatusViewPropertyNameShape]) {
            weakSelf.shape = obj;
        }
        if ([key isEqualToString:StatusViewPropertyNameForeground]) {
            weakSelf.updateShapeLayer(weakSelf.foreground,obj);
        }
        if ([key isEqualToString:StatusViewPropertyNameBackground]) {
            weakSelf.updateShapeLayer(weakSelf.background,obj);
        }
        if ([key isEqualToString:StatusViewPropertyNameSymbol]) {
            weakSelf.updateTextLayer(weakSelf.symbol,obj);
        }
    }];
}


@end
