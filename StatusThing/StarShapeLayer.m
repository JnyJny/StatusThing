//
//  StarShapeLayer.m
//  StatusThing
//
//  Created by Erik on 4/20/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "StarShapeLayer.h"

@implementation StarShapeLayer

@synthesize path = _path;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sides = 5;
    }
    return self;
}

- (NSString *)name
{
    return GeometricShapeStar;
}

- (CGFloat)points
{
    return self.sides;
}

- (void)setPoints:(CGFloat)points
{
    self.sides = points;
}

- (CGFloat)minorRadius
{
    return 12;
}

- (CGPathRef)path
{
    if (_path == nil) {
        CGPoint *interior;
        CGPoint *exterior;
        CGPoint *allpoints;
        
        CGFloat dx = CGRectGetWidth(self.bounds) - self.minorRadius;
        CGFloat dy = CGRectGetHeight(self.bounds) - self.minorRadius;
        
        CGRect minorRect = CGRectInset(self.bounds, dx, dy);
        
        CGFloat minorTheta = M_2PI / self.points;
    
        interior = [self verticesCenteredInRect:minorRect
                              withNumberOfSides:self.points withInitialAngleInRadians:self.initialAngle+minorTheta];
    
        exterior = [self verticesCenteredInRect:self.bounds
                              withNumberOfSides:self.points
                      withInitialAngleInRadians:self.initialAngle];
        
        allpoints = calloc(self.points * 2, sizeof(CGPoint));
        // aaaaa bbbbb -> ababababab
        for(int i=0;i<self.points;i++) {
            allpoints[i*2] = exterior[i];
            allpoints[(i*2)+1] = interior[i];
        }
    
        _path = [self drawClosedPathWithTransform:nil
                                      havingCount:self.points * 2
                                           points:allpoints];
        
        free(interior);
        free(exterior);
        free(allpoints);
    }
    return _path;
}


@end
