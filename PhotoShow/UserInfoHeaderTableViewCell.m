//
//  UserInfoHeaderTableViewCell.m
//  PhotoShow
//
//  Created by SFC-a on 2017/7/20.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "UserInfoHeaderTableViewCell.h"

@implementation UserInfoHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.userHeaderView.clipsToBounds = YES;
    self.userHeaderView.layer.cornerRadius = self.userHeaderView.frame.size.width/2;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
