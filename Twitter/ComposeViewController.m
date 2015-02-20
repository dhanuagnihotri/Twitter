//
//  ComposeViewController.m
//  Twitter
//
//  Created by Dhanu Agnihotri on 2/18/15.
//  Copyright (c) 2015 ___SocietyTech___. All rights reserved.
//

#import "ComposeViewController.h"
#import "TwitterClient.h"

@interface ComposeViewController ()
@property (strong, nonatomic) IBOutlet UITextView *tweetText;

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
    if(self.tweetText.text.length)
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
        params[@"status"] = @"Hello Codepath";
        
        [[TwitterClient sharedInstance] tweetWithParams:params completion:^(NSDictionary *result, NSError *error) {
            NSLog(@"Send a tweet");
        }];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
