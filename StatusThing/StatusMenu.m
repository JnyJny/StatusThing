//
//  StatusMenu.m
//  StatusThing
//
//  Created by Erik on 4/16/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "StatusMenu.h"
#import "Konstants.h"

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
        [self insertItem:[[NSMenuItem alloc] initWithTitle:@"Messages"
                                                    action:nil
                                             keyEquivalent:@""] atIndex:0];
        [self setSubmenu:self.messageSubmenu forItem:[self itemAtIndex:0]];
        
        [self insertItem:[NSMenuItem separatorItem] atIndex:1];
        [self insertItem:self.portItem atIndex:2];
        [self insertItem:[NSMenuItem separatorItem] atIndex:3];
        [self addItemWithTitle:@"Preferences" action:nil keyEquivalent:@""];
        [self insertItem:[NSMenuItem separatorItem] atIndex:5];
        [self addItemWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@""];
    }
    return self;
}


- (NSMenu *)messageSubmenu
{
    if( _messageSubmenu == nil ) {
        _messageSubmenu = [[NSMenu alloc] initWithTitle:@"Messages"];
    }
    return _messageSubmenu;
}

- (void)setPort:(NSNumber *)port
{
    _port = port;
    [self.portItem setTitle:[NSString stringWithFormat:@"TCP Port %@",_port]];
}

- (NSMenuItem *)portItem
{
    if( _portItem == nil ) {
        NSString *title = [NSString stringWithFormat:@"TCP Port %@",self.port];
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

@end
