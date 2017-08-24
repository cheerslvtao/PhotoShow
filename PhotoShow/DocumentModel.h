//
//  DocumentModel.h
//  PhotoShow
//
//  Created by SFC-a on 2017/8/7.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "BaseModel.h"

@interface DocumentModel : BaseModel


@property (nonatomic,retain) NSString * fileName;
@property (nonatomic,retain) NSString * filePage;
@property (nonatomic,retain) NSString * fileSize;
@property (nonatomic,retain) NSString * fileType;
@property (nonatomic,retain) NSString * fileUrl;
@property (nonatomic,retain) NSString * fileId;
@property (nonatomic,retain) NSString * userId;

@end
