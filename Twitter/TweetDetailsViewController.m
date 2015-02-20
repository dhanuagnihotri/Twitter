//
//  TweetDetailsViewController.m
//  Twitter
//
//  Created by Dhanu Agnihotri on 2/18/15.
//  Copyright (c) 2015 ___SocietyTech___. All rights reserved.
//

#import "TweetDetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface TweetDetailsViewController ()
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
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
//                                              initWithTitle:@"Compose" style: UIBarButtonItemStylePlain
//                                              target:self action:@selector(newClicked:)];
    
    if(!self.tweet.retweeted)
    {
        self.retweetNameLabel.hidden = YES;
        self.retweetImageView.hidden = YES;
    }
    else
    {
        self.retweetNameLabel.text = [NSString stringWithFormat:@"%@ retweeted", self.tweet.retweetUserName];
    }
    
    self.textLabel.text = self.tweet.text;
    self.nameLabel.text = self.tweet.user.name;
    self.twitterNameLabel.text = [NSString stringWithFormat:@"@ %@", self.tweet.user.screenName];
    [self.profileImage setImageWithURL:[NSURL URLWithString:self.tweet.user.profileImageURL]];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yy HH:mm a"];
    self.timeCreatedLabel.text = [dateFormatter stringFromDate:self.tweet.createdTime ];
    
    self.retweetsLabel.text = [NSString stringWithFormat:@"%ld",self.tweet.retweetsCount];
    self.favoritesLabel.text = [NSString stringWithFormat:@"%ld",self.tweet.favoritesCount];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onReplyPressed:(id)sender {
}

- (IBAction)onRetweetPressed:(id)sender {
}

- (IBAction)onFavoritesPressed:(id)sender {
}
@end
