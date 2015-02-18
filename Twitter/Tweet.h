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

-(id)initWithDictionary:(NSDictionary *)dictionary;
+(NSArray *)tweetsWithArray:(NSArray *)array;

@end
