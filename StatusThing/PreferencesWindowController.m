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
@property (strong,nonatomic  ) NSUserDefaults       *userDefaults;
@property (strong,nonatomic  ) NSNotificationCenter *notificationCenter;
@property (strong,nonatomic  ) NSMutableDictionary  *animationSpeeds;
@property (strong,nonatomic  ) StatusView           *exampleStatusView;
@property (strong,nonatomic  ) NSFontManager        *fontManager;

@end


@implementation PreferencesWindowController


- (void)awakeFromNib
{
    [self.exampleView addSubview:self.exampleStatusView];
    
}

- (void)initializePreferencesSettings
{

    [self.backgroundShapeList addItemsWithTitles:[ShapeFactory allShapes]];
    [self.foregroundShapeList addItemsWithTitles:[ShapeFactory allShapes]];
    
    [self.textFontList addItemsWithTitles:[self.fontManager availableFonts]];
    
    [self.staticPortNumberTextField setIntegerValue:[self.userDefaults integerForKey:StatusThingPreferencePortNumber]];
    
    [self.allowAnimationsButton setState:[self.userDefaults boolForKey:StatusThingPreferenceAllowAnimations]];
    [self.allowMessagesButton setState:[self.userDefaults boolForKey:StatusThingPreferenceAllowMessages]];
    [self.allowRemoteConnectionsButton setState:[self.userDefaults boolForKey:StatusThingPreferenceAllowRemoteConnections]];
    
    [self.fastestField setFloatValue:[self.animationSpeeds[StatusThingAnimationSpeedKeyFastest] floatValue]];
    [self.fasterField setFloatValue:[self.animationSpeeds[StatusThingAnimationSpeedKeyFaster] floatValue]];
    [self.fastField setFloatValue:[self.animationSpeeds[StatusThingAnimationSpeedKeyFast] floatValue]];
    [self.normalField setFloatValue:[self.animationSpeeds[StatusThingAnimationSpeedKeyNormal] floatValue]];
    [self.slowField setFloatValue:[self.animationSpeeds[StatusThingAnimationSpeedKeySlow] floatValue]];
    [self.slowerField setFloatValue:[self.animationSpeeds[StatusThingAnimationSpeedKeySlower] floatValue]];
    [self.slowestField setFloatValue:[self.animationSpeeds[StatusThingAnimationSpeedKeySlowest] floatValue]];
}

