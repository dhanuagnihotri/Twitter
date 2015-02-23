//
//  Tweet.h
//  Twitter
//
//  Created by Dhanu Agnihotri on 2/17/15.
//  Copyright (c) 2015 ___SocietyTech___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject


@property (nonatomic,strong) NSString *text;
@property (nonatomic,strong) NSDate *createdTime;
@property (nonatomic,strong) User *user;
@property (nonatomic,assign) BOOL retweeted;
@property (nonatomic, strong) NSString *retweetUserName;
@property (nonatomic, assign) NSInteger retweetsCount;
@property (nonatomic, assign) NSInteger favoritesCount;
@property (nonatomic, assign) NSInteger tweetID;
@property (nonatomic, assign)BOOL userRetweeted;
@property (nonatomic, assign)BOOL userFavorited;

-(id)initWithDictionary:(NSDictionary *)dictionary;
+(NSArray *)tweetsWithArray:(NSArray *)array;

@end




//@property (strong, nonatomic) IBOutlet UILabel *retweetNameLabel;
