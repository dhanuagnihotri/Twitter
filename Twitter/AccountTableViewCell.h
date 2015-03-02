//
//  AccountTableViewCell.h
//  Twitter
//
//  Created by Dhanu Agnihotri on 3/1/15.
//  Copyright (c) 2015 ___SocietyTech___. All rights reserved.
//

#import <UIKit/UIKit.h>


@class AccountTableViewCell;

@protocol AccountCellDelegate <NSObject>

-(void)deleteUser:(AccountTableViewCell *)cell;

@end

@interface AccountTableViewCell : UITableViewCell

@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *screenName;
@property (strong,nonatomic) NSString *profileImageURL;
@property (nonatomic,weak) id<AccountCellDelegate> delegate;

@end


