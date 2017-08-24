//
//  PhotosModel.h
//  PhotoShow
//
//  Created by SFC-a on 2017/8/7.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "BaseModel.h"

@interface PhotosModel : BaseModel

@property (nonatomic,retain) NSString * photoid;
@property (nonatomic,retain) NSString * address;
@property (nonatomic,retain) NSString * mood;
@property (nonatomic,retain) NSString * weather;
@property (nonatomic,retain) NSString * status;
@property (nonatomic,retain) NSString * photoTime;
@property (nonatomic,retain) NSString * createTime;
@property (nonatomic,retain) NSString * userId;
@property (nonatomic,retain) NSString * mongdbId;
@property (nonatomic,retain) NSString * photoUrl;
@property (nonatomic,retain) NSString * weatherUrl;

/** 所属的相册id */
@property (nonatomic,retain) NSString * albumId;

/** 是否选中 */
@property (nonatomic) BOOL isSelected;

@end
