//
//  StatusImage.m
//  StatusThing
//
//  Created by Erik on 4/16/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "StatusImage.h"
#import "Konstants.h"

@interface StatusImage()

@property (assign,nonatomic,getter=isDark,readonly) BOOL dark;
@property (assign,nonatomic,readonly) NSRect rect;

@property (strong,nonatomic,readonly) NSBezierPath *circlePath;
@property (strong,nonatomic,readonly) NSBezierPath *trianglePath;
@property (strong,nonatomic,readonly) NSBezierPath *roundedSquarePath;
@property (strong,nonatomic,readonly) NSBezierPath *squarePath;
@property (strong,nonatomic,readonly) NSBezierPath *diamondPath;
@property (strong,nonatomic,readonly) NSBezierPath *pentagonPath;
@property (strong,nonatomic,readonly) NSBezierPath *hexagonPath;
@property (strong,nonatomic,readonly) NSBezierPath *octogonPath;


@end

@implementation StatusImage

@synthesize circlePath = _circlePath;
@synthesize trianglePath = _trianglePath;
@synthesize roundedSquarePath = _roundedSquarePath;
@synthesize squarePath = _squarePath;
@synthesize diamondPath = _diamondPath;
@synthesize pentagonPath = _pentagonPath;
@synthesize hexagonPath = _hexagonPath;
@synthesize octogonPath = _octogonPath;

- (instancetype)initWithSize:(NSSize)aSize
{
    self = [super initWithSize:aSize];
    if ( self != nil ) {
        _rect.origin = NSMakePoint(0, 0);
        _rect.size = self.size;
        self.outline = YES;
        self.delegate = self;
    
    }
    
    return self;
}



- (void)bulkUpdate:(NSDictionary *)info
{
    [info enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
       
        if ([key isEqualToString:StatusImageShapeProperty]) {
            self.shape = obj;
        }
        
        if ([key isEqualToString:StatusImageColorProperty]) {
            
            if ( [obj isKindOfClass:[NSString class]]) {
                self.fillColor = [self colorForString:obj];
            }
            
            if ( [obj isKindOfClass:[NSDictionary class]]) {
                self.fillColor = [self colorForDictionary:obj];
            }
        }
        
        if ([key isEqualToString:StatusImageGlyphProperty]) {
            NSLog(@"StatusImage:glyph = %@",obj);
        }
        
    }];
}

#pragma mark -
#pragma mark Public Properties

- (NSString *)shape
{
    if ( _shape == nil ) {
        _shape = StatusShapeCircle;
    }
    return _shape;
}

- (NSBezierPath *)path
{
    if ( [self.shape isEqualToString:StatusShapeCircle] )
        return self.circlePath;
    
    if ( [self.shape isEqualToString:StatusShapeTriangle])
        return self.trianglePath;
    
    if ([self.shape isEqualToString:StatusShapeSquare])
        return self.squarePath;

    
    if ([self.shape isEqualToString:StatusShapeRoundedSquare])
        return self.roundedSquarePath;
    
    if ( [self.shape isEqualToString:StatusShapeDiamond])
        return self.diamondPath;

    if ( [self.shape isEqualToString:StatusShapePentagon])
        return self.pentagonPath;
    
    if ( [self.shape isEqualToString:StatusShapeHexagon])
        return self.hexagonPath;
    
    if ( [self.shape isEqualToString:StatusShapeOctogon])
        return self.octogonPath;

    return nil;
}


- (NSColor *)fillColor
{
    if ( _fillColor == nil ) {
        _fillColor = [NSColor redColor];
    }
    return _fillColor;
}



- (NSFont *)font
{
    if ( _font == nil ) {
        _font = [NSFont menuBarFontOfSize:0];
    }
    return _font;
}

#pragma mark -
#pragma mark Private Properties
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
    
    for ( NSColorList *colorList in [NSColorList availableColorLists] ) {
        // NSLog(@"colorList = %@",colorList.allKeys);
        color = [colorList colorWithKey:[colorString capitalizedString]];
        if (color != nil ) {
            return color;
        }
    }

    return color;
}

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
    
    red = (red>1.0)?red/255.f:red;
    green = (green>1.0)?green/255.f:green;
    blue = (blue>1.0)?blue/255.f:blue;
    alpha = (alpha>1.0)?alpha/255.f:alpha;
    
    return [NSColor colorWithRed:red green:green blue:blue alpha:alpha];
    
}

#pragma mark -
#pragma mark Path Properties

