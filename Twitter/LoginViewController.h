//
//  LoginViewController.h
//  Twitter
//
//  Created by Dhanu Agnihotri on 2/17/15.
//  Copyright (c) 2015 ___SocietyTech___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@class LoginViewController;

@protocol LoginViewControllerDelegate <NSObject>

-(void)switchAccount:(LoginViewController *)controller user:(User *)user;

@end

@interface LoginViewController : UIViewController

@property (nonatomic,weak) id<LoginViewControllerDelegate> delegate;

@end

