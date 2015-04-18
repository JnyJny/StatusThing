//
//  StatusListener.h
//  StatusThing
//
//  Created by Erik on 4/16/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol StatusListenerDelegate <NSObject>

@optional
- (void)processClientRequest:(NSDictionary *)info;

@end

@interface StatusListener : NSObject <NSStreamDelegate>

@property (strong, nonatomic) id<StatusListenerDelegate> delegate;
   
- (instancetype)initWithPort:(NSNumber *)port;

- (void)start;
- (void)stop;



@end
