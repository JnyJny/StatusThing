//
//  AnimationFactory.m
//  StatusThing
//
//  Created by Erik on 5/1/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "AnimationFactory.h"


const NSString *AnimationNameSpin    = @"spin";
const NSString *AnimationNameThrob   = @"throb";
const NSString *AnimationNameBounce  = @"bounce";
const NSString *AnimationNameShake   = @"shake";
const NSString *AnimationNameFlip    = @"flip";
const NSString *AnimationNameWobble  = @"wobble";
const NSString *AnimationNameFade    = @"fade";
const NSString *AnimationNameFlare   = @"flare";
const NSString *AnimationNameShine   = @"shine";
const NSString *AnimationNameTwinkle = @"twinkle";
const NSString *AnimationNameShimmy  = @"shimmy";

@implementation AnimationFactory

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}


- (CAAnimationGroup *)animationGroupForLayer:(CALayer *)layer withKeyPath:(NSString *)keyPath usingDictionary:(NSDictionary *)info
{
    if(!info) {
        return nil;
    }
    
    CAAnimationGroup *theGroup = [[CAAnimationGroup alloc] init];
    
    
    return theGroup;
}


- (CABasicAnimation *)animationForLayer:(CALayer *)layer  withKeyPath:(NSString *)keyPath usingDictionary:(NSDictionary *)info
{
    if (!info) {
        return nil;
    }
    
    CABasicAnimation *theAnimation = [[CABasicAnimation alloc] init];
    
    
    return theAnimation;
}


@end
