//
//  FilterFactory.h
//  StatusThing
//
//  Created by Erik on 5/7/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface FilterFactory : NSObject

@property (strong,nonatomic,readonly) NSDictionary *filters;

- (BOOL)hasFilterNamed:(NSString *)name;
- (CIFilter *)filterForLayer:(CALayer *)layer named:(NSString *)name;
@end
