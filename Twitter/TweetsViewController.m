//
//  TweetsViewController.m
//  
//
//  Created by Dhanu Agnihotri on 2/17/15.
//
//

#import "TweetsViewController.h"
#import "User.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import "TweetTableViewCell.h"
#import "TweetDetailsViewController.h"
#import "ComposeViewController.h"
#import "SVProgressHUD.h"
#import "SVPullToRefresh.h"


@interface TweetsViewController () <UITableViewDataSource, UITableViewDelegate, ComposeViewControllerDelegate, TweetCellDelegate>
@property(strong, nonatomic) NSMutableArray *tweetsArray;
@property (strong, nonatomic) IBOutlet UITableView *tweetsTableView;

@property (nonatomic, strong) UIRefreshControl *refreshControl;


@end

@implementation TweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tweetsArray = [[NSMutableArray alloc] init];

    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.barTintColor=  [UIColor colorWithRed:0.467 green:0.718 blue:0.929 alpha:1] /*#77b7ed*/;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.title = @"Home";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@"Sign Out" style: UIBarButtonItemStylePlain
                                             target:self action:@selector(logoutClicked:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@"Compose" style: UIBarButtonItemStylePlain
                                              target:self action:@selector(composeClicked:)];
    
    
    [self.tweetsTableView registerNib:[UINib nibWithNibName:@"TweetTableViewCell" bundle:nil] forCellReuseIdentifier:@"TweetTableViewCell"];
    
    self.tweetsTableView.dataSource = self;
    self.tweetsTableView.delegate = self;
    
    //self.tweetsTableView.rowHeight = UITableViewAutomaticDimension;
    self.tweetsTableView.rowHeight = 120;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tweetsTableView insertSubview:self.refreshControl atIndex:0];
    
    [self onRefresh];
    
    // setup infinite scrolling
    __weak TweetsViewController *weakSelf = self;
    [self.tweetsTableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowAtBottom];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)logoutClicked:(id)sender {
    [User logout];
}

- (void)onRefresh {
    
    [SVProgressHUD show];
    
    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        [self.tweetsArray removeAllObjects];
        for(Tweet *tweet in tweets)
        {
            [self.tweetsArray addObject:tweet];
        }

        [SVProgressHUD dismiss];
        [self.refreshControl endRefreshing];
        [self.tweetsTableView reloadData];
    }];
}

- (void)insertRowAtBottom {
    __weak TweetsViewController *weakSelf = self;
    
    NSInteger min_id = [self find_min]-1;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
    params[@"count"] = @20;
    params[@"max_id"] = @(min_id);
    
    [[TwitterClient sharedInstance] homeTimelineWithParams:params completion:^(NSArray *tweets, NSError *error)
     {
         for(Tweet *tweet in tweets)
         {
             [weakSelf.tweetsArray addObject:tweet];
         }
         [weakSelf.tweetsTableView.infiniteScrollingView stopAnimating];
         [weakSelf.tweetsTableView reloadData];
     }];
}

- (void)composeClicked:(id)sender {
   ComposeViewController  *vc = [[ComposeViewController alloc]init];
    vc.delegate = self;
    
    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

-(NSInteger)find_min
{
    Tweet *tweet = self.tweetsArray[0];
    NSInteger min = tweet.tweetID;
    NSLog(@"tweet ID %ld",tweet.tweetID);
    for(Tweet *tweet in self.tweetsArray)
    {
        if(min>tweet.tweetID)
        {
            min=tweet.tweetID;
            NSLog(@"min ID %ld",min);
        }
    }
    
    return min;
}

#pragma mark Tableview methods

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweetsArray.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TweetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetTableViewCell"];
    
    cell.delegate = self;
    Tweet *tweet = self.tweetsArray[indexPath.row];
    cell.tweet = tweet;

    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)] )
        cell.preservesSuperviewLayoutMargins = false;
    if([cell respondsToSelector:@selector(setSeparatorInset:)] )
        cell.separatorInset = UIEdgeInsetsMake(0, 4, 0, 0);
    if([cell respondsToSelector:@selector(setLayoutMargins:)] )
        cell.layoutMargins = UIEdgeInsetsZero;
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TweetDetailsViewController *vc = [[TweetDetailsViewController alloc]init];
    
    vc.tweet = self.tweetsArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

//-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    TweetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetTableViewCell"];
//    cell.tweet = self.tweetsArray[indexPath.row];
//    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//    return size.height + 1;
//}

#pragma Composeviewcontroller delegate
-(void)ComposeViewController:(ComposeViewController *)composeViewController didsendTweet:(Tweet *)tweet
{
    [self.tweetsArray insertObject:tweet atIndex:0];
    [self.tweetsTableView reloadData];
}

#pragma Tableviewcell delegate
-(void)tweetCell:(TweetTableViewCell *)cell replyButtonClicked:(BOOL)state
{
    ComposeViewController  *vc = [[ComposeViewController alloc]init];
    vc.replyUser = cell.tweet.user.screenName;
    vc.replyID = cell.tweet.tweetID;
    
    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

@end
