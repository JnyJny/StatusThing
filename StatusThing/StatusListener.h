//
//  StatusListener.h
//  StatusThing
//
//  Created by Erik on 4/16/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol StatusListenerDelegate <NSObject>

extern NSString *const RequestKeyAddress;
extern NSString *const RequestKeyPort;
extern NSString *const RequestKeyTimestamp;
extern NSString *const RequestKeyContent;

extern NSString *const ResponseKeyAction;
extern NSString *const ResponseKeyText;
extern NSString *const ResponseActionOk;
extern NSString *const ResponseActionDone;

@optional
- (NSDictionary *)processRequest:(NSDictionary *)request;  // preferred
- (NSDictionary *)clientDidConnect:(NSDictionary *)info;

// these methods go
- (NSDictionary *)processRequest:(NSDictionary *)info fromClient:(NSDictionary *)clientInfo;
- (NSDictionary *)handleOutOfBandRequest:(NSDictionary *)info fromClient:(NSDictionary *)clientInfo;
- (void)updateWithDictionary:(NSDictionary *)info;
- (void)updateWithArray:(NSArray *)list;

@end

@interface StatusListener : NSObject <NSStreamDelegate>

@property (strong, nonatomic) id<StatusListenerDelegate> delegate;
   
@property (assign,nonatomic) unsigned short port;

// this property goes
@property (strong,nonatomic) NSDictionary *resetInfo;

- (void)start;
- (void)stop;



@end
