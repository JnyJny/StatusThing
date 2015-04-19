//
//  StatusView.m
//  StatusThing
//
//  Created by Erik on 4/18/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//


#import "StatusView.h"
#import <QuartzCore/QuartzCore.h>
#import "NSBezierPath+BezierPathQuartzUtilities.h"
#import "Konstants.h"

@interface StatusView()

@property (assign,nonatomic,getter=isDark,readonly) BOOL dark;

@property (strong,nonatomic,readonly) NSColor *outlineColor;

@property (strong,nonatomic) CAShapeLayer *shapeLayer;
@property (strong,nonatomic) CAShapeLayer *outlineLayer;
@property (strong,nonatomic) CAShapeLayer *symbolLayer;


@property (strong,nonatomic,readonly) NSBezierPath *circlePath;
@property (strong,nonatomic,readonly) NSBezierPath *trianglePath;
@property (strong,nonatomic,readonly) NSBezierPath *roundedSquarePath;
@property (strong,nonatomic,readonly) NSBezierPath *squarePath;
@property (strong,nonatomic,readonly) NSBezierPath *diamondPath;
@property (strong,nonatomic,readonly) NSBezierPath *pentagonPath;
@property (strong,nonatomic,readonly) NSBezierPath *hexagonPath;
@property (strong,nonatomic,readonly) NSBezierPath *octogonPath;
@property (strong,nonatomic,readonly) NSBezierPath *symbolPath;

@end

@implementation StatusView

@synthesize shape =             _shape;
@synthesize color =             _color;
@synthesize symbol =            _symbol;
@synthesize symbolColor =       _symbolColor;
@synthesize font =              _font;

@synthesize circlePath =        _circlePath;
@synthesize trianglePath =      _trianglePath;
@synthesize roundedSquarePath = _roundedSquarePath;
@synthesize squarePath =        _squarePath;
@synthesize diamondPath =       _diamondPath;
@synthesize pentagonPath =      _pentagonPath;
@synthesize hexagonPath =       _hexagonPath;
@synthesize octogonPath =       _octogonPath;
@synthesize symbolPath =        _symbolPath;

#pragma mark -
#pragma mark Initialization Methods

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if ( self ) {
        
        self.outlineWidth = 0.8;
        self.fontSize = CGRectGetHeight(frameRect) - 8;
        
        self.wantsLayer = YES;

        [self.layer addSublayer:self.shapeLayer];
        [self.layer addSublayer:self.outlineLayer];
        [self.layer addSublayer:self.symbolLayer];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithFrame:NSZeroRect];
}

#pragma mark -
#pragma mark Drawing Method

- (BOOL)wantsUpdateLayer
{
    return YES;
}


- (void)updateLayer
{
    if (self.shapeLayer.hidden == NO) {
        self.shapeLayer.fillColor = [self.color CGColor];
        if (self.shapeLayer.path == nil)
            self.shapeLayer.path = [self.path quartzPath];
    }
    
    if (self.outlineLayer.hidden == NO) {
        self.outlineLayer.strokeColor = [self.outlineColor CGColor];
        self.outlineLayer.lineWidth = self.outlineWidth;
        if (self.outlineLayer.path == nil) {
            self.outlineLayer.path = [self.path quartzPath];
        }
    }
    
    if (self.symbolLayer.hidden == NO) {
        self.symbolLayer.fillColor = [self.symbolColor CGColor];
        if (self.symbolLayer.path == nil)
            self.symbolLayer.path = [self.symbolPath quartzPath];
    }
}



- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    NSPoint center = NSMakePoint(CGRectGetMidX(layer.bounds), CGRectGetMidY(layer.bounds));
    
    self.shapeLayer.bounds = layer.bounds;
    self.shapeLayer.position = center;
    self.shapeLayer.path = self.outlineLayer.path = [self.path quartzPath];
    
    self.outlineLayer.bounds = layer.bounds;
    self.outlineLayer.position = center;
    self.outlineLayer.lineWidth = self.outlineWidth;
    
    self.symbolLayer.bounds = layer.bounds;
    self.symbolLayer.position = center;
    self.symbolLayer.path = [self.symbolPath quartzPath];
}



#pragma mark -
#pragma mark Properties

- (NSString *)shape
{
    if ( _shape == nil ) {
        _shape = StatusShapeCircle;
    }
    return _shape;
}

