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

// XXX keep the string literals in lowercase
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
NSString * const AnimationNameBlink    = @"blink";
NSString * const AnimationNameEnbiggen = @"enbiggen";
NSString * const AnimationNameStretch  = @"stretch";
NSString * const AnimationNameStretchX = @"stretchx";
NSString * const AnimationNameStretchY = @"stretchy";
NSString * const AnimationNameWink     = @"wink";
NSString * const AnimationNameWinkX    = @"winkx";
NSString * const AnimationNameWinkY    = @"winky";
NSString * const AnimationNameTickerLR = @"ticker";
NSString * const AnimationNameTickerRL = @"reverseticker";

NSString * const AnimationSpeedSlowest = @"slowest";
NSString * const AnimationSpeedSlower  = @"slower";
NSString * const AnimationSpeedSlow    = @"slow";
NSString * const AnimationSpeedNormal  = @"normal";
NSString * const AnimationSpeedFast    = @"fast";
NSString * const AnimationSpeedFaster  = @"faster";
NSString * const AnimationSpeedFastest = @"fastest";

@interface AnimationFactory ()

@end


@implementation AnimationFactory

#pragma mark - LifeCycle


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
        _animations = @{ AnimationNameSpin    : @{AKKeyPath:@"transform.rotation",
                                                  AKFromValue:@0,
                                                  AKToValue:@M_2PI},

                         AnimationNameSpinCW  : @{AKKeyPath:@"transform.rotation",
                                                  AKFromValue:@M_2PI,
                                                  AKToValue:@0},

                         AnimationNameSpinCCW : @{AKKeyPath:@"transform.rotation",
                                                  AKFromValue:@M_2PI,
                                                  AKToValue:@0},

                         AnimationNameWobble  : @{AKKeyPath:@"transform.rotation",
                                                  AKFromValue:@-M_PI_6,
                                                  AKToValue:@M_PI_6,
                                                  AKAutoreverses:@YES,
                                                  AKTimingFunction:kCAMediaTimingFunctionEaseInEaseOut},

                         AnimationNameThrob   : @{AKKeyPath:@"opacity",
                                                  AKFromValue:@0,
                                                  AKToValue:@1,
                                                  AKAutoreverses:@YES,
                                                  AKTimingFunction:kCAMediaTimingFunctionLinear},

                         AnimationNameBounce  : @{AKKeyPath:@"position.y",
                                                  AKByValue:@2,
                                                  AKAutoreverses:@YES,
                                                  AKTimingFunction:kCAMediaTimingFunctionEaseIn},

                         AnimationNameShake   : @{AKKeyPath:@"position.x",
                                                  AKTimingFunction:kCAMediaTimingFunctionEaseOut,
                                                  AKAutoreverses:@YES,
                                                  AKByValue:@2},


                         AnimationNameEnbiggen : @{AKKeyPath:@"transform.scale",
                                                   AKFromValue:@1,
                                                   AKToValue:@3,
                                                   AKAutoreverses:@YES,
                                                   AKTimingFunction:kCAMediaTimingFunctionEaseIn},

                         AnimationNameFlip     : @{AKKeyPath:@"transform.rotation.x",
                                                   AKAutoreverses:@YES,
                                                   AKFromValue:@0,
                                                   AKToValue:@M_2PI},
                         
                         AnimationNameFlipX   : @{AKKeyPath:@"transform.rotation.x",
                                                  AKAutoreverses:@YES,
                                                  AKFromValue:@0,
                                                  AKToValue:@M_2PI},

                         AnimationNameFlipY   : @{AKKeyPath:@"transform.rotation.y",
                                                  AKAutoreverses:@YES,
                                                  AKFromValue:@0,
                                                  AKToValue:@M_2PI},

                         AnimationNameStretch : @{ AKKeyPath:@"transform.scale.x",
                                                   AKAutoreverses:@YES,
                                                   AKFromValue:@1.0,
                                                   AKToValue:@4.0},

                         AnimationNameStretchX : @{ AKKeyPath:@"transform.scale.x",
                                                   AKAutoreverses:@YES,
                                                   AKFromValue:@1.0,
                                                   AKToValue:@4.0},


                         AnimationNameStretchY : @{ AKKeyPath:@"transform.scale.y",
                                                   AKAutoreverses:@YES,
                                                   AKFromValue:@1.0,
                                                   AKToValue:@4.0},


                         AnimationNameBlink   : @{AKKeyPath:@"hidden",
                                                  AKFromValue:@YES,
                                                  AKToValue:@NO},

                         AnimationNameWink    : @{ AKKeyPath:@"transform.scale.y",
                                                   AKTimingFunction:kCAMediaTimingFunctionEaseInEaseOut,
                                                   AKAutoreverses:@YES,
                                                   AKFromValue:@1.0,
                                                   AKToValue:@0.0},

                         AnimationNameWinkX   : @{ AKKeyPath:@"transform.scale.x",
                                                   AKTimingFunction:kCAMediaTimingFunctionEaseInEaseOut,
                                                   AKAutoreverses:@YES,
                                                   AKFromValue:@1.0,
                                                   AKToValue:@0.0},

                         AnimationNameWinkY   : @{ AKKeyPath:@"transform.scale.y",
                                                   AKTimingFunction:kCAMediaTimingFunctionEaseInEaseOut,
                                                   AKAutoreverses:@YES,
                                                   AKFromValue:@1.0,
                                                   AKToValue:@0.0},
                         
                         AnimationNameTickerLR : @{ AKKeyPath:@"position.x",
                                                    AKDuration:@6.0,
                                                    AKAutoreverses:@NO },
                         
                         AnimationNameTickerRL : @{ AKKeyPath:@"position.x",
                                                    AKDuration:@6.0,
                                                    AKAutoreverses:@NO },

                        };
    }
    return _animations;
}

