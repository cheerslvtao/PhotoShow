//
//  PhotoShowListTableViewCell.h
//  PhotoShow
//
//  Created by SFC-a on 2017/7/22.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumModel.h"
@interface PhotoShowListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *album_headerImg;
@property (weak, nonatomic) IBOutlet UILabel *album_time;

@property (weak, nonatomic) IBOutlet UILabel *album_name;

@property (nonatomic,retain) AlbumModel * model;

@end
