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
#import "FilterFactory.h"

#pragma mark - String Constants

static NSString * const StatusViewPropertyNameShape            = @"shape";
static NSString * const StatusViewPropertyNameForeground       = @"foreground";
static NSString * const StatusViewPropertyNameBackground       = @"background";
static NSString * const StatusViewPropertyNameText             = @"text";

static NSString * const CALayerPropertyNameHidden              = @"hidden";
static NSString * const CALayerPropertyNameBackgroundColor     = @"background";

static NSString * const CAShapeLayerPropertyNameFillColor      = @"fill";
static NSString * const CAShapeLayerPropertyNameStrokeColor    = @"stroke";
static NSString * const CAShapeLayerPropertyNameLineWidth      = @"lineWidth";

static NSString * const CATextLayerPropertyNameString          = @"string";
static NSString * const CATextLayerPropertyNameForegroundColor = @"foreground";
static NSString * const CATextLayerPropertyNameBackgroundColor = @"background";
static NSString * const CATextLayerPropertyNameFont            = @"font";
static NSString * const CATextLayerPropertyNameFontSize        = @"fontSize";

static NSString * const CALayerPropertySynonymColor            = @"color";

static NSString * const BackgroundLayerName                    = @"BackgroundLayer";
static NSString * const ForegroundLayerName                    = @"ForegroundLayer";
static NSString * const TextLayerName                          = @"TextLayer";
static NSString * const DefaultFontName                        = @"Courier";
static CGFloat    const DefaultFontSize                        = 12.;
static NSString * const DefaultString                          = @"\u018f";

static CGFloat const StatusViewInsetDelta                      = 4.0;

static NSString * const ShapeKeyName                           = @"name";
static NSString * const ShapeKeyHeading                        = @"heading";// set
static NSString * const ShapeKeyRotate                         = @"rotate";// additive

static NSString * const LayerKeyFill                           = @"fill";
static NSString * const LayerKeyStroke                         = @"stroke";
static NSString * const LayerKeyLineWidth                      = @"lineWidth";
static NSString * const LayerKeyHidden                         = @"hidden";
static NSString * const LayerKeyFont                           = @"font";
static NSString * const LayerKeyFontSize                       = @"fontSize";
static NSString * const LayerKeyString                         = @"string";
static NSString * const LayerKeyForeground                     = @"foreground";
static NSString * const LayerKeyBackground                     = @"background";
static NSString * const LayerKeyAnimations                     = @"animations";

static NSString * const CapabilityKeyShapes                    = @"shapes";
static NSString * const CapabilityKeyAnimations                = @"animations";
static NSString * const CapabilityKeyFilters                   = @"filters";
static NSString * const CapabilityKeyColors                    = @"colors";


typedef void (^ApplyDictionaryBlock)(id target,NSDictionary *info);

@interface StatusView ()

@property (strong,nonatomic) ShapeFactory         *shapeFactory;
@property (strong,nonatomic) AnimationFactory     *animationFactory;
@property (strong,nonatomic) FilterFactory        *filterFactory;
@property (strong,nonatomic) NSNotificationCenter *notificationCenter;
@property (copy,nonatomic  ) ApplyDictionaryBlock  updateShapeLayer;
@property (copy,nonatomic  ) ApplyDictionaryBlock  updateTextLayer;
@property (copy,nonatomic  ) ApplyDictionaryBlock  updateShape;


@end

@implementation StatusView

@synthesize background   = _background;
@synthesize foreground   = _foreground;
@synthesize text         = _text;
@synthesize shapeFactory = _shapeFactory;
@synthesize shape        = _shape;
@synthesize capabilities = _capabilities;
@synthesize shapeHeading = _shapeHeading;

#pragma mark - Lifecycle Methods

