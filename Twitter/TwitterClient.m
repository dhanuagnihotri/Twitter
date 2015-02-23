//
//  TwitterClient.m
//  Twitter
//
//  Created by Dhanu Agnihotri on 2/17/15.
//  Copyright (c) 2015 ___SocietyTech___. All rights reserved.
//

#import "TwitterClient.h"

NSString * const kTwitterConsumerKey = @"9Ca60nHV94jcddTAH7nVMEeJj";
NSString * const kTwitterConsumerSecret = @"6w2iysR8BwQxa4gBDolnV7GMDCG3igF0vsCXuLRqpfXZ4TbT7K";
NSString * const kTwitterBaseURL = @"https://api.twitter.com";
@interface TwitterClient ()

@property (nonatomic,strong) void (^loginCompletion)(User *user, NSError *error);

@end

@implementation TwitterClient

+(TwitterClient*)sharedInstance
{
    static TwitterClient *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(instance == nil)
        {
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseURL] consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
        }
    });
    return instance;
}

-(void)loginWithCompletion:(void (^) (User *user, NSError *error))completion
{
    self.loginCompletion = completion;
    
    [[TwitterClient sharedInstance].requestSerializer removeAccessToken];
    [[TwitterClient sharedInstance] fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"codepathtwitterclient://oauth"] scope:nil success:^(BDBOAuth1Credential *requestToken) {
        NSLog(@"Got the request token");
        NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@",requestToken.token]];
        [[UIApplication sharedApplication]openURL:authURL];
    } failure:^(NSError *error) {
        NSLog(@"Failed to get the request token");
        self.loginCompletion(nil, error);
    }];

}

-(void)openURL:(NSURL *)url
{
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query ] success:^(BDBOAuth1Credential *accessToken) {
        NSLog(@"got the auth token");
        [self.requestSerializer saveAccessToken:accessToken];
        
        [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //NSLog(@"current user%@",responseObject);
            User *user = [[User alloc] initWithDictionary:responseObject];
            [User setCurrentUser:user];
            NSLog(@"current user %@", user.name);
            self.loginCompletion(user,nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Failed to get current user");
            self.loginCompletion(nil,error);
        }];
        
        
    } failure:^(NSError *error) {
        NSLog(@"Failed to get the auth token");
        self.loginCompletion(nil,error);
    }];
}

-(void)homeTimelineWithParams:(NSDictionary*)params completion:(void (^)(NSArray *tweets, NSError *error))completion
{
    [self GET:@"1.1/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response object %@",responseObject);
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

-(void)tweetWithParams:(NSDictionary*)params completion:(void (^)(NSDictionary *result, NSError *error))completion
{    
    [self POST:@"1.1/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

-(void)favoriteWithParams:(NSDictionary*)params completion:(void (^)(NSDictionary *result, NSError *error))completion
{
    [self POST:@"1.1/favorites/create.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

-(void)unfavoriteWithParams:(NSDictionary*)params completion:(void (^)(NSDictionary *result, NSError *error))completion
{
    [self POST:@"1.1/favorites/destroy.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

-(void)retweetWithID:(NSString*)tweetID completion:(void (^)(NSDictionary *result, NSError *error))completion
{
    NSString *api = [NSString stringWithFormat:@"https://api.twitter.com/1.1/statuses/retweet/%@.json",tweetID];
    [self POST:api parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

@end
