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

#define StatusViewShapeProperty       @"shape"
#define StatusViewColorProperty       @"color"
#define StatusViewSymbolProperty      @"symbol"
#define StatusViewSymbolColorProperty @"symbolColor"
#define StatusViewMessageProperty     @"message"
#define StatusViewOutlineProperty     @"outline"


@interface StatusView : NSView

@property (strong, nonatomic) NSString *shape;
@property (strong, nonatomic,readonly) NSBezierPath *path;

@property (strong, nonatomic) NSFont   *font;
@property (strong, nonatomic) NSColor  *color;
@property (strong, nonatomic) NSString *symbol;
@property (strong, nonatomic) NSColor  *symbolColor;

@property (assign, nonatomic,getter=outlineIsHidden) BOOL outlineHidden;
@property (assign, nonatomic,getter=shapeIsHidden) BOOL shapeHidden;
@property (assign, nonatomic,getter=symbolIsHidden) BOOL symbolHidden;
@property (assign, nonatomic) CGFloat outlineWidth;
@property (assign, nonatomic) CGFloat fontSize;





@end
