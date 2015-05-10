//
//  FilterFactory.m
//  StatusThing
//
//  Created by Erik on 5/7/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "FilterFactory.h"
#import <QuartzCore/QuartzCore.h>

@implementation FilterFactory


- (NSDictionary *)filters
{
    if (!_filters) {
        _filters = @{};
    }
    return _filters;
}


- (CIFilter *)filterNamed:(NSString *)name
{
    
    return nil;
}

@end
