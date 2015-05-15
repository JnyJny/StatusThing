//
//  StatusController.h
//  StatusThing
//
//  Created by Erik on 4/16/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "StatusListener.h"
#import "StatusView.h"

// XXX these probably don't need to be visible outside this module
extern NSString * const ResponseTextNoMessage;
extern NSString * const ResponseTextWelcome;
extern NSString * const ResponseTextGoodbye;
extern NSString * const ResponseTextOk;
extern NSString * const ResponseTextErrorFormat;
extern NSString * const ResponseTextNoHelpText;
extern NSString * const ResponseTextResetUnavilable;
extern NSString * const ResponseTextDelegateError;
extern NSString * const ResponseTextUnknownContainerFormat;

@interface StatusController : NSObject <StatusListenerDelegate>

@property (strong,nonatomic) IBOutlet NSMenu     *statusMenu;
@property (strong,nonatomic) IBOutlet NSMenuItem *portMenuItem;
@property (strong,nonatomic) IBOutlet NSMenuItem *messagesMenuItem;
@property (strong,nonatomic) IBOutlet NSMenu     *messagesMenu;
@property (strong,nonatomic) IBOutlet NSMenuItem *clearMessagesItem;

@property (strong,nonatomic) NSStatusItem        *statusItem;
@property (strong,nonatomic) StatusView          *statusView;
@property (strong,nonatomic) StatusListener      *statusListener;



- (void)start;
- (void)stop;


@end
