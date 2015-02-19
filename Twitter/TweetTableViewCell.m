//
//  TweetTableViewCell.m
//  Twitter
//
//  Created by Dhanu Agnihotri on 2/18/15.
//  Copyright (c) 2015 ___SocietyTech___. All rights reserved.
//

#import "TweetTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface TweetTableViewCell()
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
    self.tweetLabel.text = self.tweet.text;
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
    }

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
}
- (IBAction)retweetButtonPressed:(id)sender {
}
- (IBAction)favoriteButtonPressed:(id)sender {
}
@end
