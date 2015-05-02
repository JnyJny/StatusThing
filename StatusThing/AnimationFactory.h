//
//  AnimationFactory.h
//  StatusThing
//
//  Created by Erik on 5/1/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>


extern NSString * const AnimationNameSpin;
extern NSString * const AnimationNameThrob;
extern NSString * const AnimationNameBounce;
extern NSString * const AnimationNameShake;
extern NSString * const AnimationNameFlip;
extern NSString * const AnimationNameWobble;
extern NSString * const AnimationNameFade;
extern NSString * const AnimationNameFlare;
extern NSString * const AnimationNameShine;
extern NSString * const AnimationNameTwinkle;
extern NSString * const AnimationNameShimmy;

@interface AnimationFactory : NSObject


- (CAAnimationGroup *)animationGroupForLayer:(CALayer *)layer withKeyPath:(NSString *)keyPath usingDictionary:(NSDictionary *)info;
- (CABasicAnimation *)animationForLayer:(CALayer *)layer  withKeyPath:(NSString *)keyPath usingDictionary:(NSDictionary *)info;

@end
