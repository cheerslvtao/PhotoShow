//
//  EditingAlbumViewController.h
//  PhotoShow
//
//  Created by SFC-a on 2017/7/26.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSUInteger {
    EditingAlbum = 0,  /** 编辑相册 */
    AddAlbum, /** 新建相册 */
} EditingType;
@interface EditingAlbumViewController : BaseViewController

/** 拍照的照片数据 */
@property (nonatomic,retain) NSData * takePhotoImageData;

/** 编辑相册类型 添加还是编辑 */
@property (nonatomic) EditingType type;

/** 编辑相册的相册 id */
@property (nonatomic,retain) NSString * albumId;

@end
