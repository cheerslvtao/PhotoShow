//
//  SubmitOrderViewController.h
//  PhotoShow
//
//  Created by SFC-a on 2017/7/24.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "BaseViewController.h"
#import "AlbumModel.h"
#import "DocumentModel.h"

@interface SubmitOrderViewController : BaseViewController

/** 相册 */
@property (nonatomic,retain) AlbumModel * albumModel;
/** 文档 */
@property (nonatomic,retain) DocumentModel * docModel;

@end
