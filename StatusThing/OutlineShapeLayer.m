//
//  OutlineShapeLayer.m
//  StatusThing
//
//  Created by Erik on 4/19/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

@import AppKit;
#import "OutlineShapeLayer.h"
#import "Konstants.h"


@implementation OutlineShapeLayer

- (instancetype)init
{
    self = [super init];
    if ( self ) {
        self.name = OutlineShapeLayerName;
        self.fillColor = nil;
        self.backgroundColor = nil;
        self.lineWidth = 1.0;
        _dark = [[NSColor whiteColor] CGColor];
        _light  = [[NSColor blackColor] CGColor];
    }
    return self;
}

- (CGColorRef)strokeColor
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *appleInterfaceStyle = [userDefaults stringForKey:kAppleInterfaceStyle];
    
    return [[appleInterfaceStyle lowercaseString] isEqualToString:@"dark"] ? _dark : _light;
}
@end