- (void)setShape:(NSString *)shape
{
    _shape = shape;
    
    if ( [_shape isEqualToString:StatusShapeNone]) {
        self.shapeLayer.hidden = YES;
        [self setNeedsDisplay:YES];
        return ;
    }
    
    self.shapeLayer.path = self.outlineLayer.path = nil;
    
    [self setNeedsDisplay:YES];
}

- (NSBezierPath *)path
{
    // Append @"Path" to the shape to allow KVC access to the shape paths
    
    NSBezierPath *path = [self valueForKey:[self.shape stringByAppendingString:@"Path"]];

    // XXX need exception handling here if self.shape DNE
    
    return path;
}

- (NSColor *)color
{
    if ( _color == nil ) {
        _color = [NSColor whiteColor];
    }
    return _color;
}

- (void)setColor:(NSColor *)color
{
    _color = color;
    [self setNeedsDisplay:YES];
}

- (NSString *)symbol
{
    if ( _symbol == nil ) {
        _symbol = @"\u018F";
    }
    return _symbol;
}

- (void)setSymbol:(NSString *)symbol
{
    _symbol = symbol;
    self.symbolLayer.path = nil;
    [self setNeedsDisplay:YES];
}

- (NSColor *)symbolColor
{
    if ( _symbolColor == nil ) {
        _symbolColor = [NSColor blackColor];
    }
    return _symbolColor;
}

- (void)setSymbolColor:(NSColor *)symbolColor
{
    _symbolColor = symbolColor;
    [self setNeedsDisplay:YES];
}


#define kDefaultFontName @"Courier"

- (NSFont *)font
{
    if (_font == nil ) {
        _font = [NSFont fontWithName:kDefaultFontName size:self.fontSize];
    }
    return _font;
}

- (void)setFont:(NSFont *)font
{
    _font = font;
    self.symbolLayer.path = nil;
    [self setNeedsDisplay:YES];
}

- (void)setFontSize:(CGFloat)fontSize
{
    _fontSize = fontSize;
    self.symbolLayer.path = nil;
    [self setNeedsDisplay:YES];
}


- (BOOL)shapeIsHidden
{
    return self.shapeLayer.hidden;
}

- (void)setShapeHidden:(BOOL)shapeHidden
{
    self.shapeLayer.hidden = shapeHidden;
    [self setNeedsDisplay:YES];
}

- (BOOL)outlineIsHidden
{
    return self.outlineLayer.hidden;
}

- (void)setOutlineHidden:(BOOL)outlineHidden
{
    self.outlineLayer.hidden = outlineHidden;
    [self setNeedsDisplay:YES];
}

- (BOOL)symbolIsHidden
{
    return self.symbolLayer.hidden;
}

- (void)setSymbolHidden:(BOOL)symbolHidden
{
    self.symbolLayer.hidden = symbolHidden;
}



#pragma mark -
#pragma mark Expensive Properties

- (BOOL)isDark
{
    // this method roots around in User Defaults for the key kAppleInterfaceStyle
    // and compares it (if found) to the string "dark".  This determines whether
    // the user has requested "Dark" mode, necessitating a light colored outline
    // instead of the regular black outline
    
    // this would be handled by the StatusItem.button if we were supplying a
    // Template image, but we're not.
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *appleInterfaceStyle = [userDefaults stringForKey:kAppleInterfaceStyle];
    
    return [[appleInterfaceStyle lowercaseString] isEqualToString:@"dark"];
}

- (NSColor *)outlineColor
{
    return self.isDark?[NSColor whiteColor]:[NSColor blackColor];
}

#pragma mark -
#pragma mark Layer Properties

- (CAShapeLayer *)shapeLayer
{
    if ( _shapeLayer == nil ) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.name = @"shapeLayer";
        _shapeLayer.strokeColor = nil;
        _shapeLayer.fillColor = [self.color CGColor];
     }
    return _shapeLayer;
}

- (CAShapeLayer *)outlineLayer
{
    if ( _outlineLayer == nil ) {
        _outlineLayer = [CAShapeLayer layer];
        _outlineLayer.name = @"outlineLayer";
        _outlineLayer.strokeColor = [self.outlineColor CGColor];
        _outlineLayer.fillColor = nil;
        _outlineLayer.lineWidth = self.outlineWidth;
    }
    return _outlineLayer;
}

