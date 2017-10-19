//
//  UMManager.m
//  PhotoShow
//
//  Created by SFC-a on 2017/7/13.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "UMManager.h"

@implementation UMShareInfoModel

@end

@implementation UMManager

+(void)initUM{
    /** 打开log日志 */
#ifdef DEBUG
    [[UMSocialManager defaultManager] openLog:YES];
#endif
    
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMAppKey];
    
    //微信
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WechatAppKey appSecret:WechatAppSecret redirectURL:@""];
    //删除微信收藏
    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformType:UMSocialPlatformType_WechatFavorite];
    
    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_AlipaySession appKey:AlipayAppkey appSecret:nil redirectURL:nil];
}


+(void)share:(UMShareInfoModel *)um{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:um.shareTitle descr:um.shareMsg thumImage:[UIImage imageNamed:@"logo"]];
    //设置网页地址
    shareObject.webpageUrl = um.webpageUrl;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:um.platfromType messageObject:messageObject currentViewController:um.vc completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}



@end
