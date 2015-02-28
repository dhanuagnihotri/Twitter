//
//  MenuViewController.h
//  Twitter
//
//  Created by Dhanu Agnihotri on 2/25/15.
//  Copyright (c) 2015 ___SocietyTech___. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuViewController;

@protocol MenuViewControllerDelegate <NSObject>

-(void)indexChanged:(MenuViewController *)controller index:(NSInteger)index;

@end

@interface MenuViewController : UIViewController

@property (nonatomic,weak) id<MenuViewControllerDelegate> delegate;

@end
