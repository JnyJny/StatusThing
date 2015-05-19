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


#pragma mark - UI Bindings
#pragma mark - Settings
@property (weak              ) IBOutlet NSTextField   *staticPortNumberTextField;
@property (weak              ) IBOutlet NSButton      *allowAnimationsButton;
@property (weak              ) IBOutlet NSButton      *allowMessagesButton;
@property (weak              ) IBOutlet NSButton      *allowRemoteConnectionsButton;
@property (weak              ) IBOutlet NSTextField   *fastestField;
@property (weak              ) IBOutlet NSStepper     *fastestStepper;
@property (weak              ) IBOutlet NSTextField   *fasterField;
@property (weak              ) IBOutlet NSStepper     *fasterStepper;
@property (weak              ) IBOutlet NSTextField   *fastField;
@property (weak              ) IBOutlet NSStepper     *fastStepper;
@property (weak              ) IBOutlet NSTextField   *normalField;
@property (weak              ) IBOutlet NSStepper     *normalStepper;
@property (weak              ) IBOutlet NSTextField   *slowField;
@property (weak              ) IBOutlet NSStepper     *slowStepper;
@property (weak              ) IBOutlet NSTextField   *slowerField;
@property (weak              ) IBOutlet NSStepper     *slowerStepper;
@property (weak              ) IBOutlet NSTextField   *slowestField;
@property (weak              ) IBOutlet NSStepper     *slowestStepper;
@property (weak              ) IBOutlet NSButton      *restoreAnimationSpeeds;
@property (weak              ) IBOutlet NSButton      *saveAnimationSpeeds;

@property (weak              ) IBOutlet NSButton      *launchOnLoginButton;

#pragma mark - Appearance
@property (weak              ) IBOutlet NSButton      *toggleShapeLock;
@property (weak              ) IBOutlet NSView        *exampleView;

@property (weak              ) IBOutlet NSButton      *backgroundHiddenToggle;
@property (weak              ) IBOutlet NSPopUpButton *backgroundShapeList;
@property (weak              ) IBOutlet NSColorWell   *backgroundFillColor;
@property (weak              ) IBOutlet NSColorWell   *backgroundStrokeColor;
@property (weak              ) IBOutlet NSTextField   *backgroundLineWidthField;
@property (weak              ) IBOutlet NSStepper     *backgroundLineWidthStepper;

@property (weak              ) IBOutlet NSButton      *foregroundHiddenToggle;
@property (weak              ) IBOutlet NSPopUpButton *foregroundShapeList;
@property (weak              ) IBOutlet NSColorWell   *foregroundFillColor;
@property (weak              ) IBOutlet NSColorWell   *foregroundStrokeColor;
@property (weak              ) IBOutlet NSTextField   *foregroundLineWidthField;
@property (weak              ) IBOutlet NSStepper     *foregroundLineWidthStepper;

@property (weak              ) IBOutlet NSButton      *textHiddenToggle;
@property (weak              ) IBOutlet NSColorWell   *textForegroundColor;
@property (weak              ) IBOutlet NSTextField   *textStringField;
@property (weak              ) IBOutlet NSTextField   *textFontSizeField;
@property (weak              ) IBOutlet NSStepper     *textFontSizeStepper;
@property (weak              ) IBOutlet NSPopUpButton *textFontList;

@property (weak              ) IBOutlet NSTextField   *inputTextField;
@property (weak              ) IBOutlet NSTextField   *inputResultField;

@property (weak              ) IBOutlet NSButton      *resetButton;
@property (weak              ) IBOutlet NSButton      *acceptButton;






@end
