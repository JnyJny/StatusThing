//
//  StatusImage.h
//  StatusThing
//
//  Created by Erik on 4/16/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

@import AppKit;

#define StatusShapeCircle          @"circle"
#define StatusShapeSquare          @"square"
#define StatusShapeRoundedSquare   @"roundedsquare"
#define StatusShapeDiamond         @"diamond"
#define StatusShapeTriangle        @"triangle"
#define StatusShapePentagon        @"pentagon"
#define StatusShapeHexagon         @"hexagon"
#define StatusShapeOctogon         @"octogon"

#define StatusImageShapeProperty   @"shape"
#define StatusImageColorProperty   @"color"
#define StatusImageGlyphProperty   @"glyph"

@interface StatusImage : NSImage <NSImageDelegate>

@property (strong, nonatomic) NSString *shape;
@property (strong, nonatomic,readonly) NSBezierPath *path;
@property (strong, nonatomic) NSFont *font;
@property (assign, nonatomic) NSGlyph glyph;
@property (strong, nonatomic) NSColor *fillColor;
@property (strong, nonatomic) NSColor *glyphColor;

@property (assign, nonatomic,getter=hasOutline) BOOL outline;

- (void)bulkUpdate:(NSDictionary *)info;




@end
