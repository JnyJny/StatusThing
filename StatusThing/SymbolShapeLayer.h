//
//  SymbolShapeLayer.h
//  StatusThing
//
//  Created by Erik on 4/19/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CALayer+LayoutUtilties.h"

#define SymbolShapeLayerName @"SymbolShapeLayer"

@interface SymbolShapeLayer : CATextLayer;

- (void)updateWithDictionary:(NSDictionary *)info;

@end
