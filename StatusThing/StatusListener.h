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
extern NSString *const ResponseKeyData;
extern NSString *const ResponseActionOk;
extern NSString *const ResponseActionDone;


@optional
- (NSDictionary *)processRequest:(NSDictionary *)request;  // preferred
- (NSDictionary *)clientDidConnect:(NSDictionary *)info;
@end

@interface StatusListener : NSObject <NSStreamDelegate>

@property (strong, nonatomic) id<StatusListenerDelegate> delegate;
   
@property (assign,nonatomic) unsigned short port;
@property (strong,nonatomic,readonly) NSArray *activeConnections;

// this property goes
@property (strong,nonatomic) NSDictionary *resetInfo;

- (void)start;
- (void)stop;



@end
