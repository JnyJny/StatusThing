//
//  StatusView.h
//  StatusThing
//
//  Created by Erik on 4/18/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define StatusShapeNone            @"none"
#define StatusShapeCircle          @"circle"
#define StatusShapeSquare          @"square"
#define StatusShapeRoundedSquare   @"roundedsquare"
#define StatusShapeDiamond         @"diamond"
#define StatusShapeTriangle        @"triangle"
#define StatusShapePentagon        @"pentagon"
#define StatusShapeHexagon         @"hexagon"
#define StatusShapeOctogon         @"octogon"

#define StatusViewShapeProperty   @"shape"
#define StatusViewColorProperty   @"color"
#define StatusViewSymbolProperty  @"symbol"
#define StatusViewMessageProperty @"message"


@interface StatusView : NSView

@property (strong, nonatomic) NSString *shape;
@property (strong, nonatomic,readonly) NSBezierPath *path;

@property (strong, nonatomic) NSString *fontName;
@property (strong, nonatomic) NSString *colorName;
@property (strong, nonatomic) NSString *symbol;
@property (strong, nonatomic) NSString *symbolColorName;

@property (assign, nonatomic,getter=hasOutline) BOOL outline;
@property (assign, nonatomic) CGFloat outlineWidth;
@property (assign, nonatomic) CGFloat fontSize;





@end
