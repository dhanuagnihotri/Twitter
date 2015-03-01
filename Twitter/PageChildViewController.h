//
//  PageChildViewController.h
//  Twitter
//
//  Created by Dhanu Agnihotri on 2/28/15.
//  Copyright (c) 2015 ___SocietyTech___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageChildViewController : UIViewController
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *profileBackgroundImageURL;
@property (strong, nonatomic) NSString *profileImageURL;

@end
