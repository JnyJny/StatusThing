//
//  StatusThingUtilities.h
//  StatusThing
//
//  Created by Erik on 5/1/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const StatusThingDomain;

extern NSString *const StatusThingDefaultPreferencesFile;
extern NSString *const StatusThingPlistFileExtension;

#pragma mark - UserDefaults Preference Keys
extern NSString *const StatusThingPreferenceLaunchOnLogin;
extern NSString *const StatusThingPreferenceAllowRemoteConnections;
extern NSString *const StatusThingPreferenceAllowAnimations;
extern NSString *const StatusThingPreferenceAllowFilters;
extern NSString *const StatusThingPreferenceLotsOfThings;
extern NSString *const StatusThingPreferenceUseBonjour;
extern NSString *const StatusThingPreferencePortNumber;
extern NSString *const StatusThingPreferenceStatusViewDictionary;

#pragma mark - Apple Interface Constants
extern NSString *const AppleInterfaceThemeChangedNotification;
extern NSString *const AppleInterfaceStyle;
extern NSString *const AppleInterfaceStyleDark;

#pragma mark - StatusThing NSNotification Names

extern NSString *const StatusThingIdleConfigurationChangedNotification;
extern NSString *const StatusThingNetworkConfigurationChangedNotification;

@interface StatusThingUtilities : NSObject

+ (void)registerDefaults;
+ (BOOL)enableLoginItemForBundle:(NSBundle *)bundle;
+ (BOOL)disableLoginItemForBundle:(NSBundle *)bundle;
+ (BOOL)isLoginItemEnabledForBundle:(NSBundle *)bundle;
+ (BOOL)isDarkInterfaceStyle;

@end
