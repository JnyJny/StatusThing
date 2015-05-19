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
#import "MessageView.h"

#pragma mark - String Constants

#pragma mark - Private
static NSString * const StatusThingKeyStatusView       = @"statusView";
static NSString * const PortMenuItemTitleFormat        = @"     Listening On Port %hu";
static NSString * const StatusThingHelpFile            = @"HelpText";
static NSString * const StatusThingHelpFileExtension   = @"";
static NSString * const LocalHostIPv4                  = @"127.0.0.1";
static NSString * const LocalHostName                  = @"localhost";
static NSString * const LocalHostIPv6                  = @"";

#pragma mark - Public

NSString * const ResponseTextPrompt                    = @"\n> ";
NSString * const ResponseTextNoMessage                 = @"";
NSString * const ResponseTextWelcome                   = @"Connected to StatusThing\nFeed Me JSON";
NSString * const ResponseTextGoodbye                   = @"\nBe seeing you space cowboy!\n";
NSString * const ResponseTextOk                        = @"Ok";
NSString * const ResponseTextErrorFormat               = @"Err: %@";
NSString * const ResponseTextNoHelpText                = @"Oops: NO HELP TEXT AVAILABLE.";
NSString * const ResponseTextResetUnavilable           = @"Oops: reset is unavailable.";
NSString * const ResponseTextDelegateError             = @"Oops: delegate error. Author sucks.";
NSString * const ResponseTextNotADictionary            = @"Err: You should send dictionaries.";
NSString * const ResponseTextConfigurationNotAvailable = @"Configuration data is not available.";
NSString * const ResponseTextCapabilitiesNotAvailable  = @"Capabilities data is not available.";

NSString * const StatusThingKeyMessage                 = @"message";
NSString * const MessageKeyFrom                        = @"from";
NSString * const MessageKeyBody                        = @"body";

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
    [self.messagesMenuItem setEnabled:NO];
    [self.clearMessagesItem setEnabled:NO];
    

    
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
        
        NSDistributedNotificationCenter *distributedNotificationCenter = [NSDistributedNotificationCenter defaultCenter];
        
        [distributedNotificationCenter addObserver:self
                                    selector:@selector(appleInterfaceThemeDidChange:)
                                        name:AppleInterfaceThemeChangedNotification
                                      object:nil];
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
                                                                 ofType:StatusThingHelpFileExtension];;
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
    // problems with defaults being available
    if (![self.userDefaults boolForKey:StatusThingPreferenceAllowMessages]) {
        [self.messagesMenuItem setHidden:YES];
        [self.clearMessagesItem setHidden:YES];
    }
    
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
    
    [self.notificationCenter addObserver:self
                                selector:@selector(messagePreferencesChanged:)
                                    name:StatusThingMessagingPreferenceChangedNotification
                                  object:nil];

}


- (void)stop
{
    [self.notificationCenter removeObserver:self];
    
    [[NSStatusBar systemStatusBar] removeStatusItem:self.statusItem];
    [self.statusListener stop];
}


- (void)appleInterfaceThemeDidChange:(NSNotification *)note
{

    NSString *interfaceStyle = [self.userDefaults valueForKey:AppleInterfaceStyle];
    
    NSArray *filters = nil;

    if (interfaceStyle && ([interfaceStyle caseInsensitiveCompare:AppleInterfaceStyleDark] == NSOrderedSame)) {
        // this crashes horribly.
        CIFilter *invertColor = [CIFilter filterWithName:@"CIColorInvert"];
        [invertColor setDefaults];
        invertColor.name = @"invertColor";
        filters = @[ invertColor ];
    }

    [self.statusView setContentFilters:filters];
}


- (void)postMessage:(NSDictionary *)msg forRequest:(NSDictionary *)request
{
    if (!msg ||
        ![msg isKindOfClass:NSDictionary.class] ||
        ![self.userDefaults boolForKey:StatusThingPreferenceAllowMessages]) {
        return;
    }
    
    NSMenuItem *msgItem = [[NSMenuItem alloc] initWithTitle:@"" action:nil keyEquivalent:@""];

    MessageView *msgView =[[MessageView alloc] initWithFrame:CGRectZero];
    
    [msgView sentBy:msg[MessageKeyFrom]
        fromAddress:request[RequestKeyAddress]
             onDate:request[RequestKeyTimestamp]
           withBody:msg[MessageKeyBody]];
    
    [msgItem setView:msgView];
    
    [self.messagesMenu insertItem:msgItem atIndex:0];
    [self.messagesMenuItem setEnabled:YES];
    [self.clearMessagesItem setEnabled:YES];
    
    [self.statusItem setToolTip:msg[MessageKeyBody]];

}

