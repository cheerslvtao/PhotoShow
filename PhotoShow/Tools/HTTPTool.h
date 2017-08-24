//
//  HTTPTool.h
//  PhotoShow
//
//  Created by SFC-a on 2017/7/28.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "HUDManager.h"

typedef void (^HttpSuccessBlock)(id json);
typedef void (^HttpFailureBlock)(NSError * error);
typedef void (^HttpDownloadProgressBlock)(CGFloat progress);
typedef void (^HttpUploadProgressBlock)(CGFloat progress);


@interface HTTPTool : NSObject

/**
 *  get网络请求
 *
 *  @param path    url地址
 *  @param params  url参数  NSDictionary类型
 *  @param success 请求成功 返回NSDictionary或NSArray
 *  @param failure 请求失败 返回NSError
 */

+ (void)getWithPath:(NSString *)path
             params:(NSDictionary *)params
            success:(HttpSuccessBlock)success
            failure:(HttpFailureBlock)failure;


/**
 带HUD POST 请求接口
 */
+ (void)postWithPath:(NSString *)path
              params:(NSDictionary *)params
             success:(HttpSuccessBlock)success
             failure:(HttpFailureBlock)failure
            alertMsg:(NSString *)alertMsg
          successMsg:(NSString *)successMsg
             failMsg:(NSString *)failMsg
            showView:(UIView *)showView;

/**
 *  post网络请求
 *
 *  @param path    url地址
 *  @param params  url参数  NSDictionary类型
 *  @param success 请求成功 返回NSDictionary或NSArray
 *  @param failure 请求失败 返回NSError
 */

+ (void)postWithPath:(NSString *)path
              params:(NSDictionary *)params
             success:(HttpSuccessBlock)success
             failure:(HttpFailureBlock)failure;

+(void)patchWithPath:(NSString *)path
              params:(NSDictionary *)params
             success:(HttpSuccessBlock)success
             failure:(HttpFailureBlock)failure;
/**
 *  下载文件
 *
 *  @param path     url路径
 *  @param success  下载成功
 *  @param failure  下载失败
 *  @param progress 下载进度
 */

+ (void)downloadWithPath:(NSString *)path
                 success:(HttpSuccessBlock)success
                 failure:(HttpFailureBlock)failure
                progress:(HttpDownloadProgressBlock)progress;

/**
 *  上传图片
 *
 *  @param path     url地址
 *  @param image    UIImage对象
 *  @param imagekey    imagekey
 *  @param params  上传参数
 *  @param success  上传成功
 *  @param failure  上传失败
 *  @param progress 上传进度
 */

+ (void)uploadImageWithPath:(NSString *)path
                     params:(NSDictionary *)params
                  thumbName:(NSString *)imagekey
                      image:(UIImage *)image
                    success:(HttpSuccessBlock)success
                    failure:(HttpFailureBlock)failure
                   progress:(HttpUploadProgressBlock)progress;


+ (void)uploadImageWithPath:(NSString *)path
                     params:(NSDictionary *)params
                  thumbName:(NSString *)imagekey
                   fileName:(NSString *)fileName
                       file:(NSData *)fileData
                    success:(HttpSuccessBlock)success
                    failure:(HttpFailureBlock)failure
                   progress:(HttpUploadProgressBlock)progress;
/**
 获取天气信息

 @param success 成功回调
 @param failure 失败回调
 */
+ (void)getWeatherSuccess:(HttpSuccessBlock)success
                  failure:(HttpFailureBlock)failure;

@end



@interface AFHttpClient : AFHTTPSessionManager

@property (nonatomic,strong) NSString * token;
+ (instancetype)sharedClient;


@end
