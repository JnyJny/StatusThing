//
//  AnimationFactory.m
//  StatusThing
//
//  Created by Erik on 5/1/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "AnimationFactory.h"
#import "BlockUtilities.h"
#import "Geometry.h"

#pragma mark - Constants

NSString * const AnimationNameSpin    = @"spin";
NSString * const AnimationNameSpinCW  = @"spincw";
NSString * const AnimationNameSpinCCW = @"spinccw";
NSString * const AnimationNameThrob   = @"throb";
NSString * const AnimationNameBounce  = @"bounce";
NSString * const AnimationNameShake   = @"shake";
NSString * const AnimationNameFlip    = @"flip";
NSString * const AnimationNameWobble  = @"wobble";
NSString * const AnimationNameFadeIn  = @"fadein";
NSString * const AnimationNameFadeOut = @"fadeout";
NSString * const AnimationNameFlare   = @"flare";
NSString * const AnimationNameShine   = @"shine";
NSString * const AnimationNameTwinkle = @"twinkle";
NSString * const AnimationNameShimmy  = @"shimmy";
NSString * const AnimationNameStrobe  = @"strobe";
NSString * const AnimationNameBlink   = @"blink";



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


- (NSDictionary *)animations
{
    if (!_animations) {
        _animations = @{ AnimationNameSpin : @{},
                         AnimationNameSpinCW : @{},
                         AnimationNameSpinCCW : @{},
                         AnimationNameThrob : @{},
                         AnimationNameBounce : @{},
                         AnimationNameShake : @{},
                         AnimationNameFlare : @{},
                         AnimationNameFlip : @{},
                         AnimationNameWobble : @{},
                         AnimationNameFadeIn : @{},
                         AnimationNameFadeOut : @{},
                         AnimationNameShine : @{},
                         AnimationNameTwinkle : @{},
                         AnimationNameShimmy : @{},
                         AnimationNameBlink : @{},
                        };
    }
    return _animations;
}



#pragma mark - Public Methods

- (BOOL)hasAnimationNamed:(NSString *)animationName
{
    return self.animations[animationName] != nil;
    
}

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

- (CABasicAnimation *)animationForLayer:(CALayer *)layer withName:(NSString *)animationName
{

    if ( [animationName isEqualToString:AnimationNameSpinCCW]) {
        CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        NSNumber *startRotation = [layer valueForKeyPath:@"transform.rotation"];
        CATransform3D rotationTransform = CATransform3DRotate(layer.transform, M_2PI, 0, 0, 1);
        layer.transform = rotationTransform;
        spin.repeatCount = HUGE_VALF;
        spin.duration = 1.0;
        spin.fromValue = @0;
        spin.toValue = [NSNumber numberWithFloat:startRotation.floatValue + M_2PI];
        return spin;
    }
    
    
    if ( [animationName isEqualToString:AnimationNameSpinCW] ||
        [animationName isEqualToString:AnimationNameSpin] ) {
        CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        NSNumber *startRotation = [layer valueForKeyPath:@"transform.rotation"];
        CATransform3D rotationTransform = CATransform3DRotate(layer.transform, M_2PI, 0, 0, 1);
        layer.transform = rotationTransform;
        spin.repeatCount = HUGE_VALF;
        spin.duration = 1.0;
        spin.byValue = @-1;
        spin.fromValue =[NSNumber numberWithFloat:startRotation.floatValue + M_2PI];
        spin.toValue = @0;
        return spin;
    }
    
    if ( [animationName isEqualToString:AnimationNameThrob]) {
        CABasicAnimation *throb = [CABasicAnimation animationWithKeyPath:@"opacity"];
        throb.fromValue = @1;
        throb.toValue = @0;
        throb.autoreverses = YES;
        throb.duration = 0.5;
        throb.repeatCount = HUGE_VALF;
        return throb;
    }
    
    if ( [animationName isEqualToString:AnimationNameBlink]) {
        CABasicAnimation *blink = [CABasicAnimation animationWithKeyPath:@"hidden"];
        blink.fromValue = @YES;
        blink.toValue = @NO;
        blink.duration = 0.5;
        blink.repeatCount = HUGE_VALF;
        return blink;
    }
    
    return nil;
}


- (void)rotateLayer:(CALayer *)layer
{
    
    NSNumber *rotationAtStart = [layer valueForKeyPath:@"transform.rotation"];
    
    CATransform3D myRotationTransform = CATransform3DRotate(layer.transform, M_2PI, 0.0, 0.0, 1.0);
    
    layer.transform = myRotationTransform;
    
    CABasicAnimation *myAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    myAnimation.repeatCount = HUGE_VALF;
    myAnimation.duration = 0.5;
    myAnimation.fromValue = 0;
    myAnimation.toValue = [NSNumber numberWithFloat:([rotationAtStart floatValue] + M_2PI)];
    [layer addAnimation:myAnimation forKey:@"transform.rotation"];
}


@end
