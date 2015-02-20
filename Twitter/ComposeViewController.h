//
//  ComposeViewController.h
//  Twitter
//
//  Created by Dhanu Agnihotri on 2/18/15.
//  Copyright (c) 2015 ___SocietyTech___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@class ComposeViewController;

@protocol ComposeViewControllerDelegate <NSObject>

-(void)ComposeViewController:(ComposeViewController *)composeViewController didsendTweet:(Tweet *)tweet;

@end

@interface ComposeViewController : UIViewController
@property (nonatomic,weak) id <ComposeViewControllerDelegate> delegate;

@end
