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
#import "NSColor+NamedColorUtilities.h"
#import "Konstants.h"

#define StringIsTrue(S) [[S lowercaseString] isEqualToString:@"yes"] || [[(S) lowercaseString] isEqualToString:@"true"]

@interface StatusView()

@property (assign,nonatomic,getter=isDark,readonly) BOOL dark;

@property (strong,nonatomic,readonly) NSColor *outlineColor;

@property (strong,nonatomic) CAShapeLayer *shapeLayer;
@property (strong,nonatomic) CAShapeLayer *outlineLayer;
@property (strong,nonatomic) CAShapeLayer *symbolLayer;

@property (strong,nonatomic,readonly) NSBezierPath *path;
@property (assign,nonatomic,readonly) CGPathRef     pathRef;

@property (strong,nonatomic,readonly) NSBezierPath *symbolPath;
@property (assign,nonatomic,readonly) CGPathRef     symbolPathRef;

@property (strong,nonatomic,readonly) NSBezierPath *circlePath;
@property (assign,nonatomic,readonly) CGPathRef     circlePathRef;

@property (strong,nonatomic,readonly) NSBezierPath *trianglePath;
@property (assign,nonatomic,readonly) CGPathRef     trianglePathRef;

@property (strong,nonatomic,readonly) NSBezierPath *roundedSquarePath;
@property (assign,nonatomic,readonly) CGPathRef     roundedSquarePathRef;
@property (strong,nonatomic,readonly) NSBezierPath *squarePath;
@property (assign,nonatomic,readonly) CGPathRef     squarePathRef;
@property (strong,nonatomic,readonly) NSBezierPath *diamondPath;
@property (assign,nonatomic,readonly) CGPathRef     diamondPathRef;
@property (strong,nonatomic,readonly) NSBezierPath *pentagonPath;
@property (assign,nonatomic,readonly) CGPathRef     pentagonPathRef;
@property (strong,nonatomic,readonly) NSBezierPath *hexagonPath;
@property (assign,nonatomic,readonly) CGPathRef     hexagonPathRef;
@property (strong,nonatomic,readonly) NSBezierPath *octogonPath;
@property (assign,nonatomic,readonly) CGPathRef     octogonPathRef;



@end

@implementation StatusView

@synthesize properties =        _properties;
@synthesize shape =             _shape;
@synthesize color =             _color;
@synthesize symbol =            _symbol;
@synthesize symbolColor =       _symbolColor;
@synthesize font =              _font;

@synthesize symbolPath =        _symbolPath;
@synthesize symbolPathRef =     _symbolPathRef;
@synthesize circlePath =        _circlePath;
@synthesize circlePathRef =     _circlePathRef;
@synthesize trianglePath =      _trianglePath;
@synthesize trianglePathRef =   _trianglePathRef;
@synthesize roundedSquarePath = _roundedSquarePath;
@synthesize roundedSquarePathRef = _roundedSquarePathRef;
@synthesize squarePath =        _squarePath;
@synthesize squarePathRef =     _squarePathRef;
@synthesize diamondPath =       _diamondPath;
@synthesize diamondPathRef =    _diamondPathRef;
@synthesize pentagonPath =      _pentagonPath;
@synthesize pentagonPathRef =   _pentagonPathRef;
@synthesize hexagonPath =       _hexagonPath;
@synthesize hexagonPathRef =    _hexagonPathRef;
@synthesize octogonPath =       _octogonPath;
@synthesize octogonPathRef =    _octogonPathRef;


#pragma mark -
#pragma mark Initialization Methods

