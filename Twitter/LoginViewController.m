//
//  LoginViewController.m
//  Twitter
//
//  Created by Dhanu Agnihotri on 2/17/15.
//  Copyright (c) 2015 ___SocietyTech___. All rights reserved.
//

#import "LoginViewController.h"
#import "TweetsViewController.h"
#import "TwitterClient.h"
#import "MainViewController.h"

@interface LoginViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *accountsTableView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithRed:0.467 green:0.718 blue:0.929 alpha:1] ;
    self.accountsTableView.delegate = self;
    self.accountsTableView.dataSource = self;
    self.accountsTableView.rowHeight = 100;
    self.accountsTableView.backgroundColor = [UIColor colorWithRed:0.467 green:0.718 blue:0.929 alpha:1] ;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Tableview methods

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
//    TweetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetTableViewCell"];
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.textLabel.text = @"+";
    cell.backgroundColor = [UIColor grayColor];
//    cell.delegate = self;
//    Tweet *tweet = self.tweetsArray[indexPath.row];
//    cell.tweet = tweet;
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    [[TwitterClient sharedInstance] loginWithCompletion:^(User *user, NSError *error) {
        if(user!=nil)
        {
            //Modally present tweets view
            [User currentUser];
            
            MainViewController *vc = [[MainViewController alloc] init];
            [self presentViewController:vc animated:YES completion:nil];
        }
        else
        {
            //present error view
        }
    }];
}

@end
