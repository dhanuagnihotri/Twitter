//
//  TweetTableViewCell.m
//  Twitter
//
//  Created by Dhanu Agnihotri on 2/18/15.
//  Copyright (c) 2015 ___SocietyTech___. All rights reserved.
//

#import "TweetTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"
#import "TwitterClient.h"
#import "TTTAttributedLabel.h"

@interface TweetTableViewCell() <TTTAttributedLabelDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *retweetImageView;
@property (strong, nonatomic) IBOutlet UILabel *retweetNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *twitterNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *tweetLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;


@property (strong, nonatomic) IBOutlet UIButton *replyButton;
- (IBAction)replyButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *retweetButton;
- (IBAction)retweetButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *favoriteButton;
- (IBAction)favoriteButtonPressed:(id)sender;

@end


@implementation TweetTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.nameLabel.preferredMaxLayoutWidth =self.nameLabel.frame.size.width;
    self.profileImage.layer.cornerRadius = 3;
    self.profileImage.clipsToBounds = YES;
    
}

-(void)layoutSubviews
{
    NSString *text = [self.tweet.text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //self.tweetLabel.text = text;
    if ([self.tweetLabel isKindOfClass:[TTTAttributedLabel class]])
    {
        TTTAttributedLabel *label = (TTTAttributedLabel *)self.tweetLabel;
        label.enabledTextCheckingTypes = NSTextCheckingTypeLink;
        label.delegate = self;
        label.linkAttributes = @{ (id)kCTForegroundColorAttributeName: [UIColor blueColor], };
        
        label.text = text;
    }
    self.nameLabel.text = self.tweet.user.name;
    self.twitterNameLabel.text = [NSString stringWithFormat:@"@ %@", self.tweet.user.screenName];
    [self.profileImage setImageWithURL:[NSURL URLWithString:self.tweet.user.profileImageURL]];
    self.timeLabel.text = [self stringFromTimeInterval];
    if(!self.tweet.retweeted)
    {
        self.retweetNameLabel.hidden = YES;
        self.retweetImageView.hidden = YES;
    }
    else
    {
        self.retweetNameLabel.text = [NSString stringWithFormat:@"%@ retweeted", self.tweet.retweetUserName];
        self.retweetNameLabel.hidden = NO;
        self.retweetImageView.hidden = NO;
    }
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    [[UIApplication sharedApplication] openURL:url];
}

- (NSString *)stringFromTimeInterval
{
    NSTimeInterval interval =[[NSDate date] timeIntervalSinceDate:self.tweet.createdTime];
    
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    NSString *time = nil;
    if (hours > 0) {
        time = [NSString stringWithFormat:@"%2lihr", (long)hours];
    }
    else if (minutes > 0) {
        time = [NSString stringWithFormat:@"%2lim", (long)minutes];
    }
    else
        time = [NSString stringWithFormat:@"%2lis", (long)seconds];
    return time;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)replyButtonPressed:(id)sender {
    
    [self.delegate tweetCell:self replyButtonClicked:YES];
}

- (IBAction)retweetButtonPressed:(id)sender {
    NSLog(@" Retweet tweet id:%ld",self.tweet.tweetID);
    if(self.tweet.tweetID)
    {
        NSString *tweetID = [NSString stringWithFormat:@"%ld",self.tweet.tweetID];
        
        [[TwitterClient sharedInstance] retweetWithID:tweetID completion:^(NSDictionary *result, NSError *error) {
            NSLog(@"Retweet successful");
        }];
    }
}

- (IBAction)favoriteButtonPressed:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    if(self.tweet.tweetID)
    {
        NSString *tweetID = [NSString stringWithFormat:@"%ld",self.tweet.tweetID];
        params[@"id"] = tweetID;
        
        [[TwitterClient sharedInstance] favoriteWithParams:params completion:^(NSDictionary *result, NSError *error) {
            NSLog(@"Favorites successful");
        }];
    }
}

@end
