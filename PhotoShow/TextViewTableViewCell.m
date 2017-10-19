//
//  TextViewTableViewCell.m
//  PhotoShow
//
//  Created by SFC-a on 2017/8/31.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "TextViewTableViewCell.h"

@implementation TextViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentTextView.layer.borderWidth =1;
    self.contentTextView.layer.borderColor = THEMEBGCOLOR.CGColor;
    self.contentTextView.layer.cornerRadius = 5;
    self.contentTextView.text = @"写下此刻心情...";

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
