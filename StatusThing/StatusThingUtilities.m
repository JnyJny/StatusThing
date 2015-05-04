//
//  StatusThingUtilities.m
//  StatusThing
//
//  Created by Erik on 5/1/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "StatusThingUtilities.h"

#pragma mark - Constants

NSString *const StatusThingDefaultPreferencesFile      = @"com.symbolicarmageddon.StatusThing.defaults";
NSString *const StatusThingDefaultPlistFileExtension   = @"plist";
NSString *const StatusThingPreferencesDomain           = @"com.symbolicarmageddon.StatusThing";

NSString *const AppleInterfaceThemeChangedNotification = @"AppleInterfaceThemeChangedNotification";
NSString *const AppleInterfaceStyle                    = @"AppleInterfaceStyle";
NSString *const AppleInterfaceStyleDark                = @"dark";

@implementation StatusThingUtilities

#pragma mark - Application Preferences / Defaults

+ (void)registerDefaultsForBundle:(NSBundle *)bundle
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *path = [bundle pathForResource:StatusThingDefaultPreferencesFile
                                      ofType:StatusThingDefaultPlistFileExtension];
    
    NSDictionary *defaults = [NSDictionary dictionaryWithContentsOfFile:path];
    
    
    [userDefaults registerDefaults:defaults];
}

 + (void)registerDefaults
{
    return [StatusThingUtilities registerDefaultsForBundle:[NSBundle mainBundle]];
}

+ (NSDictionary *)preferences
{
    
    NSDictionary *prefs = nil;

    while (!prefs) {
        prefs = [[NSUserDefaults standardUserDefaults] objectForKey:StatusThingPreferencesDomain];
        if (!prefs) {
            [StatusThingUtilities registerDefaultsForBundle:[NSBundle mainBundle]];
        }
    }
    return prefs;
}

+ (void)saveValue:(id)value forPreferenceKey:(NSString *)preferenceKey
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:value forKey:preferenceKey];
    
    [defaults synchronize];
}

// synchronize defaults, called on terminate?


#pragma mark - Login item query/enable/disable

+ (BOOL)enableLoginItemForBundle:(NSBundle *)bundle
{
    LSSharedFileListRef sharedFileList;
    LSSharedFileListItemRef item;
    NSURL *applicationPathURL;
    BOOL succeed = NO;
    
    applicationPathURL = [NSURL fileURLWithPath:bundle.bundlePath];
    
    sharedFileList = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    
    if (!sharedFileList) {
        return NO;
    }
    
    item = LSSharedFileListInsertItemURL(sharedFileList,
                                         kLSSharedFileListItemLast, NULL, NULL,
                                         (__bridge CFURLRef)applicationPathURL, NULL, NULL);
    
    if (item) {
        CFRelease(item);
        succeed = YES;
    }
    else {
        NSLog(@"enableLoginItemForBundle:%@ failed to insert URL %@",bundle,applicationPathURL);
    }
    
    CFRelease(sharedFileList);
    return succeed;
}


+ (BOOL)loginItemForBundle:(NSBundle *)bundle removeIfFound:(BOOL)remove
{
    LSSharedFileListRef sharedFileList;
    LSSharedFileListItemRef item;
    CFURLRef applicationPathURL;

    NSArray *sharedFiles;
    UInt32 seed;
    BOOL success = NO;
    
    
    sharedFileList = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    
    if (!sharedFileList) {
        return NO;
    }
    
    sharedFiles = CFBridgingRelease(LSSharedFileListCopySnapshot(sharedFileList, &seed));
    
    for (id sharedFile in sharedFiles) {
        item = (__bridge LSSharedFileListItemRef)sharedFile;
        
        applicationPathURL = LSSharedFileListItemCopyResolvedURL(item, 0, NULL);
        if (applicationPathURL) {
            NSString *resolvedPath = [(__bridge NSURL *)applicationPathURL path];
            if ([resolvedPath compare:bundle.bundlePath] == NSOrderedSame) {
                success = YES;
                if (remove) {
                    LSSharedFileListItemRemove(sharedFileList, item);
                }
            }
            CFRelease(applicationPathURL);
        }
        if (success) {
            break;
        }
    }
    
    CFRelease(sharedFileList);

    return success;
}

+ (BOOL)disableLoginItemForBundle:(NSBundle *)bundle
{
    return [StatusThingUtilities loginItemForBundle:bundle removeIfFound:YES];
}

+ (BOOL)isLoginItemEnabledForBundle:(NSBundle *)bundle
{
    return [StatusThingUtilities loginItemForBundle:bundle removeIfFound:NO];
}

#pragma mark - Query Interface Style

+ (BOOL)isDarkInterfaceStyle
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[userDefaults stringForKey:AppleInterfaceStyle] isEqualToString:AppleInterfaceStyleDark];
}


@end
