//
//  AddNewAlbumViewModel.h
//  PhotoShow
//
//  Created by SFC-a on 2017/8/7.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TemplateModel.h"
#import "PhotosModel.h"

@interface AddNewAlbumViewModel : NSObject

/** 

 获取相册模板列表
 模板类型
    01生活日记，02旅游相册，03成长相册
*/
+(void)getTemplateListWithType:(NSString *)type temlateContainer:(UIScrollView *)container Block:(void(^)(NSArray <TemplateModel *> *))block;


/**
    获取用户所有的照片
    params : startTime  endTime  page   size
 */
+(void)getUserAllPhotosWithParameters:(NSDictionary *)params block:(void(^)(NSArray <PhotosModel *> *))block failure:(void(^)(NSError *error))faile;




@end
