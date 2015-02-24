//
//  Tweet.m
//  Twitter
//
//  Created by Dhanu Agnihotri on 2/17/15.
//  Copyright (c) 2015 ___SocietyTech___. All rights reserved.
//

#import "Tweet.h"
#import "TwitterClient.h"
#import "User.h"

@implementation Tweet

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        if(dictionary[@"retweeted_status"])
        {
            self.retweeted = YES;
            self.retweetUserName = [dictionary valueForKeyPath:@"user.name"];
            dictionary = dictionary[@"retweeted_status"];
        }
        else
        {
            self.retweeted = NO;
        }
        
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        self.text = dictionary[@"text"];
        
        NSString *createdTimeString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.createdTime = [formatter dateFromString:createdTimeString];
        
        self.retweetsCount = [dictionary[@"retweet_count"] integerValue];
        self.favoritesCount = [dictionary[@"favorite_count"] integerValue];
        
        self.tweetID = [dictionary[@"id"] integerValue];
        self.userFavorited = [dictionary[@"favorited"] boolValue];
        self.userRetweeted = [dictionary[@"retweeted"] boolValue];
    }
    return self;
}

+(NSArray *)tweetsWithArray:(NSArray *)array
{
    NSMutableArray *tweets = [NSMutableArray array];
    
    for(NSDictionary *dict in array)
    {
        [tweets addObject:[[Tweet alloc]initWithDictionary:dict]];
    }
    
    return tweets;
}

-(void)retweet
{
    if(self.tweetID)
    {
        self.retweetsCount++;
        self.userRetweeted = TRUE;
        [[TwitterClient sharedInstance] retweetWithID:[NSString stringWithFormat:@"%ld",self.tweetID] completion:^(NSDictionary *result, NSError *error) {
            NSLog(@" source id %ld retweet ID %@", self.tweetID, result[@"id"]);
            self.retweetResultID=[result[@"id"] integerValue];
        }];
    }
}

-(void)unretweet
{
    self.retweetsCount--;
    self.userRetweeted = FALSE;

    if(self.retweetResultID)
    {
        [[TwitterClient sharedInstance] unretweetWithID:[NSString stringWithFormat:@"%ld",self.retweetResultID] completion:^(NSDictionary *result, NSError *error) {
        }];
    }
    else
    {
        //we need to get the tweet id from the user timeline
        [[TwitterClient sharedInstance] userTimelineWithParams:nil completion:^(NSArray *result, NSError *error)
         {
             for(NSDictionary *dict in result)
             {
                 NSInteger statusID = [[dict valueForKeyPath:@"retweeted_status.id"] integerValue];
                 if(statusID == self.tweetID)
                 {
                     NSInteger tweetID = [dict[@"id"] integerValue];
                     [[TwitterClient sharedInstance] unretweetWithID:[NSString stringWithFormat:@"%ld",tweetID] completion:^(NSDictionary *result, NSError *error) {
                     }];
                     break;
                 }
             }
         }];
    }
}

-(void)favorite
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    if(self.tweetID)
    {
        NSString *tweetID = [NSString stringWithFormat:@"%ld",self.tweetID];
        params[@"id"] = tweetID;
        self.favoritesCount++;
        self.userFavorited = TRUE;
        [[TwitterClient sharedInstance] favoriteWithParams:params completion:^(NSDictionary *result, NSError *error) {
        }];
    }
}

-(void)unfavorite
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    if(self.tweetID)
    {
        NSString *tweetID = [NSString stringWithFormat:@"%ld",self.tweetID];
        params[@"id"] = tweetID;
        self.favoritesCount--;
        self.userFavorited = FALSE;
        [[TwitterClient sharedInstance] unfavoriteWithParams:params completion:^(NSDictionary *result, NSError *error) {
        }];
    }
}

@end