- (CAShapeLayer *)symbolLayer
{
    if ( _symbolLayer == nil ) {
        _symbolLayer = [CAShapeLayer layer];
        _symbolLayer.name = @"symbolLayer";
        _symbolLayer.strokeColor = nil;
        _symbolLayer.fillColor = [self.symbolColor CGColor];
    }
    return _symbolLayer;
}


#pragma mark -
#pragma mark Private Methods

- (NSRect)insetRect:(NSRect)srcRect byPercentage:(CGFloat) percentage
{
    CGFloat dx = srcRect.size.width * percentage;
    CGFloat dy = srcRect.size.height * percentage;
    
    return NSIntegralRect(NSInsetRect(srcRect, dx, dy));
}



#pragma mark -
#pragma mark Path Properties

- (NSBezierPath *) circlePath
{
    if (_circlePath == nil) {
        NSRect rect = [self insetRect:self.bounds byPercentage:0.2];
        _circlePath = [NSBezierPath bezierPathWithOvalInRect:rect];
    }
    return _circlePath;
}

- (NSBezierPath *) trianglePath
{
    if ( _trianglePath == nil ) {
        NSRect rect = [self insetRect:self.bounds byPercentage:0.1];
        NSPoint v[3] =  { NSMakePoint(CGRectGetMinX(rect),CGRectGetMinY(rect)),
            NSMakePoint(CGRectGetMaxX(rect),CGRectGetMinY(rect)),
            NSMakePoint(CGRectGetMidX(rect),CGRectGetMaxY(rect)) };
        
        _trianglePath = [NSBezierPath bezierPath];
        [_trianglePath appendBezierPathWithPoints:v count:3];
        [_trianglePath closePath];
    }
    return _trianglePath;
}

- (NSBezierPath *)roundedSquarePath
{
    if (_roundedSquarePath == nil ) {
        NSRect rect = [self insetRect:self.bounds byPercentage:0.1];
        _roundedSquarePath = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:4 yRadius:4];
    }
    return _roundedSquarePath;
}

- (NSBezierPath *)squarePath
{
    if ( _squarePath == nil ) {
        NSRect rect = [self insetRect:self.bounds byPercentage:0.1];
        _squarePath = [NSBezierPath bezierPathWithRect:rect];
    }
    return _squarePath;
}

- (NSBezierPath *)diamondPath
{
    if ( _diamondPath == nil ) {
        NSRect rect = [self insetRect:self.bounds byPercentage:0.1];
        NSPoint v[4] = { NSMakePoint(CGRectGetMidX(rect),CGRectGetMinY(rect)),
            NSMakePoint(CGRectGetMaxX(rect),CGRectGetMidY(rect)),
            NSMakePoint(CGRectGetMidX(rect),CGRectGetMaxY(rect)),
            NSMakePoint(CGRectGetMinX(rect),CGRectGetMidY(rect)) };
        
        _diamondPath = [NSBezierPath bezierPath];
        [_diamondPath appendBezierPathWithPoints:v count:4];
        [_diamondPath closePath];
    }
    return _diamondPath;
}

- (NSBezierPath *)pentagonPath
{
    if (_pentagonPath == nil) {
        NSRect rect = [self insetRect:self.bounds byPercentage:0.1];
        CGFloat dx = rect.size.width / 4;
        NSPoint v[5] = { NSMakePoint(CGRectGetMinX(rect) + dx,CGRectGetMinY(rect)),
            NSMakePoint(CGRectGetMaxX(rect) - dx,CGRectGetMinY(rect)),
            NSMakePoint(CGRectGetMaxX(rect),CGRectGetMidY(rect)),
            NSMakePoint(CGRectGetMidX(rect),CGRectGetMaxY(rect)),
            NSMakePoint(CGRectGetMinX(rect),CGRectGetMidY(rect)) };
        
        _pentagonPath = [NSBezierPath bezierPath];
        [_pentagonPath appendBezierPathWithPoints:v count:5];
        [_pentagonPath closePath];
    }
    return _pentagonPath;
}

