//
//  CALayer+CALayer_LayoutUtilties.h
//  StatusThing
//
//  Created by Erik on 4/20/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (CALayer_LayoutUtilties)

- (void)layoutSublayerOfLayer:(CALayer *)layer;

- (void)centerInRect:(CGRect)rect;
- (void)centerInRect:(CGRect)rect andInset:(CGPoint)delta;

@end
