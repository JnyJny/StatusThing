//
//  PreferencesWindowController.m
//  StatusThing
//
//  Created by Erik on 5/2/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "PreferencesWindowController.h"
#import "NSColor+NamedColorUtilities.h"
#import "StatusThingUtilities.h"
#import "ShapeFactory.h"


@interface PreferencesWindowController ()

@end


@implementation PreferencesWindowController


- (void)awakeFromNib
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [self.window setLevel:NSModalPanelWindowLevel];
    
    [self.exampleView addSubview:self.exampleStatusView];
    
    [self.exampleStatusView centerInRect:self.exampleView.bounds];
    
    [self.shapeComboxBox addItemsWithObjectValues:[ShapeFactory allShapes]];

    [self didPushReset:nil];
    
    NSString *keyPath = [StatusThingPreferencesDomain stringByAppendingFormat:@".%@",StatusThingPreferenceAllowRemoteConnections];
    NSLog(@"key %@ val %@",keyPath,[userDefaults valueForKeyPath:keyPath]);
    NSLog(@"%@",userDefaults.dictionaryRepresentation);
    
    //[self.allowRemoteConnectionsButton setState:[userDefaults valueForKeyPath:StatusThingPreferenceAllowRemoteConnections]];


    [self.allowAnimationsButton setState:[[StatusThingUtilities preferenceForKey:StatusThingPreferenceAllowAnimations] boolValue]];
     
    
    [self.useBonjourButton setState:[[StatusThingUtilities preferenceForKey:StatusThingPreferenceUseBonjour] boolValue]];

    self.staticPortNumberTextField.enabled = !self.useBonjourButton.state;

    [self.staticPortNumberTextField setStringValue:[[StatusThingUtilities preferenceForKey:StatusThingPreferencePortNumber] stringValue]];
    
    [self.launchOnLoginButton setState:[[StatusThingUtilities preferenceForKey:StatusThingPreferenceLaunchOnLogin] boolValue]];
                                         

}



- (StatusView *)exampleStatusView
{
    if (!_exampleStatusView) {
        _exampleStatusView = [[StatusView alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    }
    return _exampleStatusView;
}

- (IBAction)showWindow:(id)sender
{
    [self.window makeKeyAndOrderFront:sender];
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

}

- (IBAction)toggleAllowAnimations:(NSButton *)sender
{

}

- (IBAction)toggleUseBonjour:(NSButton *)sender
{

}


- (IBAction)portNumberUpdated:(NSTextField *)sender
{

}

- (IBAction)toggleLaunchOnLogin:(NSButton *)sender
{
    
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
    
}

- (IBAction)didPushReset:(NSButton *)sender
{
    [self.exampleStatusView updateWithDictionary:[StatusThingUtilities preferenceForKey:@"statusView"]];
                                                  
    
    [self.shapeComboxBox selectItemWithObjectValue:[StatusThingUtilities preferenceForKey:@"statusView.shape"]];
    
    [self.backgroundColorWell setColor:[NSColor colorForObject:[StatusThingUtilities preferenceForKey:@"statusView.background.fill"]]];
    [self.foregroundColorWell setColor:[NSColor colorForObject:[StatusThingUtilities preferenceForKey:@"statusView.foreground.stroke"]]];
    [self.textColorWell setColor:[NSColor colorForObject:[StatusThingUtilities preferenceForKey:@"statusView.text.foreground"]]];
    
    

    [self.backgroundHiddenButton setState:[[StatusThingUtilities preferenceForKey:@"statusView.background.hidden"] boolValue]];

    [self.foregroundHiddenButton setState:[[StatusThingUtilities preferenceForKey:@"statusView.foreground.hidden"] boolValue]];
    
    [self.textHiddenButton setState:[[StatusThingUtilities preferenceForKey:@"statusView.text.hidden"] boolValue]];
    
}

#pragma mark - NSWindowDelegate Methods

- (void)windowWillClose:(NSNotification *)notification
{

    
}

@end
