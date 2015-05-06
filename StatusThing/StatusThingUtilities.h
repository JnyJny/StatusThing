//
//  StatusThingUtilities.h
//  StatusThing
//
//  Created by Erik on 5/1/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString *const StatusThingPreferencesDomain;

extern NSString *const StatusThingPreferenceLaunchOnLogin;
extern NSString *const StatusThingPreferenceAllowRemoteConnections;
extern NSString *const StatusThingPreferenceAllowAnimations;
extern NSString *const StatusThingPreferenceUseBonjour;
extern NSString *const StatusThingPreferencePortNumber;

extern NSString *const AppleInterfaceThemeChangedNotification;
extern NSString *const AppleInterfaceStyle;
extern NSString *const AppleInterfaceStyleDark;

@interface StatusThingUtilities : NSObject



+ (void)registerDefaultsForBundle:(NSBundle *)bundle;
+ (void)registerDefaults;
+ (NSDictionary *)preferences;
+ (id)preferenceForKey:(NSString *)key;

+ (id)valueForKey:(NSString *)key inDomain:(NSString *)domain;
+ (void)saveValue:(id)value forPreferenceKey:(NSString *)preferenceKey toDomain:(NSString *)domain;

+ (BOOL)enableLoginItemForBundle:(NSBundle *)bundle;
+ (BOOL)disableLoginItemForBundle:(NSBundle *)bundle;
+ (BOOL)isLoginItemEnabledForBundle:(NSBundle *)bundle;
+ (BOOL)isDarkInterfaceStyle;

@end
