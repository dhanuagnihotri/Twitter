//
//  ComposeViewController.m
//  Twitter
//
//  Created by Dhanu Agnihotri on 2/18/15.
//  Copyright (c) 2015 ___SocietyTech___. All rights reserved.
//

#import "ComposeViewController.h"

@interface ComposeViewController ()

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.barTintColor=  [UIColor colorWithRed:0.467 green:0.718 blue:0.929 alpha:1] /*#77b7ed*/;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.title = @"Compose";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@"Cancel" style: UIBarButtonItemStylePlain
                                             target:self action:@selector(cancelClicked)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"Tweet" style: UIBarButtonItemStylePlain
                                              target:self action:@selector(tweetClicked)];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)cancelClicked
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)tweetClicked
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
