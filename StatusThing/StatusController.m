//
//  StatusController.m
//  StatusThing
//
//  Created by Erik on 4/16/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "StatusController.h"
#import <Foundation/Foundation.h>
#import "NSColor+NamedColorUtilities.h"
#import "PreferencesWindowController.h"
#import "StatusThingUtilities.h"

#pragma mark - String Constants

#pragma mark - Private
static NSString *const StatusThingStatusView        = @"statusView";
static NSString *const PortMenuItemTitleFormat      = @"     Listening On Port %hu";
static NSString *const StatusThingHelpFile          = @"HelpText";
static NSString *const LocalHostIPv4                = @"127.0.0.1";
static NSString *const LocalHostName                = @"localhost";
static NSString *const LocalHostIPv6                = @"";

#pragma mark - Public
NSString * const ResponseTextNoMessage              = @"";
NSString * const ResponseTextWelcome                = @"Connected to StatusThing\nFeed Me JSON\n> ";
NSString * const ResponseTextGoodbye                = @"\nBe seeing you space cowboy!\n";
NSString * const ResponseTextOk                     = @"Ok\n> ";
NSString * const ResponseTextErrorFormat            = @"Err: %@\n> ";
NSString * const ResponseTextNoHelpText             = @"Oops: NO HELP TEXT AVAILABLE.\n> ";
NSString * const ResponseTextResetUnavilable        = @"Oops: reset is unavailable.\n> ";
NSString * const ResponseTextDelegateError          = @"Oops: delegate error. Author sucks.\n> ";
NSString * const ResponseTextUnknownContainerFormat = @"Err: NSJSONSerialization returned something that was neither a dictionary nor an array: %@";

#pragma mark - Private Interface

@interface StatusController()
@property (strong,nonatomic) NSNotificationCenter *notificationCenter;
@property (strong,nonatomic) NSUserDefaults       *userDefaults;
@property (strong,nonatomic) NSString             *helpText;
@end



@implementation StatusController

#pragma mark - Lifecycle

- (void)awakeFromNib
{
    [self.statusItem setMenu:self.statusMenu];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.statusListener setDelegate:self];
        self.statusItem.highlightMode = YES;
        [self.statusItem.button addSubview:self.statusView];
        [self.statusView centerInRect:self.statusItem.button.bounds];
        [self updateWithDictionary:[NSUserDefaults standardUserDefaults].dictionaryRepresentation];
    }

    return self;
}


#pragma mark - Implementation Private Properties


- (NSStatusItem *)statusItem
{
    if (!_statusItem) {
        _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    }
    return _statusItem;
}

#pragma mark - Public Properties


- (StatusView *)statusView
{
    if (!_statusView) {
        _statusView = [[StatusView alloc] init];
    }
    return _statusView;
}

- (StatusListener *)statusListener
{
    if (!_statusListener) {
        _statusListener = [[StatusListener alloc] init];

    }
    return _statusListener;
}

- (NSNotificationCenter *)notificationCenter
{
    if (!_notificationCenter) {
        _notificationCenter = [NSNotificationCenter defaultCenter];
    }
    return _notificationCenter;
}

- (NSUserDefaults *)userDefaults
{
    if (!_userDefaults) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    [_userDefaults synchronize];
    return _userDefaults;
}

- (NSString *)helpText
{
    if (!_helpText) {
        NSError *error;
        NSString *helpTextPath = [[NSBundle mainBundle] pathForResource:StatusThingHelpFile
                                                                 ofType:StatusThingPlistFileExtension];;
        _helpText = [NSString stringWithContentsOfFile:helpTextPath
                                              encoding:NSUTF8StringEncoding
                                                 error:&error];
        
        if (error) {
            _helpText = ResponseTextNoHelpText;
        }
    }
    return _helpText;
}

#pragma mark - Methods