- (NSBezierPath *) circlePath
{
    if (_circlePath == nil) {
        NSRect rect = [self insetRect:self.rect byPercentage:0.2];
        _circlePath = [NSBezierPath bezierPathWithOvalInRect:rect];
        _circlePath.lineWidth = 1.5;
    }
    return _circlePath;
}

- (NSBezierPath *) trianglePath
{
    if ( _trianglePath == nil ) {
        NSRect rect = [self insetRect:self.rect byPercentage:0.15];
        NSPoint v[3] =  { NSMakePoint(CGRectGetMinX(rect),CGRectGetMinY(rect)),
                          NSMakePoint(CGRectGetMaxX(rect),CGRectGetMinY(rect)),
                          NSMakePoint(CGRectGetMidX(rect),CGRectGetMaxY(rect)) };

        _trianglePath = [NSBezierPath bezierPath];
        [_trianglePath appendBezierPathWithPoints:v count:3];
        [_trianglePath closePath];
        _trianglePath.lineWidth = 1.5;
    }
    return _trianglePath;
}

- (NSBezierPath *)roundedSquarePath
{
    if (_roundedSquarePath == nil ) {
        NSRect rect = [self insetRect:self.rect byPercentage:0.2];
        _roundedSquarePath = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:4 yRadius:4];
        _roundedSquarePath.lineWidth = 1.5;
    }
    return _roundedSquarePath;
}

- (NSBezierPath *)squarePath
{
    if ( _squarePath == nil ) {
        NSRect rect = [self insetRect:self.rect byPercentage:0.2];
        _squarePath = [NSBezierPath bezierPathWithRect:rect];
        _squarePath.lineWidth = 1.5;
    }
    return _squarePath;
}

- (NSBezierPath *)diamondPath
{
    if ( _diamondPath == nil ) {
        NSRect rect = [self insetRect:self.rect byPercentage:0.2];
        NSPoint v[4] = { NSMakePoint(CGRectGetMidX(rect),CGRectGetMinY(rect)),
            NSMakePoint(CGRectGetMaxX(rect),CGRectGetMidY(rect)),
            NSMakePoint(CGRectGetMidX(rect),CGRectGetMaxY(rect)),
            NSMakePoint(CGRectGetMinX(rect),CGRectGetMidY(rect)) };

        _diamondPath = [NSBezierPath bezierPath];
        [_diamondPath appendBezierPathWithPoints:v count:4];
        [_diamondPath closePath];
        _diamondPath.lineWidth = 1.5;
    }
    return _diamondPath;
}

- (NSBezierPath *)pentagonPath
{
    if (_pentagonPath == nil) {
        NSRect rect = [self insetRect:self.rect byPercentage:0.2];
        CGFloat dx = rect.size.width / 4;
        NSPoint v[5] = { NSMakePoint(CGRectGetMinX(rect) + dx,CGRectGetMinY(rect)),
            NSMakePoint(CGRectGetMaxX(rect) - dx,CGRectGetMinY(rect)),
            NSMakePoint(CGRectGetMaxX(rect),CGRectGetMidY(rect)),
            NSMakePoint(CGRectGetMidX(rect),CGRectGetMaxY(rect)),
            NSMakePoint(CGRectGetMinX(rect),CGRectGetMidY(rect)) };
        
        _pentagonPath = [NSBezierPath bezierPath];
        [_pentagonPath appendBezierPathWithPoints:v count:5];
        [_pentagonPath closePath];
        _pentagonPath.lineWidth = 1.5;
    }
    return _pentagonPath;
}

- (NSBezierPath *)hexagonPath
{
    if (_hexagonPath == nil) {
        NSRect rect = [self insetRect:self.rect byPercentage:0.15];
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
        _hexagonPath.lineWidth = 1.5;
    }
    return _hexagonPath;
}

- (NSBezierPath *)octogonPath
{
    if (_octogonPath == nil) {
        NSRect rect = [self insetRect:self.rect byPercentage:0.15];
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
        _octogonPath.lineWidth = 1.5;
    }
    return _octogonPath;
}

#pragma mark -
#pragma mark <NSImageDelegate> Method

- (NSImage *)imageDidNotDraw:(id)sender inRect:(NSRect)aRect
{
    
    if ( self.path == nil )
        return nil;

    [self.fillColor setFill];
    [self.path fill];
    
    if (self.hasOutline) {
        
        [self.isDark?[NSColor whiteColor]:[NSColor blackColor] setStroke];
        [self.path stroke];
    }
    
    return nil;
}

@end
