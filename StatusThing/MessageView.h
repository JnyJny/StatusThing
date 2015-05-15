//
//  MessageView.h
//  StatusThing
//
//  Created by Erik on 5/14/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MessageView : NSView

@property (strong) IBOutlet NSTextField *senderField;
@property (strong) IBOutlet NSTextField *addressField;
@property (strong) IBOutlet NSTextField *dateField;
@property (strong) IBOutlet NSTextField *bodyField;

@property (strong,nonatomic         ) NSString *sender;
@property (strong,nonatomic         ) NSString *address;
@property (strong,nonatomic         ) NSDate   *date;
@property (strong,nonatomic         ) NSString *body;
@property (strong,nonatomic,readonly) NSString *csv;

- (void)sentBy:(NSString *)sender fromAddress:(NSString *)address onDate:(NSDate *)date withBody:(NSString *)body;
@end
