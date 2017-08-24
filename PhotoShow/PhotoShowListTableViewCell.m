//
//  PhotoShowListTableViewCell.m
//  PhotoShow
//
//  Created by SFC-a on 2017/7/22.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "PhotoShowListTableViewCell.h"

@implementation PhotoShowListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(AlbumModel *)model{
    _model = model;
//    @property (weak, nonatomic) IBOutlet UIImageView *album_headerImg;
//    @property (weak, nonatomic) IBOutlet UILabel *album_time;
//    
//    @property (weak, nonatomic) IBOutlet UILabel *album_name;
    [self.album_headerImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseAPI,model.albumPhoto]] placeholderImage:[UIImage imageNamed:image_placeholder]];
    self.album_name.text = model.albumName;
    NSDictionary * timeDic = model.createTime;
    self.album_time.text = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",timeDic[@"year"],timeDic[@"monthValue"],timeDic[@"dayOfMonth"],timeDic[@"hour"],timeDic[@"minute"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
