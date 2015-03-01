//
//  PageChildViewController.m
//  Twitter
//
//  Created by Dhanu Agnihotri on 2/28/15.
//  Copyright (c) 2015 ___SocietyTech___. All rights reserved.
//

#import "PageChildViewController.h"
#import "UIImageView+AFNetworking.h"

@interface PageChildViewController ()

@property (strong, nonatomic) IBOutlet UILabel *textLabel;
@property (strong, nonatomic) IBOutlet UIImageView *profileBackgroundImage;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;

@end

@implementation PageChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.textLabel.text = self.text;
    [self.profileBackgroundImage setImageWithURL:[NSURL URLWithString:self.profileBackgroundImageURL]];
    [self.profileImage setImageWithURL:[NSURL URLWithString:self.profileImageURL]];

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

@end
