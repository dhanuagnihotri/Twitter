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
#import "AccountTableViewCell.h"

@interface LoginViewController () <UITableViewDataSource, UITableViewDelegate, AccountCellDelegate>

@property (strong, nonatomic) IBOutlet UITableView *accountsTableView;
@property (strong,nonatomic) NSMutableArray *accounts;
@property (strong,nonatomic) NSUserDefaults *defaults;

@end

@implementation LoginViewController
NSString *const kAccountsKey = @"kAccountsKey";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithRed:0.467 green:0.718 blue:0.929 alpha:1] ;
    self.accountsTableView.delegate = self;
    self.accountsTableView.dataSource = self;
    self.accountsTableView.rowHeight = 100;
    self.accountsTableView.backgroundColor = [UIColor colorWithRed:0.467 green:0.718 blue:0.929 alpha:1] ;
    self.accountsTableView.allowsMultipleSelectionDuringEditing = NO;

    [self.accountsTableView registerNib:[UINib nibWithNibName:@"AccountTableViewCell" bundle:nil] forCellReuseIdentifier:@"AccountTableViewCell"];

    self.accounts = [[NSMutableArray alloc]init];
    self.defaults = [NSUserDefaults standardUserDefaults];
    
    NSData *data = [self.defaults objectForKey:kAccountsKey];
    if(data != nil)
    {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        
        for(NSDictionary *dict in array)
            [self.accounts addObject:dict];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Tableview methods

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.accounts.count + 1;
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
    if(indexPath.row < self.accounts.count)
    {
        AccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountTableViewCell"];
        cell.name = self.accounts[indexPath.row][@"name"];
        cell.screenName = self.accounts[indexPath.row][@"screen_name"];
        cell.profileImageURL = self.accounts[indexPath.row][@"profile_image_url"];
        cell.delegate = self;
        return cell;
    }
    else
    {
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        cell.textLabel.text = @"+";
        cell.backgroundColor = [UIColor grayColor];
        return cell;

    }

    return nil;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    [[TwitterClient sharedInstance] loginWithCompletion:^(User *user, NSError *error) {
        if(user!=nil)
        {
            //Modally present tweets view
            [User currentUser];
            [self addUser:user];
            
            MainViewController *vc = [[MainViewController alloc] init];
            [self presentViewController:vc animated:YES completion:nil];
        }
        else
        {
            //present error view
        }
    }];
}

-(void)addUser:(User *)user
{
    [self.accounts addObject:user.dictionary];
    [self.defaults removeObjectForKey:kAccountsKey];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:self.accounts options:0 error:NULL];
    [self.defaults setObject:data forKey:kAccountsKey];
    [self.defaults synchronize];

}

-(void)removeUser:(User *)user
{
    
    [self.accounts removeObject:user.dictionary];
    [self.defaults removeObjectForKey:kAccountsKey];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:self.accounts options:0 error:NULL];
    [self.defaults setObject:data forKey:kAccountsKey];
    [self.defaults synchronize];
    
    [self.accountsTableView reloadData];
    
}

-(void)deleteUser:(AccountTableViewCell *)cell
{
    if(cell.screenName !=nil)
    {
        NSLog(@"delete user %@", cell.screenName);
        for(NSDictionary *dict in self.accounts)
        {
            if([dict[@"screen_name"] isEqualToString:cell.screenName])
            {
                User *user = [[User alloc]initWithDictionary:dict];
                [self removeUser:user];
                
                if([user.screenName isEqualToString:[User currentUser].screenName])
                {
                    [User logout];
                }
            }
        }
    }
}

@end
