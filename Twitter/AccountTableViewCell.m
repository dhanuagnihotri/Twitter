//
//  AccountTableViewCell.m
//  Twitter
//
//  Created by Dhanu Agnihotri on 3/1/15.
//  Copyright (c) 2015 ___SocietyTech___. All rights reserved.
//

#import "AccountTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface AccountTableViewCell ()
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;

@end

@implementation AccountTableViewCell

- (void)awakeFromNib {
    // Initialization code
     self.backgroundColor = [UIColor colorWithRed:0.467 green:0.718 blue:0.929 alpha:1] ;
    self.profileImageView.layer.cornerRadius = 3;
    self.profileImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    self.nameLabel.text = self.name;
    self.screenNameLabel.text = self.screenName;
    [self.profileImageView setImageWithURL:[NSURL URLWithString:self.profileImageURL]];

}
@end
