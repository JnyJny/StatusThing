//
//  MessageView.m
//  StatusThing
//
//  Created by Erik on 5/14/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import "MessageView.h"

@implementation MessageView

NSString * const MessageViewNibFilename   = @"MessageView";
NSString * const MessageViewUnknown       = @"<unknown>";
NSString * const MessageViewNoBody        = @"<No Message>";

@synthesize date = _date;

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];

    if (self) {
        NSArray *topLevelObjects = nil;
        [[NSBundle mainBundle] loadNibNamed:MessageViewNibFilename owner:self topLevelObjects:&topLevelObjects];

        [topLevelObjects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:NSView.class]) {
                NSView *mv = (NSView *)obj;
                self.frame = CGRectMake(0, 0, mv.bounds.size.width, mv.bounds.size.height);
                [self addSubview:mv];
                *stop = YES;
            }
        }];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        NSArray *topLevelObjects = nil;
        [[NSBundle mainBundle] loadNibNamed:MessageViewNibFilename owner:self topLevelObjects:&topLevelObjects];
        
        [topLevelObjects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:NSView.class]) {
                NSView *mv = (NSView *)obj;
                self.frame = CGRectMake(0, 0, mv.bounds.size.width, mv.bounds.size.height);
                [self addSubview:mv];
                *stop = YES;
            }
        }];
    }
    return self;
}

#pragma mark - Properties


- (void)sentBy:(NSString *)sender fromAddress:(NSString *)address onDate:(NSDate *)date withBody:(NSString *)body
{
    self.sender = sender?sender:MessageViewUnknown;
    self.address = address?address:MessageViewUnknown;
    self.date = date;
    self.body = body;
}

- (void)setSender:(NSString *)sender
{
    [self.senderField setStringValue:sender];
}

- (NSString *)sender
{
    return self.senderField.stringValue;
}

- (void)setAddress:(NSString *)address
{
    [self.addressField setStringValue:address?address:MessageViewUnknown];
}

- (NSString *)address
{
    return self.addressField.stringValue;
}

- (void)setDate:(NSDate *)date
{
    _date = date;
    [self.dateField setStringValue:date?date.description:MessageViewUnknown];
}

- (void)setBody:(NSString *)body
{
    [self.bodyField setStringValue:body?body:MessageViewNoBody];
}

- (NSString *)body
{
    return self.bodyField.stringValue;
}

- (NSString *)csv
{
 return [NSString stringWithFormat:@"\"%@\",\"%@\",\"%@\",\"%@\"",
                self.sender,
                self.address,
                self.date.description,
                self.body];
    
}



@end