- (NSBezierPath *)hexagonPath
{
    if (_hexagonPath == nil) {
        NSRect rect = [self insetRect:self.bounds byPercentage:0.1];
        CGFloat dx = rect.size.width / 4;
        NSPoint v[6] = {NSMakePoint(CGRectGetMinX(rect) + dx,CGRectGetMinY(rect)),
            NSMakePoint(CGRectGetMaxX(rect) - dx,CGRectGetMinY(rect)),
            NSMakePoint(CGRectGetMaxX(rect),CGRectGetMidY(rect)),
            NSMakePoint(CGRectGetMaxX(rect) - dx,CGRectGetMaxY(rect)),
            NSMakePoint(CGRectGetMinX(rect) + dx,CGRectGetMaxY(rect)),
            NSMakePoint(CGRectGetMinX(rect),CGRectGetMidY(rect)) };
        
        _hexagonPath = [NSBezierPath bezierPath];
        [_hexagonPath appendBezierPathWithPoints:v count:6];
        [_hexagonPath closePath];
    }
    return _hexagonPath;
}

- (NSBezierPath *)octogonPath
{
    if (_octogonPath == nil) {
        NSRect rect = [self insetRect:self.bounds byPercentage:0.1];
        CGFloat dx = rect.size.width / 3;
        CGFloat dy = rect.size.height / 3;
        NSPoint v[8] = { NSMakePoint(CGRectGetMinX(rect) + dx,CGRectGetMinY(rect)),
            NSMakePoint(CGRectGetMaxX(rect) - dx,CGRectGetMinY(rect)),
            NSMakePoint(CGRectGetMaxY(rect),CGRectGetMinY(rect) + dy),
            NSMakePoint(CGRectGetMaxX(rect),CGRectGetMaxY(rect) - dy),
            NSMakePoint(CGRectGetMaxX(rect) - dx,CGRectGetMaxY(rect)),
            NSMakePoint(CGRectGetMinX(rect) + dx,CGRectGetMaxY(rect)),
            NSMakePoint(CGRectGetMinX(rect),CGRectGetMaxY(rect) - dy),
            NSMakePoint(CGRectGetMinX(rect),CGRectGetMinY(rect) + dy) };
        
        _octogonPath = [NSBezierPath bezierPath];
        [_octogonPath appendBezierPathWithPoints:v count:8];
        [_octogonPath closePath];
    }
    return _octogonPath;
}


- (NSBezierPath *) symbolPath
{
    if (_symbolPath == nil && (self.symbol)) {
          
        NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
        NSTextStorage *textStorage = [[NSTextStorage alloc] initWithString:self.symbol];
        NSRange symbolRange = NSMakeRange(0, self.symbol.length);
        
        [textStorage addAttribute:NSFontAttributeName value:self.font range:symbolRange];
        [textStorage fixAttributesInRange:symbolRange];
        [textStorage addLayoutManager:layoutManager];
        
        NSInteger numGlyphs = [layoutManager numberOfGlyphs];

        NSGlyph *glyphs = calloc(sizeof(NSGlyph), numGlyphs + 1);
        
        [layoutManager getGlyphs:glyphs range:symbolRange];
        
        [textStorage removeLayoutManager:layoutManager];
        
        // This is ugly.
        // make the path
        // get the bounds for the path
        // create an inset rect
        // make the path again
        // use the inset rect's origin as the path origin
        
        _symbolPath = [NSBezierPath bezierPath];
        [_symbolPath moveToPoint:self.bounds.origin];
        [_symbolPath appendBezierPathWithGlyph:glyphs[0] inFont:self.font];

#if 1
        CGFloat dx = (self.bounds.size.width - _symbolPath.bounds.size.width) / 2.;

        // dy divisor could be 4 for shapes which "sit" on the baseline at MinY
        
        CGFloat dy = (self.bounds.size.height - _symbolPath.bounds.size.height) / 2.;
        
        NSRect sRect = NSInsetRect(self.bounds, dx, dy);
        
        _symbolPath = [NSBezierPath bezierPath];
        [_symbolPath moveToPoint:sRect.origin];
        [_symbolPath appendBezierPathWithGlyph:glyphs[0] inFont:self.font];
#endif
        
        free(glyphs);
        
        [self setNeedsDisplay:YES];
    }
    
    if ( self.symbol == nil) {
        _symbolPath = nil;
    }

     return _symbolPath;
}



#pragma mark -
#pragma mark Methods





@end
