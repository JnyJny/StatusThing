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
extern NSString *const StatusThingPreferenceAllowMessages;
extern NSString *const StatusThingPreferencePortNumber;
extern NSString *const StatusThingPreferenceStatusViewDictionary;
extern NSString *const StatusThingPreferenceAnimationSpeeds;

#pragma mark - Apple Interface Constants
extern NSString *const AppleInterfaceThemeChangedNotification;
extern NSString *const AppleInterfaceStyle;
extern NSString *const AppleInterfaceStyleDark;

#pragma mark - StatusThing NSNotification Names

extern NSString *const StatusThingIdleConfigurationChangedNotification;
extern NSString *const StatusThingNetworkConfigurationChangedNotification;
extern NSString *const StatusThingAnimationPreferenceChangedNotification;
extern NSString *const StatusThingRemoteAccessPreferenceChangedNotification;
extern NSString *const StatusThingMessagingPreferenceChangedNotification;

extern NSString *const StatusThingAnimationSpeedKeyFastest;
extern NSString *const StatusThingAnimationSpeedKeyFaster;
extern NSString *const StatusThingAnimationSpeedKeyFast;
extern NSString *const StatusThingAnimationSpeedKeyNormal;
extern NSString *const StatusThingAnimationSpeedKeySlow;
extern NSString *const StatusThingAnimationSpeedKeySlower;
extern NSString *const StatusThingAnimationSpeedKeySlowest;

@interface StatusThingUtilities : NSObject

+ (void)registerDefaults;
+ (BOOL)enableLoginItemForBundle:(NSBundle *)bundle;
+ (BOOL)disableLoginItemForBundle:(NSBundle *)bundle;
+ (BOOL)isLoginItemEnabledForBundle:(NSBundle *)bundle;
+ (NSDictionary *)speeds;


@end
