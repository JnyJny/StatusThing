//
//  StatusListener.h
//  StatusThing
//
//  Created by Erik on 4/16/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol StatusListenerDelegate <NSObject>

extern NSString *const PeerKeyAddress;
extern NSString *const PeerKeyPort;
extern NSString *const PeerKeyTimestamp;
extern NSString *const PeerKeyContent;


@optional
- (void)processRequest:(NSDictionary *)info fromClient:(NSDictionary *)clientInfo;

- (void)updateWithDictionary:(NSDictionary *)info;
- (void)updateWithArray:(NSArray *)list;

@end

@interface StatusListener : NSObject <NSStreamDelegate>

@property (strong, nonatomic) id<StatusListenerDelegate> delegate;
   
@property (assign,nonatomic) unsigned short port;

@property (strong,nonatomic) NSString *helpText;
@property (strong,nonatomic) NSDictionary *resetInfo;

- (void)start;
- (void)stop;



@end
