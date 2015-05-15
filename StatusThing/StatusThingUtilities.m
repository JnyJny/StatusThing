//
//  StatusThingUtilities.m
//  StatusThing
//
//  Created by Erik on 5/1/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "StatusThingUtilities.h"

#pragma mark - Constants

NSString *const StatusThingDomain                                  = @"com.symbolicarmageddon.StatusThing";

NSString *const StatusThingDefaultPreferencesFile                  = @"DefaultPreferences";
NSString *const StatusThingPlistFileExtension                      = @"plist";

// These are keys and _NOT_ key paths
NSString *const StatusThingPreferenceLaunchOnLogin                 = @"com.symbolicarmageddon.StatusThing.launchOnLogin";
NSString *const StatusThingPreferenceAllowRemoteConnections        = @"com.symbolicarmageddon.StatusThing.allowRemoteConnections";
NSString *const StatusThingPreferenceAllowAnimations               = @"com.symbolicarmageddon.StatusThing.allowAnimations";
NSString *const StatusThingPreferencePortNumber                    = @"com.symbolicarmageddon.StatusThing.portNumber";
NSString *const StatusThingPreferenceStatusViewDictionary          = @"com.symbolicarmageddon.StatusThing.statusView";

NSString *const AppleInterfaceThemeChangedNotification             = @"AppleInterfaceThemeChangedNotification";
NSString *const AppleInterfaceStyle                                = @"AppleInterfaceStyle";
NSString *const AppleInterfaceStyleDark                            = @"dark";

NSString *const StatusThingIdleConfigurationChangedNotification    = @"StatusThingIdleConfigurationChangedNotification";
NSString *const StatusThingNetworkConfigurationChangedNotification = @"StatusThingNetworkConfigurationChangedNotification";


@implementation StatusThingUtilities

#pragma mark - Application Preferences / Defaults

+ (void)registerDefaults
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *path = [[NSBundle mainBundle] pathForResource:StatusThingDefaultPreferencesFile
                                                     ofType:StatusThingPlistFileExtension];
    [userDefaults registerDefaults:[NSDictionary dictionaryWithContentsOfFile:path]];
}



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




@end
