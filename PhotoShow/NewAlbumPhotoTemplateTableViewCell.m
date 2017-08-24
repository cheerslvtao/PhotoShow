//
//  NewAlbumPhotoTemplateTableViewCell.m
//  PhotoShow
//
//  Created by SFC-a on 2017/7/23.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "NewAlbumPhotoTemplateTableViewCell.h"

@implementation NewAlbumPhotoTemplateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}


-(NSArray *)templateArr{
    if (!_templateArr) {
        _templateArr = [[ NSArray alloc]init];
    }
    return _templateArr ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
