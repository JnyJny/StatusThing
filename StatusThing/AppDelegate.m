//
//  AppDelegate.m
//  StatusThing
//
//  Created by Erik on 4/16/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "AppDelegate.h"
#import "StatusThingUtilities.h"



@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    [StatusThingUtilities registerDefaultsForBundle:[NSBundle mainBundle]];
    
    [self.statusController start];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {

    [self.statusController stop];
}


- (StatusController *)statusController
{
    if (!_statusController) {
        _statusController = [[StatusController alloc] initWithPreferences:[StatusThingUtilities preferences]];

    }
    return _statusController;
}



@end
