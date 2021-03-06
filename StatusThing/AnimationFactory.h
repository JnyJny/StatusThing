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
extern NSString * const AnimationNameSpinCW;
extern NSString * const AnimationNameSpinCCW;
extern NSString * const AnimationNameThrob;
extern NSString * const AnimationNameBounce;
extern NSString * const AnimationNameShake;
extern NSString * const AnimationNameFlip;
extern NSString * const AnimationNameFlipY;
extern NSString * const AnimationNameFlipX;
extern NSString * const AnimationNameWobble;
extern NSString * const AnimationNameBlink;
extern NSString * const AnimationNameEnbiggen;
extern NSString * const AnimationNameStretch;
extern NSString * const AnimationNameStretchX;
extern NSString * const AnimationNameStretchY;
extern NSString * const AnimationNameWink;
extern NSString * const AnimationNameWinkX;
extern NSString * const AnimationNameWinkY;
extern NSString * const AnimationNameTickerLR;
extern NSString * const AnimationNameTickerRL;

@interface AnimationFactory : NSObject

@property (strong,nonatomic) NSDictionary *animations;

- (BOOL)hasAnimationNamed:(NSString *)animationName;

- (CABasicAnimation *)animationForLayer:(CALayer *)layer withName:(NSString *)name;

- (CABasicAnimation *)animationForLayer:(CALayer *)layer withName:(NSString *)name andDuration:(CGFloat)duration;
@end
