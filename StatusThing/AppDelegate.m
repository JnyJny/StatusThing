//
//  AppDelegate.m
//  StatusThing
//
//  Created by Erik on 4/16/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "AppDelegate.h"
#import "Konstants.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [self.statusController start];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    [self.statusController stop];
}



- (StatusController *)statusController
{
    if (_statusController == nil) {
        NSString *env = [[[NSProcessInfo processInfo] environment] objectForKey:kPortEnvVar];
        NSNumber *port = env?[NSNumber numberWithInteger:[env integerValue]]:nil;
        
        _statusController = [[StatusController alloc] initWithPort:port];
        
    }
    return _statusController;
}

@end
