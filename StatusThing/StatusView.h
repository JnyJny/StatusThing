//
//  StatusView.h
//  StatusThing
//
//  Created by Erik on 4/18/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "StatusShapeLayer.h"
#import "OutlineShapeLayer.h"
#import "SymbolShapeLayer.h" 

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

@property (strong, nonatomic) NSString *shape;

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
