//
//  AppDelegate.m
//  StatusThing
//
//  Created by Erik on 4/16/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "AppDelegate.h"
#import "Konstants.h"


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    [self installApplicationDefaults];
    
    [self.statusController start];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {

    [self.statusController stop];
}


- (StatusController *)statusController
{
    if (_statusController == nil) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        NSDictionary *prefs = [userDefaults objectForKey:StatusThingDomain];
        
        _statusController = [[StatusController alloc] initWithPreferences:prefs];

    }
    return _statusController;
}

- (void)installApplicationDefaults
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *prefPath = [[NSBundle mainBundle] pathForResource:StatusThingPrefFile ofType:@"plist"];
    
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:prefPath];
    
    [userDefaults registerDefaults:prefs];
}

@end
