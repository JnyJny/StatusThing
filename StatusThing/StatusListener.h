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

- (void)updateWithDictionary:(NSDictionary *)info;
- (void)updateWithArray:(NSArray *)list;

@end

@interface StatusListener : NSObject <NSStreamDelegate>

@property (strong, nonatomic) id<StatusListenerDelegate> delegate;
   
@property (strong,nonatomic) NSNumber *port;

@property (strong,nonatomic) NSString *helpText;
@property (strong,nonatomic) NSDictionary *resetInfo;

- (BOOL)start;
- (void)stop;



@end
