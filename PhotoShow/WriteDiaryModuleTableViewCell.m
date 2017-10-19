//
//  WriteDiaryModuleTableViewCell.m
//  PhotoShow
//
//  Created by SFC-a on 2017/8/31.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "WriteDiaryModuleTableViewCell.h"

@implementation WriteDiaryModuleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectedImageView = [[UIImageView alloc]init];
    self.selectedImageView.image = [UIImage imageNamed:@"photo_selected"];
    self.textTop.layer.borderColor = RGBA(123, 197, 36, 1).CGColor;
    self.textTop.layer.borderWidth = 3;
    self.textTop.selected = YES;
    [self selectedModule:self.textTop];

}
- (IBAction)textTopSelected:(UIButton *)sender {

    [self selectedModule:sender];
    self.textTop.layer.borderColor = RGBA(123, 197, 36, 1).CGColor;
    self.textTop.layer.borderWidth = 3;
    self.textDown.layer.borderWidth = 0;
    self.textDown.selected = NO;
    sender.selected = YES;
}
- (IBAction)textDownSelected:(UIButton *)sender {
    [self selectedModule:sender];
    self.textDown.layer.borderColor = RGBA(123, 197, 36, 1).CGColor;
    self.textDown.layer.borderWidth = 3;
    self.textTop.layer.borderWidth = 0;
    self.textTop.selected = NO;
    sender.selected = YES;
}

-(void)selectedModule:(UIButton *)sender{
    [self.selectedImageView removeFromSuperview];
    [sender addSubview:self.selectedImageView];
    [self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.offset(-2);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