- (void)start
{
    [self.statusListener start];
    NSLog(@"listening on port %u",self.statusListener.port);
    
    [self.portMenuItem setTitle:[NSString stringWithFormat:PortMenuItemTitleFormat,self.statusListener.port]];

    [self.notificationCenter addObserver:self
                                selector:@selector(resetToIdleAppearance:)
                                    name:StatusThingIdleConfigurationChangedNotification
                                  object:nil];
    
    [self.notificationCenter addObserver:self
                                selector:@selector(restartStatusListner:)
                                    name:StatusThingNetworkConfigurationChangedNotification
                                  object:nil];

}

- (void)stop
{
    [self.notificationCenter removeObserver:self];
    
    [[NSStatusBar systemStatusBar] removeStatusItem:self.statusItem];
    [self.statusListener stop];
}

#pragma mark - IBAction Methods
// resetToIdleAppearance: does double duty as an IBAction and a notificationCenter callback

- (IBAction)resetToIdleAppearance:(id)sender
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [self.statusView removeAllAnimations];
    [self.statusView updateWithDictionary:[userDefaults dictionaryForKey:StatusThingPreferenceStatusViewDictionary]];
}

#pragma mark - StatusThing Notification Handling Methods

- (void)restartStatusListner:(NSNotification *)note
{
    
    [self.notificationCenter removeObserver:self];
    
    [self start];
}


#pragma mark - StatusListenerDelegate Methods

- (NSDictionary *)clientDidConnect:(NSDictionary *)request
{
    if (!request) {
        return nil;
    }

    
    if (![self.userDefaults boolForKey:StatusThingPreferenceAllowRemoteConnections]) {
        NSString *remoteAddress = request[RequestKeyAddress];
        if ( ![remoteAddress isEqualToString:LocalHostIPv4] ||
            ![remoteAddress isEqualToString:LocalHostName] ) {
            // XXX terse reply to keep from leaking info?
            return @{ ResponseKeyAction:ResponseActionDone,
                      ResponseKeyText:ResponseTextNoMessage };
            // NOTREACHED
        }
    }
    
    return @{ ResponseKeyAction:ResponseActionOk,
              ResponseKeyText:ResponseTextWelcome };
}

- (NSDictionary *)processRequest:(NSDictionary *)request
{
    NSDictionary *response = nil;
    NSData  *data = request[RequestKeyContent];
    NSError *error;
    char firstByte;
    id obj;
    
    if(!data ||
       data.length == 0) {
        firstByte = 'q';
    }

    [data getBytes:&firstByte length:sizeof(firstByte)];
    
    switch (firstByte) {
        case 0x4:
            // control-d
        case 'q':
        case 'Q':
            // quit
            response = @{ ResponseKeyAction:ResponseActionDone,
                          ResponseKeyText:ResponseTextNoMessage };
            break;
            
        case 'g':
        case 'G':
            // get configuration
            break;
        case 'h':
        case 'H':
            // send help
            response = @{ ResponseKeyAction:ResponseActionDone,
                          ResponseKeyText:self.helpText };
            break;
        case 'r':
        case 'R':
            // reset to idle
            break;
        default:
            obj = [NSJSONSerialization JSONObjectWithData:data
                                                  options:0
                                                    error:&error];
            
            if (error) {
                NSString *errorText = [NSString stringWithFormat:ResponseTextErrorFormat,error.localizedFailureReason];
                response = @{ ResponseKeyAction:ResponseActionOk,
                              ResponseKeyText:errorText };
                break;
            }
            
            if ([obj isKindOfClass:NSDictionary.class]) {
                [self.statusView updateWithDictionary:obj];
                response= @{ ResponseKeyAction:ResponseActionOk,
                             ResponseKeyText:ResponseTextOk };
            }
            else {
                // another error case
                response = @{ ResponseKeyAction:ResponseActionOk,
                              ResponseKeyText:@"unknown error. Sorry.\n> " };
            }
            
            break;
    }
    
    return response;
}

- (void)updateWithDictionary:(NSDictionary *)info
{

    [info enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        if ( [key isEqualToString:StatusThingPreferenceStatusViewDictionary]) {
            [self.statusView updateWithDictionary:obj];
        }
    }];
}

@end
