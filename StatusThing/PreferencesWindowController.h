//
//  PreferencesWindowController.h
//  StatusThing
//
//  Created by Erik on 5/2/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "StatusView.h"

@interface PreferencesWindowController : NSWindowController <NSWindowDelegate>
@property (strong,nonatomic  ) StatusView           *exampleStatusView;
@property (strong            ) IBOutlet NSView      *exampleView;
@property (strong            ) IBOutlet NSComboBox  *shapeComboxBox;
@property (strong            ) IBOutlet NSColorWell *foregroundColorWell;
@property (strong            ) IBOutlet NSColorWell *backgroundColorWell;
@property (strong            ) IBOutlet NSColorWell *textColorWell;
@property (strong            ) IBOutlet NSButton    *foregroundHiddenButton;
@property (strong            ) IBOutlet NSButton    *backgroundHiddenButton;
@property (strong            ) IBOutlet NSButton    *textHiddenButton;
@property (strong            ) IBOutlet NSButton    *allowRemoteConnectionsButton;
@property (strong            ) IBOutlet NSButton    *allowAnimationsButton;
@property (strong            ) IBOutlet NSButton    *useBonjourButton;
@property (strong            ) IBOutlet NSTextField *staticPortNumberTextField;
@property (strong            ) IBOutlet NSButton    *launchOnLoginButton;

@end