- (instancetype)initWithFrame:(NSRect )rect
{
    self = [super initWithFrame:rect];
    if ( self ) {
        
#if 0
        _circlePathRef = [self.circlePath quartzPath];
        _trianglePathRef = [self.trianglePath quartzPath];
        _squarePathRef = [self.squarePath quartzPath];
        _roundedSquarePathRef = [self.roundedSquarePath quartzPath];
        _diamondPathRef = [self.diamondPath quartzPath];
        _pentagonPathRef = [self.pentagonPath quartzPath];
        _hexagonPathRef = [self.hexagonPath quartzPath];
        _octogonPathRef = [self.octogonPath quartzPath];
#endif
        
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
    
    self.symbolLayer.bounds = layer.bounds;
    self.symbolLayer.position = center;
    self.symbolLayer.path = [self.symbolPath quartzPath];
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
    if ( _shape == nil ) {
        _shape = StatusShapeCircle;
    }
    return _shape;
}

- (void)setShape:(NSString *)shape
{
    if ( shape ) {
        _shape = shape;
    
        if ( [_shape isEqualToString:StatusShapeNone]) {
            self.shapeLayer.hidden = YES;
            [self setNeedsDisplay:YES];
            return ;
        }
        self.shapeLayer.path = self.outlineLayer.path = nil;
        [self setNeedsDisplay:YES];
    }
}

- (void)setShapeWithObject:(id)object
{
    [self setShape:object];
}

- (NSBezierPath *)path
{
    // Append @"Path" to the shape to allow KVC access to the shape paths
    NSBezierPath *newPath;
    @try {
        newPath = [self valueForKey:[self.shape stringByAppendingString:@"Path"]];
    }
    @catch (NSException *exception) {
        newPath = nil;
    }
    @finally {
        return newPath;
    }
}

- (CGPathRef)pathRef
{
    // XXX this is broken. all the XXXPathRef properties are CGPathRefs (structs)
    //     and not NSObject descended objects. That makes them not key value
    //     coding-compliant. 
    CGPathRef ref;
    NSString *key = [self.shape stringByAppendingString:@"PathRef"];
    
    @try {
        ref = (__bridge CGPathRef)([self valueForKey:key]);
        NSLog(@"pathRef for key %@ is %@",key,ref);
    }
    @catch (NSException *exception) {
        NSLog(@"pathRef for %@ exception %@",key,exception);
        ref = nil;
    }
    return ref;
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
    if ( color ) {
        _color = color;
        [self setNeedsDisplay:YES];
    }
}

- (void)setColorWithObject:(id)object
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

- (void)setOutlineWidthWithObject:(id)object
{
    [self setOutlineWidth:[object floatValue]];
}

- (NSString *)symbol
{
    if ( _symbol == nil ) {
        _symbol = @"\u018F"; // Uppercase Schwa
    }
    return _symbol;
}

- (void)setSymbol:(NSString *)symbol
{
    _symbolPath = nil;
    _symbolPathRef = nil;
    self.hideSymbol = (symbol == nil);
    _symbol = symbol;
    [self setNeedsDisplay:YES];
}

- (void)setSymbolWithObject:(id)object
{
    [self setSymbol:object];
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

- (void)setSymbolColorWithObject:(id)object
{
    [self setSymbolColor:[NSColor colorForObject:object]];
}

- (NSFont *)font
{
    if (_font == nil ) {
        _font = [NSFont fontWithName:kDefaultFontName size:self.fontSize];
    }
    return _font;
}

- (void)setFont:(NSFont *)font
{
    if ( font ) {
        _font = font;
        self.symbolLayer.path = nil;
        [self setNeedsDisplay:YES];
    }
}

- (void)setFontWithObject:(id)object
{
    [self setFont:[NSFont fontWithName:object size:self.fontSize]];
}

- (void)setFontSize:(CGFloat)fontSize
{
    _fontSize = fontSize;
    _font = nil;
    self.symbolLayer.path = nil;
    [self setNeedsDisplay:YES];
}

- (void)setFontSizeWithObject:(id)object
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

- (void)setHideShapeWithObject:(id)object
{
    [self setHideShape:StringIsTrue(object)];
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

- (void)setHideOutlineWithObject:(id)object
{
    [self setHideOutline:StringIsTrue(object)];
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

- (void)setHideSymbolWithObject:(id)object
{
    
    [self setHideSymbol:StringIsTrue(object)];
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
        //_shapeLayer.backgroundColor = [[NSColor clearColor] CGColor];
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
        //_outlineLayer.backgroundColor = [[NSColor clearColor] CGColor];
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
        //_symbolLayer.backgroundColor = [[NSColor clearColor] CGColor];
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
    
    if ( self.symbol == nil) {
        _symbolPath = nil;
        _symbolPathRef = nil;
        self.hideSymbol = YES;
        return nil;
    }
    
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

        CGFloat dx = (self.bounds.size.width - _symbolPath.bounds.size.width) / 2.;

        // dy divisor could be 4 for shapes which "sit" on the baseline at MinY
        
        CGFloat dy = (self.bounds.size.height - _symbolPath.bounds.size.height) / 2.;
        
        NSRect sRect = NSInsetRect(self.bounds, dx, dy);
        
        _symbolPath = [NSBezierPath bezierPath];
        [_symbolPath moveToPoint:sRect.origin];
        [_symbolPath appendBezierPathWithGlyph:glyphs[0] inFont:self.font];
        
        free(glyphs);
        

        [self setNeedsDisplay:YES];
    }
    


     return _symbolPath;
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

#pragma mark -
#pragma mark Methods


- (void)updateWithDictionary:(NSDictionary *)info
{
    [info enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        @try {
            [self setValue:obj forKey:[key stringByAppendingString:@"WithObject"]];
        }
        @catch (NSException *exception) {
            NSLog(@"StatusView[%@].updateWithDictionary key=%@ obj=%@ Exception=%@",self,key,obj,exception);
        }
    }];
}





@end
