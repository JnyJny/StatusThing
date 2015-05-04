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

    [StatusThingUtilities registerDefaults];
    
    [self.statusController start];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {

    [self.statusController stop];
}




@end
