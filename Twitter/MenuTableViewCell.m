//
//  MenuTableViewCell.m
//  Twitter
//
//  Created by Dhanu Agnihotri on 2/26/15.
//  Copyright (c) 2015 ___SocietyTech___. All rights reserved.
//

#import "MenuTableViewCell.h"

@implementation MenuTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor colorWithRed:0.467 green:0.718 blue:0.929 alpha:1] ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
