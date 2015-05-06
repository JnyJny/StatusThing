//
//  ShapeFactory.h
//  StatusThing
//
//  Created by Erik on 4/30/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - pointsForShape:centeredInRect:rotatedBy: generates these shapes

extern NSString *const ShapeNameLine;
extern NSString *const ShapeNameTriangle;
extern NSString *const ShapeNameSquare;
extern NSString *const ShapeNameDiamond;
extern NSString *const ShapeNamePentagon;
extern NSString *const ShapeNameHexagon;
extern NSString *const ShapeNameSeptagon;
extern NSString *const ShapeNameOctagon;
extern NSString *const ShapeNameNonagon;
extern NSString *const ShapeNameDecagon;
extern NSString *const ShapeNameEndecagon;
extern NSString *const ShapeNameTrigram;
extern NSString *const ShapeNameQuadragram;
extern NSString *const ShapeNamePentagram;
extern NSString *const ShapeNameHexagram;
extern NSString *const ShapeNameSeptagram;
extern NSString *const ShapeNameOctagram;
extern NSString *const ShapeNameNonagram;
extern NSString *const ShapeNameDecagram;
extern NSString *const ShapeNameEndecagram;

#pragma mark - pointsForShape:centeredInRect:rotatedBy: DOES NOT generate these shapes

// Generate paths for these shapes with Core Graphics instead.
extern NSString *const ShapeNameNone;
extern NSString *const ShapeNameCircle;
extern NSString *const ShapeNameRoundedSquare;

#pragma mark -
@interface ShapeFactory : NSObject

@property (strong,nonatomic,readonly) NSDictionary *shapes;

+ (NSArray *)allShapes;
- (NSArray *)pointsForShape:(NSString *)shape centeredInRect:(CGRect)rect rotatedBy:(CGFloat)degrees;

@end
