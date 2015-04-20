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

#define StatusViewShapeProperty       @"shape"
#define StatusViewColorProperty       @"color"
#define StatusViewSymbolProperty      @"symbol"
#define StatusViewSymbolColorProperty @"symbolColor"
#define StatusViewMessageProperty     @"message"
#define StatusViewOutlineProperty     @"outline"


@interface StatusView : NSView

@property (strong, nonatomic) NSString *shape;

@property (strong, nonatomic) NSFont   *font;
@property (strong, nonatomic) NSColor  *color;
@property (strong, nonatomic) NSString *symbol;
@property (strong, nonatomic) NSColor  *symbolColor;

@property (assign, nonatomic,getter=outlineIsHidden) BOOL outlineHidden;
@property (assign, nonatomic,getter=shapeIsHidden) BOOL shapeHidden;
@property (assign, nonatomic,getter=symbolIsHidden) BOOL symbolHidden;
@property (assign, nonatomic) CGFloat outlineWidth;
@property (assign, nonatomic) CGFloat fontSize;


- (void)updateWithDictionary:(NSDictionary *)info;


@end
