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

NSString * const AnimationNameSpin     = @"spin";
NSString * const AnimationNameSpinCW   = @"spincw";
NSString * const AnimationNameSpinCCW  = @"spinccw";
NSString * const AnimationNameThrob    = @"throb";
NSString * const AnimationNameBounce   = @"bounce";
NSString * const AnimationNameShake    = @"shake";
NSString * const AnimationNameFlip     = @"flip";
NSString * const AnimationNameFlipY    = @"flipy";
NSString * const AnimationNameFlipX    = @"flipx";
NSString * const AnimationNameWobble   = @"wobble";
NSString * const AnimationNameFlare    = @"flare";
NSString * const AnimationNameShine    = @"shine";
NSString * const AnimationNameTwinkle  = @"twinkle";
NSString * const AnimationNameBlink    = @"blink";
NSString * const AnimationNameEnbiggen = @"enbiggen";
NSString * const AnimationNameStretch  = @"stretch";




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

NSString * const AKFromValue      = @"fromvalue";
NSString * const AKToValue        = @"tovalue";
NSString * const AKByValue        = @"byvalue";
NSString * const AKKeyPath        = @"keypath";
NSString * const AKDuration       = @"duration";
NSString * const AKAutoreverses   = @"autoreverses";
NSString * const AKRepeatCount    = @"repeatcount";
NSString * const AKTimingFunction = @"timingfunction";

- (NSDictionary *)animations
{
    if (!_animations) {
        _animations = @{ AnimationNameSpin   : @{AKKeyPath:@"transform.rotation",
                                                 AKFromValue:@0,
                                                 AKToValue:@M_2PI,
                                                 AKDuration:@0.25},
                         AnimationNameSpinCW : @{AKKeyPath:@"transform.rotation",
                                                 AKFromValue:@M_2PI,
                                                 AKToValue:@0,
                                                 AKDuration:@0.5,},
                         AnimationNameSpinCCW : @{AKKeyPath:@"transform.rotation",
                                                  AKFromValue:@M_2PI,
                                                  AKToValue:@0,
                                                  AKDuration:@0.5,},
                         AnimationNameWobble  : @{AKKeyPath:@"transform.rotation",
                                                  AKFromValue:@-M_PI_6,
                                                  AKToValue:@M_PI_6,
                                                  AKAutoreverses:@YES,
                                                  AKTimingFunction:kCAMediaTimingFunctionEaseInEaseOut,
                                                  AKDuration:@0.5},
                         
                         AnimationNameThrob   : @{AKKeyPath:@"opacity",
                                                  AKFromValue:@0,
                                                  AKToValue:@1,
                                                  AKAutoreverses:@YES,
                                                  AKTimingFunction:kCAMediaTimingFunctionLinear,
                                                  AKDuration:@0.5},

                         AnimationNameBounce  : @{AKKeyPath:@"position.y",
                                                  AKByValue:@2,
                                                  AKAutoreverses:@YES,
                                                  AKDuration:@0.25,
                                                  AKTimingFunction:kCAMediaTimingFunctionEaseIn},

                         AnimationNameShake   : @{AKKeyPath:@"position.x",
                                                  AKDuration:@0.25,
                                                  AKTimingFunction:kCAMediaTimingFunctionEaseOut,
                                                  AKAutoreverses:@YES,
                                                  AKByValue:@2},
                         AnimationNameEnbiggen: @{AKKeyPath:@"transform.scale",
                                                  AKDuration:@0.25,
                                                  AKFromValue:@1,
                                                  AKToValue:@3,
                                                  AKAutoreverses:@YES,
                                                  AKTimingFunction:kCAMediaTimingFunctionEaseIn},
                         AnimationNameFlare   : @{},
                         AnimationNameFlip    : @{AKKeyPath:@"transform.rotation.x",
                                                  AKDuration:@0.25,
                                                  AKAutoreverses:@YES,
                                                  AKFromValue:@0,
                                                  AKToValue:@M_2PI},
                         AnimationNameFlipX   : @{AKKeyPath:@"transform.rotation.x",
                                                  AKDuration:@0.25,
                                                  AKAutoreverses:@YES,
                                                  AKFromValue:@0,
                                                  AKToValue:@M_2PI},

                         AnimationNameFlipY   : @{AKKeyPath:@"transform.rotation.y",
                                                  AKDuration:@0.25,
                                                  AKAutoreverses:@YES,
                                                  AKFromValue:@0,
                                                  AKToValue:@M_2PI},

                         AnimationNameStretch : @{ AKKeyPath:@"transform.scale.x",
                                                   AKDuration:@0.25,
                                                   AKAutoreverses:@YES,
                                                   AKFromValue:@1.0,
                                                   AKToValue:@4.0},


                         AnimationNameShine   : @{},
                         AnimationNameTwinkle : @{},
                         
                         AnimationNameBlink   : @{AKKeyPath:@"hidden",
                                                  AKFromValue:@YES,
                                                  AKToValue:@NO,
                                                  AKDuration:@0.25},

                        };
    }
    return _animations;
}



