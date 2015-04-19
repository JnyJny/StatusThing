//
//  StatusView.h
//  StatusThing
//
//  Created by Erik on 4/18/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import <Cocoa/Cocoa.h>


#define StatusShapeNone           @"none"
#define StatusShapeCircle         @"circle"
#define StatusShapeSquare         @"square"
#define StatusShapeRoundedSquare  @"roundedSquare"
#define StatusShapeDiamond        @"diamond"
#define StatusShapeTriangle       @"triangle"
#define StatusShapePentagon       @"pentagon"
#define StatusShapeHexagon        @"hexagon"
#define StatusShapeOctogon        @"octogon"

#define StatusViewShapeProperty        @"shape"
#define StatusViewHideShapeProperty    @"hideShape"
#define StatusViewColorProperty        @"color"
#define StatusViewHideOutlineProperty  @"hideOutline"
#define StatusViewOutlineWidthProperty @"outlineWidth"
#define StatusViewSymbolProperty       @"symbol"
#define StatusViewSymbolColorProperty  @"symbolColor"
#define StatusViewHideSymbolProperty   @"hideSymbol"
#define StatusViewFontProperty         @"font"
#define StatusViewFontSizeProperty     @"fontSize"


@interface StatusView : NSView

@property (strong, nonatomic, readonly) NSArray *properties;

@property (strong, nonatomic) NSString *shape;
@property (strong, nonatomic) NSFont   *font;
@property (strong, nonatomic) NSColor  *color;
@property (strong, nonatomic) NSString *symbol;
@property (strong, nonatomic) NSColor  *symbolColor;
@property (assign, nonatomic) CGFloat outlineWidth;
@property (assign, nonatomic) CGFloat fontSize;

@property (assign, nonatomic,getter=shapeIsHidden) BOOL hideShape;
@property (assign, nonatomic,getter=outlineIsHidden) BOOL hideOutline;
@property (assign, nonatomic,getter=symbolIsHidden) BOOL hideSymbol;

- (void)updateWithDictionary:(NSDictionary *)info;



@end
