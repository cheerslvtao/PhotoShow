//
//  NewAlbumPhotoCollectionViewCell.m
//  PhotoShow
//
//  Created by SFC-a on 2017/7/23.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "NewAlbumPhotoCollectionViewCell.h"

@implementation NewAlbumPhotoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)choosePhoto:(UIButton *)sender {
    sender.selected = !sender.selected;
}

@end