- (NSDictionary *)speeds
{
    if (!_speeds) {
        _speeds = @{ AnimationSpeedSlowest:@6.0,
                     AnimationSpeedSlower :@3.0,
                     AnimationSpeedSlow   :@1.5,
                     AnimationSpeedNormal :@0.50,
                     AnimationSpeedFast   :@0.25,
                     AnimationSpeedFaster :@0.125,
                     AnimationSpeedFastest:@0.0625 };
    }
    return _speeds;
}


#pragma mark - Public Methods

- (BOOL)hasAnimationNamed:(NSString *)animationName
{
    NSDictionary *info;
    
    @try {
        info = self.animations[[animationName lowercaseString]];
    }
    @catch (NSException *exception) {
        info = nil;
    }

    return !(info == nil);
}




- (CABasicAnimation *)animationForName:(NSString *)name withDuration:(CGFloat)duration 
{
    NSDictionary *info = self.animations[name];
    
    CABasicAnimation *basic = nil;
    if (info) {
        basic = [CABasicAnimation animationWithKeyPath:info[AKKeyPath]];
        
        basic.repeatCount = HUGE_VALF;
        basic.autoreverses = NO;

        if (duration <= 0) {
            if (info[AKDuration]) {
                duration = [info[AKDuration] floatValue];
            }
            else {
                duration = 0.50;
            }
        }
        basic.duration = duration;
        
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
    }
    return basic;

}

- (CABasicAnimation *)animationForLayer:(CALayer *)layer withName:(NSString *)name
{
    return [self animationForLayer:layer
                          withName:name
                          andSpeed:nil];
    
}

- (CABasicAnimation *)animationForLayer:(CALayer *)layer withName:(NSString *)name andSpeed:(NSString *)speed
{
    CGFloat duration;
    
    name = [name lowercaseString];
    speed = [speed lowercaseString];

    duration = (speed)?[self.speeds[speed] floatValue]:0.0;
    
    CABasicAnimation *animation = [self animationForName:name withDuration:duration];
    
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
    
    if ([name isEqualToString:AnimationNameTickerLR]) {
        animation.fromValue = [NSNumber numberWithFloat:CGRectGetMaxX(layer.bounds)];
        animation.toValue   = [NSNumber numberWithFloat:CGRectGetMinX(layer.bounds) - CGRectGetWidth(layer.bounds)];
    }
        
    if ([name isEqualToString:AnimationNameTickerRL]) {
        animation.fromValue = [NSNumber numberWithFloat:CGRectGetMinX(layer.bounds)];
        animation.toValue   = [NSNumber numberWithFloat:CGRectGetMaxX(layer.bounds) + CGRectGetWidth(layer.bounds)];
    }
    
    return animation;
}




@end
