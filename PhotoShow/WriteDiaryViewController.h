//
//  WriteDiaryViewController.h
//  PhotoShow
//
//  Created by SFC-a on 2017/8/31.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "BaseViewController.h"

@interface WriteDiaryViewController : BaseViewController


/** 
 
 日记保存 带照片/api/createDiaryPhoto
 imageData,address,weather,weather_url,mood,photo_time,type 类型 01 图片在上，02图片在下，03没有图片

 日记保存 不带照片 /api/createDiary
 address,weather,weather_url,mood,photo_time
 
 
 查询用户日记本 /api/getDiarys
 startTime,endTime,page,size
 
 */
@end
