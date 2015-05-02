//
//  StatusMenu.m
//  StatusThing
//
//  Created by Erik on 4/16/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "StatusMenu.h"

static NSString * const MessagesMenuItemTitle      = @"Messages";
static NSString * const PreferencesMenuItemTitle   = @"Preferences";
static NSString * const ClearMessagesMenuItemTitle = @"Clear";
static NSString * const QuitMenuItemTitle          = @"Quit";
static NSString * const PortNumberFormat           = @"TCP Port %@";

@interface StatusMenu()

@property (strong,nonatomic ) NSMutableArray *messages;
@property (strong, nonatomic) NSMenuItem     *portItem;

@end

@implementation StatusMenu

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.port = @0;
        [self insertItem:[[NSMenuItem alloc] initWithTitle:MessagesMenuItemTitle
                                                    action:nil
                                             keyEquivalent:@""] atIndex:0];

        [self setSubmenu:self.messageSubmenu forItem:[self itemAtIndex:0]];
        
        [self insertItem:[NSMenuItem separatorItem] atIndex:1];
        [self insertItem:self.portItem atIndex:2];
        [self insertItem:[NSMenuItem separatorItem] atIndex:3];
        [self addItemWithTitle:PreferencesMenuItemTitle
                        action:nil
                 keyEquivalent:@""];
        [self insertItem:[NSMenuItem separatorItem] atIndex:5];
        [self addItemWithTitle:QuitMenuItemTitle
                        action:@selector(terminate:)
                 keyEquivalent:@""];
    }
    return self;
}


- (NSMenu *)messageSubmenu
{
    if (!_messageSubmenu) {
        _messageSubmenu = [[NSMenu alloc] initWithTitle:MessagesMenuItemTitle];
    }
    return _messageSubmenu;
}



- (void)setPort:(NSNumber *)port
{
    _port = port;
    [self.portItem setTitle:[NSString stringWithFormat:PortNumberFormat,_port]];
}

- (NSMenuItem *)portItem
{
    if(!_portItem) {
        NSString *title = [NSString stringWithFormat:PortNumberFormat,self.port];
        _portItem = [[NSMenuItem alloc] initWithTitle:title
                                                   action:nil
                                            keyEquivalent:@""];
    }
    return _portItem;
}

- (void)setMessage:(NSString *)message
{
    // add a message to the message menu
}

- (void)updateWithDictionary:(NSDictionary *)info
{
    [info enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {

    }];
}

@end