#pragma mark - Public Methods

- (BOOL)hasAnimationNamed:(NSString *)animationName
{
    return self.animations[[animationName lowercaseString]] != nil;
}


- (CABasicAnimation *)animationForLayer:(CALayer *)layer  withKeyPath:(NSString *)keyPath usingDictionary:(NSDictionary *)info
{
    if (!info) {
        return nil;
    }
    
    __block CABasicAnimation *theAnimation = [[CABasicAnimation alloc] init];
    
    return theAnimation;
}

- (CABasicAnimation *)animationForName:(NSString *)name
{
    NSDictionary *info = self.animations[name];
    CABasicAnimation *basic = nil;
    if (info) {
        basic = [CABasicAnimation animationWithKeyPath:info[AKKeyPath]];
        
        basic.repeatCount = HUGE_VALF;
        basic.autoreverses = NO;
        basic.duration = 0.5;
        
        if (info[AKAutoreverses]) {
            basic.autoreverses = [info[AKAutoreverses] boolValue];
        }
        
        if (info[AKByValue]) {
            basic.byValue = info[AKByValue];
        }

        if (info[AKToValue]) {
            basic.toValue = info[AKToValue];
        }
        
        if (info[AKFromValue]) {
            basic.fromValue = info[AKFromValue];
        }
        
        if (info[AKRepeatCount]) {
            basic.repeatCount = [info[AKRepeatCount] floatValue];
        }
        
        if (info[AKDuration]) {
            basic.duration = [info[AKDuration] floatValue];
        }
    }
    return basic;

}

- (CABasicAnimation *)animationForLayer:(CALayer *)layer withName:(NSString *)name
{
    name = [name lowercaseString];
    
    CABasicAnimation *animation = [self animationForName:name];
    
    if (!animation) {
        return nil;
    }
    

    
    if ([name isEqualToString:AnimationNameFlip]) {
        CATransform3D invertTransform = CATransform3DInvert(layer.transform);
        layer.transform = invertTransform;
        [layer setNeedsDisplay];
        return animation;
    }
    
    if ([name isEqualToString:AnimationNameSpin] ||
        [name isEqualToString:AnimationNameSpinCW] ||
        [name isEqualToString:AnimationNameSpinCCW] ||
        [name isEqualToString:AnimationNameWobble] ) {

        CGFloat startRotation = [[layer valueForKeyPath:@"transform.rotation"] floatValue];
        
        CGFloat toValue = [animation.toValue floatValue];
        
        CATransform3D rotationTransform = CATransform3DRotate(layer.transform, M_2PI, 0, 0, 1);
        layer.transform = rotationTransform;
        animation.toValue = [NSNumber numberWithFloat:startRotation + toValue];
        return animation;
    }
    
    return animation;
}




@end
