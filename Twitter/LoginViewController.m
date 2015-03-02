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

@interface LoginViewController ()
- (IBAction)loginPressed:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithRed:0.467 green:0.718 blue:0.929 alpha:1] ;}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginPressed:(id)sender {
    [[TwitterClient sharedInstance] loginWithCompletion:^(User *user, NSError *error) {
        if(user!=nil)
        {
            //Modally present tweets view
            [User currentUser];
//            
//            TweetsViewController *vc = [[TweetsViewController alloc] init];
//            UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
//            [self presentViewController:nvc animated:YES completion:nil];
//            
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
