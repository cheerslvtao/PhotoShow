//
//  AlbumModel.h
//  PhotoShow
//
//  Created by SFC-a on 2017/7/22.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlbumModel : NSObject


@property (nonatomic,retain) NSString * albumId;
@property (nonatomic,retain) NSString * userId;
@property (nonatomic,retain) NSString * albumName;
@property (nonatomic,retain) NSString * albumType;
@property (nonatomic,retain) NSString * albumTemplateId;
@property (nonatomic,retain) NSString * startTime;
@property (nonatomic,retain) NSString * endTime;
@property (nonatomic,retain) NSString * status;
@property (nonatomic,retain) NSString * albumPhoto;
@property (nonatomic,retain) NSString * creditNum;
@property (nonatomic,retain) NSDictionary * createTime;
@property (nonatomic,retain) NSString * url;


@end
