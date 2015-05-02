//
//  AnimationFactory.m
//  StatusThing
//
//  Created by Erik on 5/1/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "AnimationFactory.h"
#import "BlockUtilities.h"

#pragma mark - Constants

NSString * const AnimationNameSpin    = @"spin";
NSString * const AnimationNameThrob   = @"throb";
NSString * const AnimationNameBounce  = @"bounce";
NSString * const AnimationNameShake   = @"shake";
NSString * const AnimationNameFlip    = @"flip";
NSString * const AnimationNameWobble  = @"wobble";
NSString * const AnimationNameFade    = @"fade";
NSString * const AnimationNameFlare   = @"flare";
NSString * const AnimationNameShine   = @"shine";
NSString * const AnimationNameTwinkle = @"twinkle";
NSString * const AnimationNameShimmy  = @"shimmy";


@interface AnimationFactory ()

@property (copy,nonatomic) DictionaryEnumBlock configureAnimationBlock;
@property (copy,nonatomic) DictionaryEnumBlock configureAnimationGroupBlock;

@end


@implementation AnimationFactory

#pragma mark - LifeCycle
- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

#pragma mark - Public Methods

- (CAAnimationGroup *)animationGroupForLayer:(CALayer *)layer withKeyPath:(NSString *)keyPath usingDictionary:(NSDictionary *)info
{
    if(!info) {
        return nil;
    }
    
    __block CAAnimationGroup *theGroup = [[CAAnimationGroup alloc] init];
    
    
    return theGroup;
}


- (CABasicAnimation *)animationForLayer:(CALayer *)layer  withKeyPath:(NSString *)keyPath usingDictionary:(NSDictionary *)info
{
    if (!info) {
        return nil;
    }
    
    __block CABasicAnimation *theAnimation = [[CABasicAnimation alloc] init];
    
    
    return theAnimation;
}


@end