- (void)initializePreferencesAppearance
{
    [self.exampleStatusView updateWithDictionary:[self.userDefaults objectForKey:StatusThingPreferenceStatusViewDictionary]];
    
    [self.backgroundHiddenToggle setState:!self.exampleStatusView.background.hidden];
    [self.backgroundShapeList setTitle:self.exampleStatusView.backgroundShape];
    [self.backgroundFillColor setColor:[NSColor colorWithCGColor:self.exampleStatusView.background.fillColor]];
    [self.backgroundStrokeColor setColor:[NSColor colorWithCGColor:self.exampleStatusView.background.strokeColor]];
    [self.backgroundLineWidthField setFloatValue:self.exampleStatusView.background.lineWidth];
    [self.backgroundLineWidthStepper setFloatValue:self.exampleStatusView.background.lineWidth];
    
    [self.foregroundHiddenToggle setState:!self.exampleStatusView.foreground.hidden];
    [self.foregroundShapeList setTitle:self.exampleStatusView.foregroundShape];
    [self.foregroundFillColor setColor:[NSColor colorWithCGColor:self.exampleStatusView.foreground.fillColor]];
    [self.foregroundStrokeColor setColor:[NSColor colorWithCGColor:self.exampleStatusView.foreground.strokeColor]];
    [self.foregroundLineWidthField setFloatValue:self.exampleStatusView.foreground.lineWidth];
    [self.foregroundLineWidthStepper setFloatValue:self.exampleStatusView.foreground.lineWidth];
    
    [self.textHiddenToggle setState:!self.exampleStatusView.text.hidden];
    [self.textForegroundColor setColor:[NSColor colorWithCGColor:self.exampleStatusView.text.foregroundColor]];

    [self.textStringField setStringValue:self.exampleStatusView.text.string];
    [self.textFontSizeField setFloatValue:self.exampleStatusView.text.fontSize];
    [self.textFontSizeStepper setFloatValue:self.exampleStatusView.text.fontSize];
    [self.textFontList setTitle:self.exampleStatusView.text.font];

    
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

- (NSFontManager *)fontManager
{
    if (!_fontManager) {
        _fontManager = [NSFontManager sharedFontManager];
    }
    return _fontManager;
}

- (NSMutableDictionary *)animationSpeeds
{
    if (!_animationSpeeds) {
        _animationSpeeds = [NSMutableDictionary dictionaryWithDictionary:[StatusThingUtilities speeds]];
    }
    return _animationSpeeds;
}

- (StatusView *)exampleStatusView
{
    if (!_exampleStatusView) {
        
        CGFloat n = MIN(CGRectGetWidth(self.exampleView.bounds),
                        CGRectGetHeight(self.exampleView.bounds));
        
        _exampleStatusView = [[StatusView alloc] initWithFrame:self.exampleView.bounds];
        //        [_exampleStatusView centerInRect:self.exampleView.bounds];
        
        _exampleStatusView.insetDelta = (n - 22.)/2;
        
        _exampleStatusView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    }

    return _exampleStatusView;
}

#pragma mark - IBAction Methods

- (IBAction)showWindow:(id)sender
{

    [self initializePreferencesSettings];
    [self initializePreferencesAppearance];
    
    CATransform3D t = CATransform3DScale(self.exampleStatusView.layer.transform, 5, 5, 0);
    
    //    self.exampleStatusView.layer.transform = t;
    self.exampleStatusView.layer.sublayerTransform = t;
    
    [[NSColorPanel sharedColorPanel] setShowsAlpha:YES];
    [NSColor setIgnoresAlpha:NO];
    
    // NSModalPaneWindowLevel forces the window up to the top if it's visible but buried
    // check against isOccluded?
    [self.window setLevel:NSModalPanelWindowLevel];
    [self.window makeKeyAndOrderFront:sender];
    [self.window setLevel:NSNormalWindowLevel];

}




- (IBAction)toggleDidChange:(NSButton *)sender
{
    if (sender == self.allowAnimationsButton) {
        [self.userDefaults setBool:sender.state
                            forKey:StatusThingPreferenceAllowAnimations];
        
        [self.notificationCenter postNotificationName:StatusThingAnimationPreferenceChangedNotification
                                               object:nil];
        return;
        // NOTREACHED
    }
    
    if (sender == self.allowMessagesButton) {
        [self.userDefaults setBool:sender.state
                            forKey:StatusThingPreferenceAllowMessages];
        [self.notificationCenter postNotificationName:StatusThingMessagingPreferenceChangedNotification
                                               object:nil];
        return;
        // NOTREACHED
    }
    
    if (sender == self.allowRemoteConnectionsButton) {
        [self.userDefaults setBool:sender.state
                            forKey:StatusThingPreferenceAllowRemoteConnections];
        
        [self.notificationCenter postNotificationName:StatusThingRemoteAccessPreferenceChangedNotification
                                               object:nil];
        return;
        // NOTREACHED
    }
    
    if (sender == self.launchOnLoginButton) {
        
        [self.userDefaults setBool:sender.state
                            forKey:StatusThingPreferenceLaunchOnLogin];
        
        if (sender.state) {
            [StatusThingUtilities enableLoginItemForBundle:nil];
        }
        else {
            [StatusThingUtilities disableLoginItemForBundle:nil];
        }
        
        return;
        // NOTREACHED
    }
    
    if (sender == self.toggleShapeLock) {
        if (sender.state) {
            [self popUpDidChange:self.backgroundShapeList];
        }
        return;
        // NOTREACHED
    }
    
    if (sender == self.backgroundHiddenToggle) {
        [self.exampleStatusView.background setHidden:!sender.state];
        return;
        // NOTREACHED
    }
    
    if (sender == self.foregroundHiddenToggle) {
        [self.exampleStatusView.foreground setHidden:!sender.state];
        return;
        // NOTREACHED
    }
    
    if (sender == self.textHiddenToggle) {
        [self.exampleStatusView.text setHidden:!sender.state];
        return;
        // NOTREACHED
    }
    
    
}

- (IBAction)numberFieldDidChange:(NSTextField *)sender
{
    
    NSNumber *value = [NSNumber numberWithFloat:sender.floatValue];
    
    if (sender == self.staticPortNumberTextField) {
        value = [NSNumber numberWithUnsignedShort:sender.integerValue];
        [self.userDefaults setObject:value forKey:StatusThingPreferencePortNumber];
        [self.notificationCenter postNotificationName:StatusThingNetworkConfigurationChangedNotification
                                               object:nil];
        return;
        //NOTREACHED
    }
    
    if (sender == self.fastestField) {
        [self.fastestStepper setFloatValue:sender.floatValue];
        self.animationSpeeds[StatusThingAnimationSpeedKeyFastest] = value;
        return;
        //NOTREACHED
    }
    
    if (sender == self.fasterField) {
        [self.fasterStepper setFloatValue:sender.floatValue];
        self.animationSpeeds[StatusThingAnimationSpeedKeyFaster] = value;
        return;
        //NOTREACHED
    }
    
    if (sender == self.fastField) {
        [self.fastStepper setFloatValue:sender.floatValue];
        self.animationSpeeds[StatusThingAnimationSpeedKeyFast] = value;
        return;
        //NOTREACHED
    }
    
    if (sender == self.normalField) {
        [self.normalStepper setFloatValue:sender.floatValue];
        self.animationSpeeds[StatusThingAnimationSpeedKeyNormal] = value;
        return;
        //NOTREACHED
    }
    
    if (sender == self.slowField) {
        [self.slowStepper setFloatValue:sender.floatValue];
        self.animationSpeeds[StatusThingAnimationSpeedKeySlow] = value;
        return;
        //NOTREACHED
    }
    
    if (sender == self.slowerField) {
        [self.slowerStepper setFloatValue:sender.floatValue];
        self.animationSpeeds[StatusThingAnimationSpeedKeySlower] = value;
        return;
        //NOTREACHED
    }
    
    if (sender == self.slowestField) {
        [self.slowestStepper setFloatValue:sender.floatValue];
        self.animationSpeeds[StatusThingAnimationSpeedKeySlowest] = value;
        return;
        //NOTREACHED
    }
    
    if (sender == self.backgroundLineWidthField) {
        [self.backgroundLineWidthStepper setFloatValue:sender.floatValue];
        [self.exampleStatusView.background setLineWidth:sender.floatValue];
        return;
        //NOTREACHED
    }
    
    if (sender == self.foregroundLineWidthField) {
        [self.foregroundLineWidthStepper setFloatValue:sender.floatValue];
        [self.exampleStatusView.foreground setLineWidth:sender.floatValue];
        return;
        //NOTREACHED
    }
    
    if (sender == self.textFontSizeField) {
        [self.textFontSizeStepper setFloatValue:sender.floatValue];
        [self.exampleStatusView.text setFontSize:sender.floatValue];
        return;
        //NOTREACHED
    }
    
}


- (IBAction)stepperDidChangeValue:(NSStepper *)sender
{
    
    NSNumber *value = [NSNumber numberWithFloat:sender.floatValue];
    
    if (sender == self.fastestStepper) {
        [self.fastestField setFloatValue:sender.floatValue];
        self.animationSpeeds[StatusThingAnimationSpeedKeyFastest] = value;
    }
    
    if (sender == self.fasterStepper) {
        [self.fasterField setFloatValue:sender.floatValue];
        self.animationSpeeds[StatusThingAnimationSpeedKeyFaster] = value;
    }
    
    if (sender == self.fastStepper) {
        [self.fastField setFloatValue:sender.floatValue];
        self.animationSpeeds[StatusThingAnimationSpeedKeyFast] = value;
    }
    
    if (sender == self.normalStepper) {
        [self.normalField setFloatValue:sender.floatValue];
        self.animationSpeeds[StatusThingAnimationSpeedKeyNormal] = value;
    }
    
    if (sender == self.slowStepper) {
        [self.slowField setFloatValue:sender.floatValue];
        self.animationSpeeds[StatusThingAnimationSpeedKeySlow] = value;
    }
    
    if (sender == self.slowerStepper) {
        [self.slowerField setFloatValue:sender.floatValue];
        self.animationSpeeds[StatusThingAnimationSpeedKeySlower] = value;
    }
    
    if (sender == self.slowestStepper) {
        [self.slowestField setFloatValue:sender.floatValue];
        self.animationSpeeds[StatusThingAnimationSpeedKeySlowest] = value;
    }
    
    if (sender == self.backgroundLineWidthStepper) {
        [self.backgroundLineWidthField setFloatValue:sender.floatValue];
        [self.exampleStatusView.background setLineWidth:sender.floatValue];
    }
    
    if (sender == self.foregroundLineWidthStepper) {
        [self.foregroundLineWidthField setFloatValue:sender.floatValue];
        [self.exampleStatusView.foreground setLineWidth:sender.floatValue];
    }
    
    if (sender == self.textFontSizeStepper) {
        [self.textFontSizeField setFloatValue:sender.floatValue];
        [self.exampleStatusView.text setFontSize:sender.floatValue];
    }
    
}

- (IBAction)didPushButton:(NSButton *)sender
{
    if (sender == self.restoreAnimationSpeeds) {
        _animationSpeeds = nil;
        [self initializePreferencesSettings];
    }
    
    if (sender == self.saveAnimationSpeeds) {
        [self.userDefaults setObject:self.animationSpeeds forKey:StatusThingPreferenceAnimationSpeeds];
    }
    
    if (sender == self.resetButton) {
        // reset the exampleStatusView
        [self initializePreferencesAppearance];
    }
    
    if (sender == self.acceptButton) {
        // save the exampleStatusView configuration as default settings
        [self.userDefaults setObject:self.exampleStatusView.currentConfiguration
                              forKey:StatusThingPreferenceStatusViewDictionary];
        [self.notificationCenter postNotificationName:StatusThingIdleConfigurationChangedNotification
                                               object:nil];
    }
    
}

- (IBAction)popUpDidChange:(NSPopUpButton *)sender
{
    [sender setTitle:sender.selectedItem.title];
    
    if ((sender == self.backgroundShapeList) ||
        (sender == self.foregroundShapeList)) {
        
        if (self.toggleShapeLock.state) {
            [self.backgroundShapeList setTitle:sender.selectedItem.title];
            [self.foregroundShapeList setTitle:sender.selectedItem.title];
        }
        [self.exampleStatusView setForegroundShape:self.foregroundShapeList.selectedItem.title];
        [self.exampleStatusView setBackgroundShape:self.backgroundShapeList.selectedItem.title];
        return;
        // NOTREACHED
    }
    
    if (sender == self.textFontList) {
        [self.exampleStatusView.text setFont:(__bridge CFTypeRef)(sender.selectedItem.title)];
        return;
        // NOTREACHED
    }
    
}

- (IBAction)didEnterText:(NSTextField *)sender
{

    if (sender == self.inputTextField) {
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
        
        return;
        // NOTREACHED
    }
    
    if (sender == self.textStringField) {
        [self.exampleStatusView.text setString:sender.stringValue];
        return;
        // NOTREACHED
    }
}


- (IBAction)colorWellDidChange:(NSColorWell *)sender
{
    
    CGColorRef cgColor = [sender.color CGColor];
    
    if (sender == self.backgroundFillColor) {
        self.exampleStatusView.background.fillColor = cgColor;
        return;
        // NOTREACHED
    }
    
    if (sender == self.backgroundStrokeColor) {
        self.exampleStatusView.background.strokeColor = cgColor;
        return;
        // NOTREACHED
    }
    
    if (sender == self.foregroundFillColor) {
        self.exampleStatusView.foreground.fillColor = cgColor;
        return;
        // NOTREACHED

    }
    
    if (sender == self.foregroundStrokeColor) {
        self.exampleStatusView.foreground.strokeColor = cgColor;
        return;
        // NOTREACHED

    }
    
    if (sender == self.textForegroundColor) {
        self.exampleStatusView.text.foregroundColor = cgColor;
        return;
        // NOTREACHED
    }
    
}

#pragma mark - NSWindowDelegate Methods

- (void)windowWillClose:(NSNotification *)notification
{
    [[NSColorPanel sharedColorPanel] close];
}

@end
