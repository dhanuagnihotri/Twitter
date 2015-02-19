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


@interface TweetsViewController () <UITableViewDataSource, UITableViewDelegate>
@property(strong, nonatomic) NSMutableArray *tweetsArray;
@property (strong, nonatomic) IBOutlet UITableView *tweetsTableView;

@property (nonatomic, strong) UIRefreshControl *refreshControl;


@end

@implementation TweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tweetsArray = [[NSMutableArray alloc] init];
//    [[TwitterClient sharedInstance] homeTimelineWithParams:nil
//                                                completion:^(NSArray *tweets, NSError *error) {
//                                                for(Tweet *tweet in tweets)
//                                                {
////                                                    NSLog(@"text:%@", tweet.text);
////                                                    NSLog(@"retweeted:%d",tweet.retweeted);
//                                                    [self.tweetsArray addObject:tweet];
//                                                }
//                                                [self.tweetsTableView reloadData];
//                                                }];
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
                                             initWithTitle:@"New" style: UIBarButtonItemStylePlain
                                             target:self action:@selector(newClicked:)];
    
    
    [self.tweetsTableView registerNib:[UINib nibWithNibName:@"TweetTableViewCell" bundle:nil] forCellReuseIdentifier:@"TweetTableViewCell"];
    
    self.tweetsTableView.dataSource = self;
    self.tweetsTableView.delegate = self;
    
    self.tweetsTableView.rowHeight = 100;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tweetsTableView insertSubview:self.refreshControl atIndex:0];
    
    [self onRefresh];

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
    [self.tweetsArray removeAllObjects];
    
    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        for(Tweet *tweet in tweets)
        {
            //NSLog(@"text:%@", tweet.text);
            //NSLog(@"retweeted:%d",tweet.retweeted);
            [self.tweetsArray addObject:tweet];
        }

        [SVProgressHUD dismiss];
        [self.refreshControl endRefreshing];
        [self.tweetsTableView reloadData];
    }];
    
   
}

- (void)newClicked:(id)sender {
   ComposeViewController  *vc = [[ComposeViewController alloc]init];
    
    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

#pragma mark Tableview methods

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweetsArray.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TweetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetTableViewCell"];
    
    Tweet *tweet = self.tweetsArray[indexPath.row];
    cell.tweet = tweet;

    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TweetDetailsViewController *vc = [[TweetDetailsViewController alloc]init];
    
//    vc.movie = self.filteredMovies[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
