//
//  AppDelegate.h
//  StatusThing
//
//  Created by Erik on 4/16/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "StatusController.h"


@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (strong,nonatomic) IBOutlet StatusController *statusController;


@end

