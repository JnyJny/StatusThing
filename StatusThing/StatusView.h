//
//  StatusView.h
//  StatusThing
//
//  Created by Erik on 4/18/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@interface StatusView : NSView

@property (strong,nonatomic,readonly) CAShapeLayer *background;
@property (strong,nonatomic,readonly) CAShapeLayer *foreground;
@property (strong,nonatomic,readonly) CATextLayer  *text;
@property (assign,nonatomic,readonly) CGRect       insetRect;
@property (strong,nonatomic         ) NSString     *shape;
@property (strong,nonatomic,readonly) NSDictionary *capabilities;

- (void)removeAllAnimations;
- (void)updateWithDictionary:(NSDictionary *)info;
- (NSDictionary *)currentConfiguration;
- (void)centerInRect:(CGRect)rect;

@end
