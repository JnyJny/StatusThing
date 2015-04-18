//
//  StatusView.m
//  StatusThing
//
//  Created by Erik on 4/18/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "StatusView.h"
#import "Konstants.h"

@interface StatusView()

@property (assign,nonatomic,getter=isDark,readonly) BOOL dark;

@property (strong,nonatomic,readonly) NSColor *color;
@property (strong,nonatomic,readonly) NSFont  *font;
@property (strong,nonatomic,readonly) NSColor *symbolColor;

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

@synthesize colorName =         _colorName;
@synthesize color =             _color;
@synthesize fontName =          _fontName;
@synthesize font =              _font;
@synthesize symbolColorName =   _symbolColorName;
@synthesize symbolColor =       _symbolColor;


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
#pragma mark Drawing Method

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    [self.color setFill];
    [self.path fill];

    
    if (self.hasOutline) {
        [self.isDark?[NSColor whiteColor]:[NSColor blackColor] setStroke];
        [self.path stroke];
    }
    
    if ( self.symbolPath ) {
        [self.symbolColor setFill];
        [self.symbolPath fill];
    }
    
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

- (NSBezierPath *)path
{
    // Append @"Path" to the shape to allow KVC access to the shape paths
    NSBezierPath *path = [self valueForKey:[self.shape stringByAppendingString:@"Path"]];
    
    path.lineWidth = self.outlineWidth;
    
    // if glyphPath [path append:glyphPath]
    
    return path;
}

- (NSString *)colorName
{
    if ( _colorName == nil ) {
        _colorName = @"Green";
    }
    return _colorName;
}

- (void)setColorName:(NSString *)colorName
{
    if ( colorName) {
        _colorName = colorName;
        _color = [self colorForString:_colorName];
    }
}

- (NSColor *)color
{
    if ( _color == nil ) {
        _color = [self colorForString:self.colorName];
    }
    return _color;
}



- (NSString *)symbolColorName
{
    if ( _symbolColorName == nil ) {
        _symbolColorName = @"Red";
    }
    return _symbolColorName;
}

- (void)setSymbolColorName:(NSString *)glyphColorName
{
    _symbolColorName = glyphColorName;
    _symbolColor = [self colorForString:_symbolColorName];
}

- (NSColor *)symbolColor
{
    if ( _symbolColor == nil ) {
        _symbolColor = [self colorForString:self.symbolColorName];
    }
    return _symbolColor;
}


#define kDefaultFontName @"Apple Symbols"
- (NSString *)fontName
{
    if ( _fontName == nil ) {
        _fontName = kDefaultFontName;
    }
    return _fontName;
}

- (void)setFontName:(NSString *)fontName
{
    _fontName = fontName;
    _font = [NSFont fontWithName:_fontName size:self.fontSize];
}

- (void)setFontSize:(CGFloat)fontSize
{
    _fontSize = fontSize;
    _font = [NSFont fontWithName:self.fontName size:_fontSize];
}

- (NSFont *)font
{
    if (_font == nil ) {
        _font = [NSFont fontWithName:self.fontName size:self.fontSize];
    }
    return _font;
}


#pragma mark -
#pragma mark Expensive Properties

- (BOOL)isDark
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *appleInterfaceStyle = [userDefaults stringForKey:kAppleInterfaceStyle];
    
    return [[appleInterfaceStyle lowercaseString] isEqualToString:@"dark"];
}


#pragma mark -
#pragma mark Private Methods

- (NSRect)insetRect:(NSRect)srcRect byPercentage:(CGFloat) percentage
{
    CGFloat dx = srcRect.size.width * percentage;
    CGFloat dy = srcRect.size.height * percentage;
    
    return NSIntegralRect(NSInsetRect(srcRect, dx, dy));
}

- (NSColor *)colorForString:(NSString *)colorString
{
    NSColor *color = nil;
    
    // XXX not especially performant, but it does find a variety of colors by name
    
    for ( NSColorList *colorList in [NSColorList availableColorLists] ) {
        // NSLog(@"colorList = %@",colorList.allKeys);
        color = [colorList colorWithKey:[colorString capitalizedString]];
        if (color != nil ) {
            return color;
        }
    }
    
    return color;
}

#define NegativeToZero(V) ((V)<0)?0.0:(V)
#define ScaleFrom255(V)  ((V)>1.0)?(V)/255.f:(V)
#define Scale(V) ScaleFrom255(NegativeToZero((V)))

- (NSColor *)colorForDictionary:(NSDictionary *)info
{
    // info may have red, blue, green, alpha key/values  empty dictionary is black
    
    CGFloat red = 0;
    CGFloat green = 0;
    CGFloat blue = 0;
    CGFloat alpha = 1.0;
    
    red = [[info valueForKey:@"red"] floatValue];
    green = [[info valueForKey:@"green"] floatValue];
    blue = [[info valueForKey:@"blue"] floatValue];
    alpha = [[info valueForKey:@"alpha"] floatValue];

    return [NSColor colorWithRed:Scale(red) green:Scale(green) blue:Scale(blue) alpha:Scale(alpha)];
    
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

        CGFloat dx = (self.bounds.size.width - _symbolPath.bounds.size.width) / 2.;

        // dy divisor could be 4 for shapes which "sit" on the baseline at MinY
        
        CGFloat dy = (self.bounds.size.height - _symbolPath.bounds.size.height) / 2.;
        
        NSRect sRect = NSInsetRect(self.bounds, dx, dy);
        
        _symbolPath = [NSBezierPath bezierPath];
        [_symbolPath moveToPoint:sRect.origin];
        [_symbolPath appendBezierPathWithGlyph:glyphs[0] inFont:self.font];
        
        free(glyphs);
        
    }
    
    if ( self.symbol == nil) {
        _symbolPath = nil;
    }
    
     return _symbolPath;
}



#pragma mark -
#pragma mark Methods





@end
