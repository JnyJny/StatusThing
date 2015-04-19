//
//  NSBezierPath+BezierPathQuartzUtilities.h
//  StatusThing
//
//  Created by Erik on 4/18/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSBezierPath (BezierPathQuartzUtilities)
- (CGPathRef)quartzPath;
@end
