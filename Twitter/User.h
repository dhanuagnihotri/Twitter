//
//  User.h
//  Twitter
//
//  Created by Dhanu Agnihotri on 2/17/15.
//  Copyright (c) 2015 ___SocietyTech___. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const UserDidLoginNotification ; 
extern NSString * const UserDidLogoutNotification ;

@interface User : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *screenName;
@property (strong, nonatomic) NSString *profileImageURL;
@property (strong, nonatomic) NSString *profileBackgroundImageURL;
@property (strong, nonatomic) NSString *tagline;
@property (nonatomic, assign) NSInteger tweetCount;
@property (nonatomic, assign) NSInteger followingCount;
@property (nonatomic, assign) NSInteger followersCount;


-(id)initWithDictionary:(NSDictionary *)dictionary;

+(User *)currentUser;
+(void)setCurrentUser:(User *)currentUser;
+(void)logout;

@end
