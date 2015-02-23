//
//  TweetDetailsViewController.m
//  Twitter
//
//  Created by Dhanu Agnihotri on 2/18/15.
//  Copyright (c) 2015 ___SocietyTech___. All rights reserved.
//

#import "TweetDetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"
#import "TTTAttributedLabel.h"

@interface TweetDetailsViewController () <TTTAttributedLabelDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *retweetImageView;
@property (strong, nonatomic) IBOutlet UILabel *retweetNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *twitterNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *textLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeCreatedLabel;
@property (strong, nonatomic) IBOutlet UILabel *retweetsLabel;
@property (strong, nonatomic) IBOutlet UILabel *favoritesLabel;

- (IBAction)onReplyPressed:(id)sender;
- (IBAction)onRetweetPressed:(id)sender;
- (IBAction)onFavoritesPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *replyButton;
@property (strong, nonatomic) IBOutlet UIButton *retweetButton;
@property (strong, nonatomic) IBOutlet UIButton *favoriteButton;

@end

@implementation TweetDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBar.barTintColor=  [UIColor colorWithRed:0.467 green:0.718 blue:0.929 alpha:1] /*#77b7ed*/;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
    setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.title = @"Tweet";
   
    if(!self.tweet.retweeted)
    {
        self.retweetNameLabel.hidden = YES;
        self.retweetImageView.hidden = YES;
    }
    else
    {
        self.retweetNameLabel.text = [NSString stringWithFormat:@"%@ retweeted", self.tweet.retweetUserName];
    }
    
    NSString *text = [self.tweet.text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([self.textLabel isKindOfClass:[TTTAttributedLabel class]])
    {
        TTTAttributedLabel *label = (TTTAttributedLabel *)self.textLabel;
        label.enabledTextCheckingTypes = NSTextCheckingTypeLink;
        label.delegate = self;
        label.linkAttributes = @{ (id)kCTForegroundColorAttributeName: [UIColor blueColor], };

        label.text = text;
    }
    
    self.nameLabel.text = self.tweet.user.name;
    self.twitterNameLabel.text = [NSString stringWithFormat:@"@ %@", self.tweet.user.screenName];
    [self.profileImage setImageWithURL:[NSURL URLWithString:self.tweet.user.profileImageURL]];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yy hh:mm a"];
    self.timeCreatedLabel.text = [dateFormatter stringFromDate:self.tweet.createdTime ];
    
    self.retweetsLabel.text = [NSString stringWithFormat:@"%ld",self.tweet.retweetsCount];
    self.favoritesLabel.text = [NSString stringWithFormat:@"%ld",self.tweet.favoritesCount];
    
    if(self.tweet.userRetweeted)
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet_on"] forState:UIControlStateNormal];
    if(self.tweet.userFavorited)
        [self.favoriteButton setImage:[UIImage imageNamed:@"favorite_on"] forState:UIControlStateNormal];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    [[UIApplication sharedApplication] openURL:url];
}


- (IBAction)onReplyPressed:(id)sender {
    ComposeViewController  *vc = [[ComposeViewController alloc]init];
    vc.replyUser = self.tweet.user.screenName;
    vc.replyID = self.tweet.tweetID;
    
    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (IBAction)onRetweetPressed:(id)sender {
    if(!self.tweet.userRetweeted) //user is retweeting the status
    {
        [self.tweet retweet];
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet_on"] forState:UIControlStateNormal];
        self.retweetsLabel.text = [NSString stringWithFormat:@"%ld",self.tweet.retweetsCount];
    }
    else //unretweet the status
    {
        [self.tweet unretweet];
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet"] forState:UIControlStateNormal];
        self.retweetsLabel.text = [NSString stringWithFormat:@"%ld",self.tweet.retweetsCount];
    }
}

- (IBAction)onFavoritesPressed:(id)sender {
    if(!self.tweet.userFavorited) //favorite the status
    {
        [self.tweet favorite];
        [self.favoriteButton setImage:[UIImage imageNamed:@"favorite_on"] forState:UIControlStateNormal];
        self.favoritesLabel.text = [NSString stringWithFormat:@"%ld",self.tweet.favoritesCount];
    }
    else //unfavorite the status
    {
        [self.tweet unfavorite];
        [self.favoriteButton setImage:[UIImage imageNamed:@"favorite"] forState:UIControlStateNormal];
        self.favoritesLabel.text = [NSString stringWithFormat:@"%ld",self.tweet.favoritesCount];
    }
}
@end
