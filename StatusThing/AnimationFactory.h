//
//  AnimationFactory.h
//  StatusThing
//
//  Created by Erik on 5/1/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

extern NSString *AnimationNameSpin;
extern NSString *AnimationNameThrob;
extern NSString *AnimationNameBounce;
extern NSString *AnimationNameShake;
extern NSString *AnimationNameFlip;
extern NSString *AnimationNameWobble;
extern NSString *AnimationNameFade;
extern NSString *AnimationNameFlare;
extern NSString *AnimationNameShine;
extern NSString *AnimationNameTwinkle;
extern NSString *AnimationNameShimmy;

@interface AnimationFactory : NSObject


- (CAAnimationGroup *)animationGroupForLayer:(CALayer *)layer withKeyPath:(NSString *)keyPath usingDictionary:(NSDictionary *)info;
- (CABasicAnimation *)animationForLayer:(CALayer *)layer  withKeyPath:(NSString *)keyPath usingDictionary:(NSDictionary *)info;

@end
