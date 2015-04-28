//
//  AppDelegate.m
//  StatusThing
//
//  Created by Erik on 4/16/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "AppDelegate.h"
#import "NSColor+NamedColorUtilities.h"

#import "Konstants.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    [self installApplicationDefaults];
    
    [self.statusController start];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    [self.statusController stop];
}





- (StatusController *)statusController
{
    if (_statusController == nil) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        NSDictionary *prefs = [userDefaults objectForKey:kStatusThingDomain];
        
        _statusController = [[StatusController alloc] initWithPort:[prefs valueForKey:@"port"]];
        
        [_statusController.statusView updateWithDictionary:[prefs objectForKey:@"statusView"]];
        
        
    }
    return _statusController;
}

- (void)installApplicationDefaults
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *prefPath = [[NSBundle mainBundle] pathForResource:KDefaultPrefPlist ofType:@"plist"];
    
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:prefPath];
    
    [userDefaults registerDefaults:prefs];
}

@end