- (instancetype)initWithFrame:(NSRect )rect
{
    self = [super initWithFrame:rect];
    if ( self ) {
        self.wantsLayer = YES;
        self.layer.opaque = NO;
        [self.layer addSublayer:self.background];
        [self.layer addSublayer:self.foreground];
        [self.layer addSublayer:self.text];
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
    
    CGSize sz = [self.text.string sizeWithAttributes:@{NSFontAttributeName:[NSFont fontWithName:(NSString *)self.text.font
                                                                                           size:self.text.fontSize]}];
    self.text.bounds      = CGRectMake(0, 0, sz.width, sz.height);
    self.text.position    = center;
    self.text.anchorPoint = CGPointMake(0.5, 0.5);

    
}


- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    // XXX this will hinder per-layer shape assignments later on
    // XXX better now that createShapePath:inRect has moved to shapeFactory
    // 
    
    CGPathRef path = [self.shapeFactory createShapePath:self.shape inRect:self.insetRect rotatedBy:self.shapeHeading];
    
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

// XXX not sure which looks better, let the animation run while
//     the menu is popped down and stop when the user lets go.
//     Or stop the animation immediately. 6 of one 12/2 of the other.

- (void)mouseDown:(NSEvent *)theEvent
{
    // cancel animations here..
    //[self removeAllAnimations];

    [super mouseDown:theEvent];
}

- (void)mouseUp:(NSEvent *)theEvent
{
    [self removeAllAnimations];
    [super mouseUp:theEvent];
}

#pragma mark - Overridden Properties

// allowsVibrancy removes the opaque border around the view
// when the NSStatusItem highlight mode is activated.

- (BOOL)allowsVibrancy { return YES; }

// XXX need to do some work here:
//     switch to contrasting stroke color for UI dark mode
//     and mouse down.  could apply a global image filter to
//     invert color choices. may look... ugly. but worth trying.

#pragma mark - Properties

- (CAShapeLayer *)background
{
    if (!_background) {
        _background = [CAShapeLayer layer];
        _background.name = BackgroundLayerName;
        _background.bounds = self.layer.bounds;
        _background.fillColor = CGColorCreateGenericRGB(0, 0, 0, 0);
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
        _foreground.lineWidth = 3.0;
    }
    return _foreground;
}

- (CATextLayer *)text
{
    if (!_text) {
        _text = [CATextLayer layer];
        _text.name = TextLayerName;
        _text.bounds = self.layer.bounds;
        _text.string = @"";
        _text.font = (__bridge CFTypeRef)(DefaultFontName);
        _text.fontSize = DefaultFontSize;
        _text.alignmentMode = kCAAlignmentCenter;
        _text.foregroundColor = CGColorCreateGenericRGB(0, 0, 0, 1.0);
    }
    return _text;
}

- (NSString *)shape
{
    if (!_shape) {
        _shape = ShapeNameCircle;
        _shapeHeading = 0;
    }
    return _shape;
}

- (void)setShape:(NSString *)shape
{
    _shape = shape;
    [self setNeedsDisplay:YES]; //needed
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

- (FilterFactory *)filterFactory
{
    if (!_filterFactory) {
        _filterFactory = [[FilterFactory alloc] init];
    }
    return _filterFactory;
}

- (CGRect)insetRect
{
    return CGRectIntegral(CGRectInset(self.layer.bounds,StatusViewInsetDelta,StatusViewInsetDelta));
}


- (NSDictionary *)capabilities
{
    if (!_capabilities) {
        _capabilities = @{ CapabilityKeyShapes:[ShapeFactory allShapes],
                           CapabilityKeyAnimations:self.animationFactory.animations.allKeys,
                           CapabilityKeyFilters:self.filterFactory.filters.allKeys,
                           CapabilityKeyColors:[NSColor allColorNames]};
    }
    return _capabilities;
}





#pragma mark - Block Properties

- (ApplyDictionaryBlock)updateShapeLayer
{
    return ^void(CAShapeLayer *target,NSDictionary *info) {
        __block BOOL allowAnimations = [[NSUserDefaults standardUserDefaults] boolForKey:StatusThingPreferenceAllowAnimations];
        
        [info enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {

            if ([key isEqualToString:CALayerPropertySynonymColor]) {

                if ([target.name isEqualToString:BackgroundLayerName]) {
                    target.fillColor = [NSColor colorForObject:obj].CGColor;
                }
                
                if ([target.name isEqualToString:ForegroundLayerName]) {
                    target.strokeColor = [NSColor colorForObject:obj].CGColor;
                }
                
            }
            
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
            
            if (allowAnimations && [self.animationFactory hasAnimationNamed:key]) {
                if ([obj isKindOfClass:NSString.class]) {
                    [target addAnimation:[self.animationFactory animationForLayer:target withName:key andSpeed:obj]
                                  forKey:key];
                }
                if ([obj isKindOfClass:NSNumber.class]) {
                    if ([obj boolValue]) {
                        [target addAnimation:[self.animationFactory animationForLayer:target withName:key]
                                      forKey:key];
                    }
                    else {
                        [target removeAnimationForKey:key];
                    }
                }
            }
        }];
    };
}

- (ApplyDictionaryBlock)updateTextLayer
{
    return ^void(CATextLayer *target,NSDictionary *info) {

        __block BOOL allowAnimations = [[NSUserDefaults standardUserDefaults] boolForKey:StatusThingPreferenceAllowAnimations];
        
        [info enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
            if ([key isEqualToString:CATextLayerPropertyNameString]) {
                target.string = obj;
                [target setNeedsLayout];
            }
            if ([key isEqualToString:CATextLayerPropertyNameForegroundColor] ||
                [key isEqualToString:CALayerPropertySynonymColor] ) {
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
            
            if (allowAnimations && [self.animationFactory hasAnimationNamed:key]) {
                
                if ([obj isKindOfClass:NSString.class]) {
                    [target addAnimation:[self.animationFactory animationForLayer:target withName:key andSpeed:obj]
                                  forKey:key];
                }
                if ([obj isKindOfClass:NSNumber.class]) {
                    if ([obj boolValue]) {
                        [target addAnimation:[self.animationFactory animationForLayer:target withName:key]
                                      forKey:key];
                    }
                    else {
                        [target removeAnimationForKey:key];
                    }
                }
            }
        }];
    };
}

- (ApplyDictionaryBlock)updateShape
{
    return ^void(StatusView *target,NSDictionary *info) {
        
        [info enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
            
            if ([key caseInsensitiveCompare:ShapeKeyName] == NSOrderedSame) {
                target.shape = obj;
            }
            
            if ([key caseInsensitiveCompare:ShapeKeyHeading] == NSOrderedSame) {
                target.shapeHeading = [obj floatValue];
            }

        }];
    };
}

#pragma mark - Methods




#pragma mark - Utility


- (void)centerInRect:(CGRect)rect
{
    CGFloat dx = (CGRectGetWidth(rect) - CGRectGetWidth(self.frame)) / 2.;
    CGFloat dy = (CGRectGetHeight(rect) - CGRectGetHeight(self.frame)) / 2.;
    
    CGPoint newOrigin = CGPointMake(self.frame.origin.x + dx, self.frame.origin.y + dy);
    
    [self setFrameOrigin:newOrigin];
}

- (void)removeAllAnimations
{
    [self.background removeAllAnimations];
    [self.foreground removeAllAnimations];
    [self.text       removeAllAnimations];
}

#pragma mark - Update using blocks

- (void)updateWithDictionary:(NSDictionary *)info
{
    //NSLog(@"statusView.updateWithDictionary: %@",info);
    
    BlockWeakSelf weakSelf = self;
    
    [info enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        
        if ([key isEqualToString:StatusViewPropertyNameShape]) {
            
            if ([obj isKindOfClass:NSString.class]) {
                weakSelf.shape = obj;
            }

            if ([obj isKindOfClass:NSDictionary.class]) {
                weakSelf.updateShape(weakSelf,obj);
            }
        }
        if ([key isEqualToString:StatusViewPropertyNameForeground]) {
            weakSelf.updateShapeLayer(weakSelf.foreground,obj);
        }
        if ([key isEqualToString:StatusViewPropertyNameBackground]) {
            weakSelf.updateShapeLayer(weakSelf.background,obj);
        }
        if ([key isEqualToString:StatusViewPropertyNameText]) {
            weakSelf.updateTextLayer(weakSelf.text,obj);
        }
    }];
}

