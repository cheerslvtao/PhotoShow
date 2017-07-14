//
//  UMManager.h
//  PhotoShow
//
//  Created by SFC-a on 2017/7/13.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMSocialCore/UMSocialCore.h>

@interface UMShareInfoModel : NSObject
/** 控制器指针 */
@property (nonatomic,retain) UIViewController * vc;
/** 分享平台 */
@property (nonatomic) UMSocialPlatformType platfromType;
/** 图片 */
@property (nonatomic,retain) NSString * thumbURL;
/** 网页地址 */
@property (nonatomic,retain) NSString * webpageUrl;
/** 分享标题 */
@property (nonatomic,retain) NSString * shareTitle;
/** 分享消息 */
@property (nonatomic,retain) NSString * shareMsg;

@end

@interface UMManager : NSObject

+(void) initUM;
+(void)share:(UMShareInfoModel *)um;

@end

