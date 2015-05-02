//
//  StatusThingUtilities.h
//  StatusThing
//
//  Created by Erik on 5/1/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const AppleInterfaceThemeChangedNotification;
extern NSString *const AppleInterfaceStyle;
extern NSString *const AppleInterfaceStyleDark;

@interface StatusThingUtilities : NSObject



+ (void)registerDefaultsForBundle:(NSBundle *)bundle;
+ (NSDictionary *)preferences;

+ (BOOL)enableLoginItemForBundle:(NSBundle *)bundle;
+ (BOOL)disableLoginItemForBundle:(NSBundle *)bundle;
+ (BOOL)isLoginItemEnabledForBundle:(NSBundle *)bundle;
+ (BOOL)isDarkInterfaceStyle;

@end