- (NSDictionary *)currentConfiguration
{
    // send back configInfo @{ backgroundInfo,foregroundInfo,textInfo,shape }

    NSMutableDictionary *backgroundInfo = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *foregroundInfo = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *textInfo       = [[NSMutableDictionary alloc] init];
    NSArray             *animationKeys  = nil;

    if (self.background.fillColor) {
        [backgroundInfo setObject:[[NSColor colorWithCGColor:self.background.fillColor] dictionaryForColor]
                           forKey:LayerKeyFill];
    }
    if (self.background.strokeColor) {
        [backgroundInfo setObject:[[NSColor colorWithCGColor:self.background.strokeColor] dictionaryForColor]
                           forKey:LayerKeyStroke];
    }
    [backgroundInfo setObject:[NSNumber numberWithFloat:self.background.lineWidth] forKey:LayerKeyLineWidth];
    [backgroundInfo setObject:[NSNumber numberWithBool:self.background.hidden] forKey:LayerKeyHidden];


    animationKeys = [self.background animationKeys];
    if (animationKeys) {
        [backgroundInfo setObject:animationKeys forKey:LayerKeyAnimations];
    }
    
    // foreground
    if (self.foreground.fillColor) {
        [foregroundInfo setObject:[[NSColor colorWithCGColor:self.foreground.fillColor] dictionaryForColor]
                           forKey:LayerKeyFill];
    }
    
    if (self.foreground.strokeColor) {
        [foregroundInfo setObject:[[NSColor colorWithCGColor:self.foreground.strokeColor] dictionaryForColor]
                           forKey:LayerKeyStroke];
    }
    [foregroundInfo setObject:[NSNumber numberWithFloat:self.foreground.lineWidth] forKey:LayerKeyLineWidth];
    [foregroundInfo setObject:[NSNumber numberWithBool:self.foreground.hidden] forKey:LayerKeyHidden];
    animationKeys = [self.foreground animationKeys];
    if ( animationKeys) {
        [foregroundInfo setObject:animationKeys forKey:LayerKeyAnimations];
    }

    
    if (self.text.foregroundColor) {
        [textInfo setObject:[[NSColor colorWithCGColor:self.text.foregroundColor] dictionaryForColor]
                     forKey:LayerKeyForeground];
    }
    
    [textInfo setObject: self.text.string forKey:LayerKeyString];
    [textInfo setObject:(NSString *)self.text.font forKey:LayerKeyFont];
    [textInfo setObject:[NSNumber numberWithFloat:self.text.fontSize] forKey:LayerKeyFontSize];
    [textInfo setObject:[NSNumber numberWithBool:self.text.hidden] forKey:LayerKeyHidden];
    animationKeys = [self.text animationKeys];
    if ( animationKeys) {
        [textInfo setObject:animationKeys forKey:LayerKeyAnimations];
    }
    
    return @{ StatusViewPropertyNameShape:self.shape,
              StatusViewPropertyNameBackground:backgroundInfo,
              StatusViewPropertyNameForeground:foregroundInfo,
              StatusViewPropertyNameText:textInfo };
}


@end
