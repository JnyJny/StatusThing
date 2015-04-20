//
//  SymbolShapeLayer.m
//  StatusThing
//
//  Created by Erik on 4/19/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

@import AppKit;
#import "SymbolShapeLayer.h"

@implementation SymbolShapeLayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = SymbolShapeLayerName;
        self.backgroundColor = nil;
        self.foregroundColor = [[NSColor blackColor] CGColor];
        self.alignmentMode = kCAAlignmentCenter;
        self.string = @"\u018F";
        self.font = CFBridgingRetain(@"Courier");
        self.fontSize = CGRectGetHeight(self.bounds) - 8.;
    }
    return self;
}


@end
