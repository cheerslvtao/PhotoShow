//
//  AddNewAlbumViewController.h
//  PhotoShow
//
//  Created by SFC-a on 2017/7/23.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^AlbumCreatedSuccess)();

@interface AddNewAlbumViewController : BaseViewController

@property (nonatomic,copy) AlbumCreatedSuccess successBlock;

@property (nonatomic,retain) NSString * albumType;
@property (nonatomic,retain) NSString * albumName;

@end
