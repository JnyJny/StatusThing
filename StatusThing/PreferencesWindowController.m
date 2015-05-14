//
//  PreferencesWindowController.m
//  StatusThing
//
//  Created by Erik on 5/2/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "PreferencesWindowController.h"
#import "NSColor+NamedColorUtilities.h"
#import "NSUserDefaults+HandleNSColor.h"
#import "StatusThingUtilities.h"
#import "ShapeFactory.h"


@interface PreferencesWindowController ()
@property (strong,nonatomic) NSUserDefaults *userDefaults;
@property (strong,nonatomic) NSNotificationCenter *notificationCenter;

@end


@implementation PreferencesWindowController


- (void)awakeFromNib
{
    [self.exampleView addSubview:self.exampleStatusView];
    
    [self.exampleStatusView centerInRect:self.exampleView.bounds];
    
    [self.shapeComboxBox addItemsWithObjectValues:[ShapeFactory allShapes]];
}


#pragma mark - Properties

- (NSUserDefaults *)userDefaults
{
    if (!_userDefaults) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    
    return _userDefaults;
}

- (NSNotificationCenter *)notificationCenter
{
    if (!_notificationCenter) {
        _notificationCenter = [NSNotificationCenter defaultCenter];
    }
    return _notificationCenter;
}

- (StatusView *)exampleStatusView
{
    if (!_exampleStatusView) {
        _exampleStatusView = [[StatusView alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    }

    return _exampleStatusView;
}

#pragma mark - IBAction Methods

- (IBAction)showWindow:(id)sender
{

    
    [self didPushReset:nil];
    
    [self.allowRemoteConnectionsButton setState:[self.userDefaults boolForKey:StatusThingPreferenceAllowRemoteConnections]];
    [self.allowAnimationsButton        setState:[self.userDefaults boolForKey:StatusThingPreferenceAllowAnimations]];
    [self.launchOnLoginButton          setState:[self.userDefaults boolForKey:StatusThingPreferenceLaunchOnLogin]];
    [self.staticPortNumberTextField    setIntegerValue:[self.userDefaults integerForKey:StatusThingPreferencePortNumber]];
    
    // NSModalPaneWindowLevel forces the window up to the top if it's visible but buried
    // check against isOccluded?
    [self.window setLevel:NSModalPanelWindowLevel];
    [self.window makeKeyAndOrderFront:sender];
    [self.window setLevel:NSNormalWindowLevel];

}

- (IBAction)toggleHideForeground:(NSButton *)sender
{
    [self.exampleStatusView.foreground setHidden:sender.state];
}

- (IBAction)toggleHideBackground:(NSButton *)sender
{
    [self.exampleStatusView.background setHidden:sender.state];
}

- (IBAction)toggleHideText:(NSButton *)sender
{
    [self.exampleStatusView.text setHidden:sender.state];
}

- (IBAction)shapeSelected:(NSComboBox *)sender
{
    [self.exampleStatusView setShape:sender.stringValue];
}

- (IBAction)toggleRemoteConnections:(NSButton *)sender
{
    [self.userDefaults setBool:sender.state
                        forKey:StatusThingPreferenceAllowRemoteConnections];
}

- (IBAction)toggleAllowAnimations:(NSButton *)sender
{
    [self.userDefaults setBool:sender.state
                        forKey:StatusThingPreferenceAllowAnimations];
    
    [self.notificationCenter postNotificationName:StatusThingIdleConfigurationChangedNotification
                                           object:nil];
}

- (IBAction)portNumberUpdated:(NSTextField *)sender
{
    NSNumber *portNumber = [NSNumber numberWithUnsignedShort:sender.intValue];

    [self.userDefaults setObject:portNumber
                          forKey:StatusThingPreferencePortNumber];
    
    [self.notificationCenter postNotificationName:StatusThingNetworkConfigurationChangedNotification
                                           object:nil];
}

- (IBAction)toggleLaunchOnLogin:(NSButton *)sender
{
    [self.userDefaults setBool:sender.state
                        forKey:StatusThingPreferenceLaunchOnLogin];
}

- (IBAction)foregroundColorSelected:(NSColorWell *)sender
{
    self.exampleStatusView.foreground.strokeColor = [sender.color CGColor];
}

- (IBAction)backgroundColorSelected:(NSColorWell *)sender
{
    self.exampleStatusView.background.fillColor = [sender.color CGColor];
}

- (IBAction)textColorSelected:(NSColorWell *)sender
{
    self.exampleStatusView.text.foregroundColor = [sender.color CGColor];
}

- (IBAction)didPushSave:(NSButton *)sender
{
    // get configuration dictionary from exampleStatusView and save it
    // with the key StatusThingPreferencesStatusViewDictionary since
    // we have been updating the state of exampleStatusView

    [self.userDefaults setObject:[self.exampleStatusView currentConfiguration]
                          forKey:StatusThingPreferenceStatusViewDictionary];
    
    [self.notificationCenter postNotificationName:StatusThingIdleConfigurationChangedNotification
                                           object:nil];
}

- (IBAction)didPushReset:(NSButton *)sender
{
    [self.userDefaults synchronize];
    
    NSLog(@"didPushReset:%@",[self.userDefaults dictionaryForKey:StatusThingPreferenceStatusViewDictionary]);
    [self.exampleStatusView updateWithDictionary:[self.userDefaults dictionaryForKey:StatusThingPreferenceStatusViewDictionary]];
    
    [self.exampleStatusView removeAllAnimations];
    
    [self.shapeComboxBox selectItemWithObjectValue:self.exampleStatusView.shape];
    
    [self.backgroundColorWell setColor:[NSColor colorWithCGColor:self.exampleStatusView.background.fillColor]];
    [self.foregroundColorWell setColor:[NSColor colorWithCGColor:self.exampleStatusView.foreground.strokeColor]];
    [self.textColorWell       setColor:[NSColor colorWithCGColor:self.exampleStatusView.text.foregroundColor]];
    
    [self.backgroundHiddenButton setState:self.exampleStatusView.background.hidden];
    [self.foregroundHiddenButton setState:self.exampleStatusView.foreground.hidden];
    [self.textHiddenButton       setState:self.exampleStatusView.text.hidden];
    
    [self.inputResultField setStringValue:@"Ok"];
    [self.inputResultField setStringValue:@""];
}

- (IBAction)didEnterText:(NSTextField *)sender
{

    NSError *error = nil;
    
    id obj = [NSJSONSerialization JSONObjectWithData:[sender.stringValue dataUsingEncoding:NSUTF8StringEncoding]
                                             options:0
                                               error:&error];
    
    [self.inputResultField setStringValue:(error)?error.localizedFailureReason:@"OK"];

    if ([obj isKindOfClass:NSDictionary.class]) {
        [self.exampleStatusView updateWithDictionary:obj];
    }
    else {
        [self.inputResultField setStringValue:@"Expecting a JSON formated dictionary."];
    }
    
    
}

#pragma mark - NSWindowDelegate Methods

- (void)windowWillClose:(NSNotification *)notification
{
    [[NSColorPanel sharedColorPanel] close];
}

@end
