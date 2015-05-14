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
@property (weak              ) IBOutlet NSView      *exampleView;
@property (weak              ) IBOutlet NSComboBox  *shapeComboxBox;
@property (weak              ) IBOutlet NSColorWell *foregroundColorWell;
@property (weak              ) IBOutlet NSColorWell *backgroundColorWell;
@property (weak              ) IBOutlet NSColorWell *textColorWell;
@property (weak              ) IBOutlet NSButton    *foregroundHiddenButton;
@property (weak              ) IBOutlet NSButton    *backgroundHiddenButton;
@property (weak              ) IBOutlet NSButton    *textHiddenButton;
@property (weak              ) IBOutlet NSButton    *allowAnimationsButton;
@property (weak              ) IBOutlet NSButton    *allowFiltersButton;
@property (weak              ) IBOutlet NSButton    *allowRemoteConnectionsButton;
@property (weak              ) IBOutlet NSButton    *lotsOfThingsButton;
@property (weak              ) IBOutlet NSButton    *useBonjourButton;
@property (weak              ) IBOutlet NSTextField *staticPortNumberTextField;
@property (weak              ) IBOutlet NSButton    *launchOnLoginButton;
@property (weak              ) IBOutlet NSTextField *inputTextField;
@property (weak              ) IBOutlet NSTextField *inputResultField;


@end
