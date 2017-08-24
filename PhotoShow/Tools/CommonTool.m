//
//  CommonTool.m
//  PhotoShow
//
//  Created by SFC-a on 2017/7/14.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "CommonTool.h"


@implementation CommonTool

#pragma mark - 设置vView背景颜色
/** 设置颜色 */
+(void)setBGColor:(UIView *)obj R:(NSInteger)r G:(NSInteger)g B:(NSInteger)b A:(NSInteger)a{
    obj.backgroundColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
}

#pragma mark - 切换跟视图
+(void)changeRootViewController:(UIViewController *)vc {
    UIWindow * mainwindow = [[UIApplication sharedApplication].delegate window];
    mainwindow.rootViewController = vc;
}


#pragma mark - 字典---json转换
/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

//词典转换为字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


#pragma mark - 获取个人信息
+(NSDictionary *)getUserInfo{
    return [self dictionaryWithJsonString:[NSUSERDEFAULT objectForKey:@"userinfo"]];
}

+(void)setUserInfo:(NSDictionary *)userinfoDic{
    [NSUSERDEFAULT setObject:[self dictionaryToJson:userinfoDic] forKey:@"userinfo"];
    [NSUSERDEFAULT synchronize];
}


#pragma mark - 时间戳转换
/** 时间戳 转时间格式 */
+(NSString *)dateStringFromData:(NSTimeInterval)date{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString * dateString = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:date/1000]];
    return dateString;
}

+(NSString *)getCurrentTime{
    NSDate * date = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:date];
}

#pragma mark - 退出登录
+(void)logout{
    [NSUSERDEFAULT removeObjectForKey:key_userinfo];
    [NSUSERDEFAULT removeObjectForKey:@"token"];
}


#pragma mark - 获取相册类型
+(NSString *)getAlbumType:(NSString *)type{
    if ([type isEqualToString:@"01"]) {
        return @"生活日记";
    }else if ([type isEqualToString:@"02"]){
        return @"旅游相册";
    }else if ([type isEqualToString:@"03"]){
        return @"成长相册";
    }
    return @"文档";
}

@end
