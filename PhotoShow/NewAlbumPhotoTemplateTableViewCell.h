//
//  NewAlbumPhotoTemplateTableViewCell.h
//  PhotoShow
//
//  Created by SFC-a on 2017/7/23.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemplateModel.h"

@interface NewAlbumPhotoTemplateTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIScrollView *templateAlbumContainer;

@property (nonatomic,retain) NSArray * templateArr;

@end
