//
//  ProfileViewController.m
//  Twitter
//
//  Created by Dhanu Agnihotri on 2/27/15.
//  Copyright (c) 2015 ___SocietyTech___. All rights reserved.
//

#import "ProfileViewController.h"
#import "TweetTableViewCell.h"
#import "TwitterClient.h"
#import "UIImageView+AFNetworking.h"
#import "PageChildViewController.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate , UIPageViewControllerDataSource>
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;

@property (strong, nonatomic) IBOutlet UIImageView *smallProfileImageView;

@property (strong, nonatomic) IBOutlet UILabel *numTweetsLabel;
@property (strong, nonatomic) IBOutlet UILabel *numFollowingLabel;
@property (strong, nonatomic) IBOutlet UILabel *numFollowersLabel;
@property (strong, nonatomic) IBOutlet UITableView *userTimelineTableView;
@property(strong, nonatomic) NSMutableArray *tweetsArray;

@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) UIPageViewController *pageController;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.navigationController.navigationBar.barTintColor=  [UIColor colorWithRed:0.467 green:0.718 blue:0.929 alpha:1] /*#77b7ed*/;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.title = self.user.name;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
//                                             initWithTitle:@"Sign Out" style: UIBarButtonItemStylePlain
//                                             target:self action:@selector(logoutClicked:)];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
//                                              initWithTitle:@"Compose" style: UIBarButtonItemStylePlain
//                                              target:self action:@selector(composeClicked:)];
//    
    
    
    // Do any additional setup after loading the view from its nib.
    [self.userTimelineTableView registerNib:[UINib nibWithNibName:@"TweetTableViewCell" bundle:nil] forCellReuseIdentifier:@"TweetTableViewCell"];
    
    self.userTimelineTableView.dataSource = self;
    self.userTimelineTableView.delegate = self;
    self.userTimelineTableView.rowHeight = UITableViewAutomaticDimension;
    self.userTimelineTableView.estimatedRowHeight = 120;
    
    //User *user = [User currentUser];
    self.numTweetsLabel.text = [NSString stringWithFormat:@"%ld Tweets",self.user.tweetCount];
    self.numFollowingLabel.text = [NSString stringWithFormat:@"%ld Following",self.user.followingCount];
    self.numFollowersLabel.text = [NSString stringWithFormat:@"%ld Followers",self.user.followersCount];
//    [self.profileImageView setImageWithURL:[NSURL URLWithString:user.profileBackgroundImageURL]];
//    [self.smallProfileImageView setImageWithURL:[NSURL URLWithString:user.profileImageURL]];
 
    self.tweetsArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    params[@"screen_name"] = self.user.screenName;
    [[TwitterClient sharedInstance] userTimelineWithParams:params completion:^(NSArray *tweets, NSError *error) {
        for(Tweet *tweet in tweets)
        {
            [self.tweetsArray addObject:tweet];
        }
        
        [self.userTimelineTableView reloadData];
    }];
    
        
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:CGRectMake(0,52,320,160)];
   PageChildViewController *initialViewController = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Tableview methods

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweetsArray.count;
}

// Make the separator line extends all the way to the left
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TweetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetTableViewCell"];
    
    Tweet *tweet = self.tweetsArray[indexPath.row];
    cell.tweet = tweet;
    
    return cell;
}

#pragma pageviewcontroller delegate methods

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(PageChildViewController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(PageChildViewController *)viewController index];
    index++;
    if (index == 2) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (PageChildViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    PageChildViewController *childViewController = [[PageChildViewController alloc] init];
    childViewController.index = index;
    childViewController.profileBackgroundImageURL = self.user.profileBackgroundImageURL;
    childViewController.profileImageURL = self.user.profileImageURL;
    
    switch (index) {
        case 0:
            childViewController.text = self.user.name;
            break;
        case 1:
            childViewController.text = self.user.tagline;
            break;
            
        default:
            break;
    }
    
    return childViewController;
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return 2;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

@end
