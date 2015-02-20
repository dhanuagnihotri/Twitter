//
//  ComposeViewController.m
//  Twitter
//
//  Created by Dhanu Agnihotri on 2/18/15.
//  Copyright (c) 2015 ___SocietyTech___. All rights reserved.
//

#import "ComposeViewController.h"
#import "TwitterClient.h"
#import "TwitterText.h"

@interface ComposeViewController () <UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView *tweetText;
@property (strong, nonatomic) UILabel *navLabel;

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
    
    self.navLabel = [[UILabel alloc] initWithFrame:CGRectMake(235,8,80,30)];
    self.navLabel.text = @"140";
    self.navLabel.textColor = [UIColor grayColor];
    [self.navigationController.navigationBar addSubview:self.navLabel];
    [self.navLabel setBackgroundColor:[UIColor clearColor]];
    
    self.tweetText.delegate = self;
    

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
        params[@"status"] = self.tweetText.text;
        
        [[TwitterClient sharedInstance] tweetWithParams:params completion:^(NSDictionary *result, NSError *error) {
            NSLog(@"Send a tweet");
        }];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma textview methods 
- (void)textViewDidChange:(UITextView *)textView
{
    self.navLabel.text = [NSString stringWithFormat:@"%ld",[TwitterText remainingCharacterCount:self.tweetText.text]];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    self.tweetText.text = @""; //clear out the placeholder text
}

@end