- (IBAction)clearMessages:(id)sender
{
    [self.messagesMenu removeAllItems];
    [self.messagesMenuItem setEnabled:NO];
    [self.clearMessagesItem setEnabled:NO];
    [self.statusItem setToolTip:nil];
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

- (void)messagePreferencesChanged:(NSNotification *)note
{
    if (![self.userDefaults boolForKey:StatusThingPreferenceAllowMessages]) {
        [self clearMessages:nil];
        [self.messagesMenuItem setHidden:YES];
        [self.clearMessagesItem setHidden:YES];
    }
    else {
        
        [self.messagesMenuItem setHidden:NO];
        [self.clearMessagesItem setHidden:NO];
    }
}


#pragma mark - StatusListenerDelegate Methods


- (NSData *)appendPromptTo:(id)text
{
    NSMutableData *data = [[NSMutableData alloc] init];
    
    if ([text isKindOfClass:NSString.class]) {
        [data appendData:[text dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if ([text isKindOfClass:NSData.class]) {
        [data appendData:text];
    }
    
    [data appendData:[ResponseTextPrompt dataUsingEncoding:NSUTF8StringEncoding]];
    
    return data;
}

- (NSDictionary *)clientDidConnect:(NSDictionary *)request
{
    if (!request) {
        return nil;
    }

    
    if (![self.userDefaults boolForKey:StatusThingPreferenceAllowRemoteConnections]) {
        NSString *remoteAddress = request[RequestKeyAddress];
        if ( ![remoteAddress isEqualToString:LocalHostIPv4] ||
            ![remoteAddress isEqualToString:LocalHostName] ) {
            return @{ ResponseKeyAction:ResponseActionDone,
                      ResponseKeyData:ResponseTextNoMessage };
            // NOTREACHED
        }
    }
    
    return @{ ResponseKeyAction:ResponseActionOk,
              ResponseKeyData:[self appendPromptTo:ResponseTextWelcome] };
}



- (NSDictionary *)processRequest:(NSDictionary *)request
{
    NSDictionary   *response = nil;
    NSData         *dataIn = request[RequestKeyContent];
    NSData         *dataJSON;
    NSInteger       jsonOptions = 0;
    NSError        *error;
    char            firstByte;
    id              obj;
    
    if(!dataIn ||
       dataIn.length == 0) {
        firstByte = 'q';
    }

    [dataIn getBytes:&firstByte length:sizeof(firstByte)];
    
    switch (firstByte) {
        case 0x4:
            // control-d
        case 'q':
        case 'Q':
            // quit
            response = @{ ResponseKeyAction:ResponseActionDone,
                          ResponseKeyData:[self appendPromptTo:ResponseTextNoMessage]};
            break;

        case 'G':
            jsonOptions = NSJSONWritingPrettyPrinted;
        case 'g':
            // get configuration

            // check prefs to see if it's allowed
            
            obj = [self.statusView currentConfiguration];
            
            if (![NSJSONSerialization isValidJSONObject:obj]) {
                response = @{ ResponseKeyAction:ResponseActionOk,
                              ResponseKeyData:[self appendPromptTo:ResponseTextConfigurationNotAvailable] };
                break;
            }
            
            dataJSON = [NSJSONSerialization dataWithJSONObject:obj
                                                       options:jsonOptions
                                                         error:&error];
            
            if (error) {
                NSString *errorText = [NSString stringWithFormat:ResponseTextErrorFormat,error.localizedFailureReason];
                response = @{ ResponseKeyAction:ResponseActionOk,
                              ResponseKeyData:[self appendPromptTo:errorText] };
                break;
                // NOTREACHED
            }
            
            // ok now we have data and not a string.
            response = @{ ResponseKeyAction:ResponseActionOk,
                          ResponseKeyData:[self appendPromptTo:dataJSON] };
            break;

        case 'C':
            jsonOptions = NSJSONWritingPrettyPrinted;
        case 'c':
            // capabilities, send a dictionary of shape names, animation names, filter names, speeds
            
            if (![NSJSONSerialization isValidJSONObject:self.statusView.capabilities]) {
                response = @{ ResponseKeyAction:ResponseActionOk,
                              ResponseKeyData:[self appendPromptTo:ResponseTextCapabilitiesNotAvailable]};
                break;
            }
            
            dataJSON = [NSJSONSerialization dataWithJSONObject:self.statusView.capabilities
                                                       options:jsonOptions
                                                         error:&error];
            
            if (error) {
                NSString *errorText = [NSString stringWithFormat:ResponseTextErrorFormat,error.localizedFailureReason];
                response = @{ ResponseKeyAction:ResponseActionOk,
                              ResponseKeyData:[self appendPromptTo:errorText] };
                break;
            }
            
            response = @{ ResponseKeyAction:ResponseActionOk,
                          ResponseKeyData:[self appendPromptTo:dataJSON] };

            break;
            
        case 'h':
        case 'H':
            // send help
            response = @{ ResponseKeyAction:ResponseActionOk,
                          ResponseKeyData:[self appendPromptTo:self.helpText] };
            break;
            
        case 'r':
        case 'R':
            [self.statusView removeAllAnimations];
            [self.statusView updateWithDictionary:[self.userDefaults objectForKey:StatusThingPreferenceStatusViewDictionary]];
            response = @{ResponseKeyAction:ResponseActionOk,
                         ResponseKeyData:[self appendPromptTo:ResponseTextOk] };
            
            break;
            
        default:
            obj = [NSJSONSerialization JSONObjectWithData:dataIn
                                                  options:0
                                                    error:&error];
            
            if (error) {
                NSString *errorText = [NSString stringWithFormat:ResponseTextErrorFormat,error.localizedFailureReason];
                response = @{ ResponseKeyAction:ResponseActionOk,
                              ResponseKeyData:[self appendPromptTo:errorText] };
                break;
                // NOTREACHED
            }
            
            if ([obj isKindOfClass:NSDictionary.class]) {
                [self.statusView updateWithDictionary:obj];
                [self postMessage:obj[StatusThingKeyMessage] forRequest:request];

                response= @{ ResponseKeyAction:ResponseActionOk,
                             ResponseKeyData:[self appendPromptTo:ResponseTextOk] };
            }
            else {
                response = @{ ResponseKeyAction:ResponseActionOk,
                              ResponseKeyData:[self appendPromptTo:ResponseTextNotADictionary] };
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
