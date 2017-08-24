//
//  TemplateModel.h
//  PhotoShow
//
//  Created by SFC-a on 2017/8/7.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "BaseModel.h"

@interface TemplateModel : BaseModel


@property (nonatomic,retain) NSString * templateid;
@property (nonatomic,retain) NSString * name;
@property (nonatomic,retain) NSString * type;
@property (nonatomic,retain) NSString * url;
@property (nonatomic,retain) NSString * imgUrl;
@property (nonatomic,retain) NSString * photoCount;
@property (nonatomic,retain) NSString * tempCount;
@property (nonatomic,retain) NSString * tempKey;

/** 选中模板的图片 */
@property (nonatomic,retain) UIImageView * selectedImageView;

@end
