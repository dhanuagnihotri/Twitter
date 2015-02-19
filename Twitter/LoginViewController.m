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

@interface LoginViewController ()
- (IBAction)loginPressed:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginPressed:(id)sender {
    [[TwitterClient sharedInstance] loginWithCompletion:^(User *user, NSError *error) {
        if(user!=nil)
        {
            //Modally present tweets view
            NSLog(@"Welcome to twitter %@", user.name);
            [User currentUser];
            
            TweetsViewController *vc = [[TweetsViewController alloc] init];
            UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:nvc animated:YES completion:nil];
            
        }
        else
        {
            //present error view
        }
    }];
}
@end
