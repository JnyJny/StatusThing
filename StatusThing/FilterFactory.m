//
//  FilterFactory.m
//  StatusThing
//
//  Created by Erik on 5/7/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "FilterFactory.h"


@implementation FilterFactory

@synthesize filters = _filters;

// XXX filter names shouldn't collide with animation or shape names
//     bad things will happen.

// NSString *const FilterName = @"";

- (NSDictionary *)filters
{
    if (!_filters) {
        _filters = @{};
    }
    return _filters;
}

- (BOOL)hasFilterNamed:(NSString *)name
{
    NSDictionary *info = nil;
    @try {
        info = self.filters[name.lowercaseString];
    }
    @catch (NSException *exception) {
        NSLog(@"hasFilterNamed:%@ exception %@",name,exception);
    }
    
    return !(info==nil);
}

- (CIFilter *)filterForLayer:(CALayer *)layer named:(NSString *)name
{
    
    NSDictionary *info = self.filters[name.lowercaseString];
    
    if (!info) {
        NSLog(@"filterForLayer:%@ named:%@ no filter found",layer.name,name);
        return nil;
    }
    
    return nil;
}

@end
