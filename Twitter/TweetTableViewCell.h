//
//  TweetTableViewCell.h
//  Twitter
//
//  Created by Dhanu Agnihotri on 2/18/15.
//  Copyright (c) 2015 ___SocietyTech___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@class TweetTableViewCell;

@protocol TweetCellDelegate <NSObject>

-(void)tweetCell:(TweetTableViewCell *)cell replyButtonClicked:(BOOL)state;
-(void)imageTapped:(TweetTableViewCell *)cell;

@end

@interface TweetTableViewCell : UITableViewCell

@property (nonatomic,weak) id<TweetCellDelegate> delegate;
@property (strong,nonatomic) Tweet *tweet;

@end
