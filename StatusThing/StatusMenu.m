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

@property (strong, nonatomic) NSNumber *port;
@property (strong, nonatomic) NSMenuItem *messageItem;
@property (strong, nonatomic) NSMenuItem *portItem;

@end

@implementation StatusMenu

- (instancetype)initWithPort:(NSNumber *)port andMessage:(NSString *)message
{
    self = [super init];
    if (self) {
        self.port = port;
        self.message = message;

        [self insertItem:self.messageItem atIndex:0];
        [self insertItem:[NSMenuItem separatorItem] atIndex:1];
        [self insertItem:self.portItem atIndex:2];
        [self insertItem:[NSMenuItem separatorItem] atIndex:3];
        [self addItemWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@""];

    }
    return self;
}

- (instancetype)initWithPort:(NSNumber *)port
{
    return [self initWithPort:port andMessage:nil];
}

- (NSMenuItem *)messageItem
{
    if( _messageItem == nil ) {
        _messageItem = [[NSMenuItem alloc] initWithTitle:kDefaultMessage
                                                  action:nil
                                           keyEquivalent:@""];
    }
    return _messageItem;
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
    [self.messageItem setTitle:message?message:kDefaultMessage];
}

@end
