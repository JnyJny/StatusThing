//
//  SymbolShapeLayer.m
//  StatusThing
//
//  Created by Erik on 4/19/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "SymbolShapeLayer.h"

@implementation SymbolShapeLayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.fontSize = 12;
        self.name = SymbolShapeLayerName;
        self.backgroundColor = nil;
        self.foregroundColor = CGColorCreateGenericRGB(0, 0, 0, 1);
        self.alignmentMode = kCAAlignmentCenter;
        self.string = @"\u018F";
        self.font = CFBridgingRetain(@"Courier");
    }
    return self;
}

@end
