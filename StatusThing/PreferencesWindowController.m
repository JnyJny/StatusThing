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
@end


@implementation PreferencesWindowController


- (void)awakeFromNib
{
    
    //[self.window setLevel:NSModalPanelWindowLevel];
    
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
    if (self.window.isVisible) {
        [super showWindow:sender];
        return;
    }
    
    [self didPushReset:nil];
    
    [self.allowRemoteConnectionsButton setState:[self.userDefaults boolForKey:StatusThingPreferenceAllowRemoteConnections]];
    [self.allowAnimationsButton        setState:[self.userDefaults boolForKey:StatusThingPreferenceAllowAnimations]];
    [self.useBonjourButton             setState:[self.userDefaults boolForKey:StatusThingPreferenceUseBonjour]];
    [self.launchOnLoginButton          setState:[self.userDefaults boolForKey:StatusThingPreferenceLaunchOnLogin]];
    [self.staticPortNumberTextField    setEnabled:!self.useBonjourButton.state];
    [self.staticPortNumberTextField    setIntegerValue:[self.userDefaults integerForKey:StatusThingPreferencePortNumber]];

    [super showWindow:sender];
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
}

- (IBAction)toggleUseBonjour:(NSButton *)sender
{
    [self.userDefaults setBool:sender.state
                        forKey:StatusThingPreferenceUseBonjour];
    [self.staticPortNumberTextField setEnabled:!sender.state];

}

- (IBAction)portNumberUpdated:(NSTextField *)sender
{
    [self.userDefaults setInteger:sender.integerValue
                           forKey:StatusThingPreferencePortNumber];
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
}

- (IBAction)didPushReset:(NSButton *)sender
{
    [self.userDefaults synchronize];
    
    //NSLog(@"didPushReset:%@",[self.userDefaults dictionaryForKey:StatusThingPreferenceStatusViewDictionary]);
    [self.exampleStatusView updateWithDictionary:[self.userDefaults dictionaryForKey:StatusThingPreferenceStatusViewDictionary]];
    
    [self.shapeComboxBox selectItemWithObjectValue:self.exampleStatusView.shape];
    
    [self.backgroundColorWell setColor:[NSColor colorWithCGColor:self.exampleStatusView.background.fillColor]];
    [self.foregroundColorWell setColor:[NSColor colorWithCGColor:self.exampleStatusView.foreground.strokeColor]];
    [self.textColorWell       setColor:[NSColor colorWithCGColor:self.exampleStatusView.text.foregroundColor]];
    
    [self.backgroundHiddenButton setState:self.exampleStatusView.background.hidden];
    [self.foregroundHiddenButton setState:self.exampleStatusView.foreground.hidden];
    [self.textHiddenButton       setState:self.exampleStatusView.text.hidden];
}

#pragma mark - NSWindowDelegate Methods

- (void)windowWillClose:(NSNotification *)notification
{
    [[NSColorPanel sharedColorPanel] close];

}

@end
