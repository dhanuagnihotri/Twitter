//
//  TwitterClient.h
//  Twitter
//
//  Created by Dhanu Agnihotri on 2/17/15.
//  Copyright (c) 2015 ___SocietyTech___. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"
#import "Tweet.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager
+(TwitterClient*)sharedInstance;

-(void)loginWithCompletion:(void (^) (User *user, NSError *error))completion;
-(void)openURL:(NSURL *)url;
-(void)homeTimelineWithParams:(NSDictionary*)params completion:(void (^)(NSArray *tweets, NSError *error))completion;
-(void)tweetWithParams:(NSDictionary*)params completion:(void (^)(NSDictionary *result, NSError *error))completion;
-(void)favoriteWithParams:(NSDictionary*)params completion:(void (^)(NSDictionary *result, NSError *error))completion;
-(void)unfavoriteWithParams:(NSDictionary*)params completion:(void (^)(NSDictionary *result, NSError *error))completion;
-(void)retweetWithID:(NSString*)tweetID completion:(void (^)(NSDictionary *result, NSError *error))completion;
-(void)unretweetWithID:(NSString*)tweetID completion:(void (^)(NSDictionary *result, NSError *error))completion;

@end
