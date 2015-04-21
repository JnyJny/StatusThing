//
//  StatusView.h
//  StatusThing
//
//  Created by Erik on 4/18/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PolyShapeLayer.h"
#import "SymbolShapeLayer.h"
 


@interface StatusView : NSView


@property (strong,nonatomic,readonly) PolyShapeLayer   *shape;
@property (strong,nonatomic,readonly) PolyShapeLayer   *outline;
@property (strong,nonatomic,readonly) SymbolShapeLayer *symbol;

- (void)centerInRect:(CGRect)rect;
- (void)updateKeyPathsWithDictionary:(NSDictionary *)info;

@end
