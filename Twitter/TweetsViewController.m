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

@interface TweetsViewController () <UITableViewDataSource, UITableViewDelegate>
@property(strong, nonatomic) NSMutableArray *tweetsArray;
@property (strong, nonatomic) IBOutlet UITableView *tweetsTableView;

@end

@implementation TweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tweetsArray = [[NSMutableArray alloc] init];
    [[TwitterClient sharedInstance] homeTimelineWithParams:nil
                                                completion:^(NSArray *tweets, NSError *error) {
                                                for(Tweet *tweet in tweets)
                                                {
                                                    NSLog(@"text:%@", tweet.text);
                                                    [self.tweetsArray addObject:tweet];
                                                }
                                                [self.tweetsTableView reloadData];
                                                }];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.barTintColor=  [UIColor colorWithRed:0.467 green:0.718 blue:0.929 alpha:1] /*#77b7ed*/;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.title = @"Home";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@"Sign Out" style: UIBarButtonItemStylePlain
                                             target:self action:@selector(logoutClicked:)];
    
    [self.tweetsTableView registerNib:[UINib nibWithNibName:@"TweetTableViewCell" bundle:nil] forCellReuseIdentifier:@"TweetTableViewCell"];
    
    self.tweetsTableView.dataSource = self;
    self.tweetsTableView.delegate = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)logoutClicked:(id)sender {
    [User logout];
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
    cell.tweetTextLabel.text = tweet.text;
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    MovieDetailViewController *vc = [[MovieDetailViewController alloc]init];
//    vc.movie = self.filteredMovies[indexPath.row];
//    
//    
//    [self.navigationController pushViewController:vc animated:YES];
}

@end
