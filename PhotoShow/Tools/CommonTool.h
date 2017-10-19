//
//  CommonTool.h
//  PhotoShow
//
//  Created by SFC-a on 2017/7/14.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 一些比较常用设置
 */
@interface CommonTool : NSObject
/** 设置颜色 */
+(void)setBGColor:(UIView *)obj R:(NSInteger)r G:(NSInteger)g B:(NSInteger)b A:(NSInteger)a;

/** 切换跟视图控制器 */
+(void)changeRootViewController:(UIViewController *)vc;


/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
//词典转换为字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;



/** 返回个人信息 */
+(NSDictionary *)getUserInfo;
/** 设置、更新个人信息 */
+(void)setUserInfo:(NSDictionary *)userinfoDic;


/** 时间戳 转时间格式 */
+(NSString *)dateStringFromData:(NSTimeInterval)date;
/** 获取当前时间 */
+(NSString *)getCurrentTime;


/** 退出登录  清除存储用户信息 */
+(void)logout;



/**
 get album type

 @param type 01 02 03 10
 @return 生活相册 。。。 
 */
+(NSString *)getAlbumType:(NSString *)type;


/**
 订单状态

 @param states 0待支付 1已支付/带审核 2审核成功 3待收货/待发货 4已发货 5已收货 6审核失败 7取消
 @return 返回state对应的文字
 */
+(NSString *)orderStates:(NSString *)states;



/**
 单按钮弹窗
 
 @param title 标题
 @param message 信息
 @param sure 点击按钮 回调
 */
+(void)alertWithTitle:(NSString *)title msg:(NSString *)message surebutton:(void (^)())sure;


@end
