//
//  HTTPTool.m
//  PhotoShow
//
//  Created by SFC-a on 2017/7/28.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "HTTPTool.h"
#import "MBProgressHUD.h"
#import "ImageManager.h"
//static NSString * baseAPI = @"http://60.205.158.57:1987/";

@implementation AFHttpClient

+ (instancetype)sharedClient {
    
    static AFHttpClient * client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        client = [[AFHttpClient alloc] initWithBaseURL:[NSURL URLWithString:baseAPI] sessionConfiguration:configuration];
        //接收参数类型
        client.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript",@"text/plain",@"image/gif",@"application/x-www-form-urlencoded; charset=utf-8", nil];
        
        //设置超时时间
        client.requestSerializer.timeoutInterval = 20;
        //安全策略
        client.securityPolicy = [AFSecurityPolicy defaultPolicy];
    });
    
    return client;
}

@end

@implementation HTTPTool

+ (void)getWithPath:(NSString *)path
             params:(NSDictionary *)params
            success:(HttpSuccessBlock)success
            failure:(HttpFailureBlock)failure {
    
    //获取完整的url路径
    NSString * url = [baseAPI stringByAppendingPathComponent:path];
    
    [[AFHttpClient sharedClient] GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
        
    }];
    
}

+ (void)getWeatherSuccess:(HttpSuccessBlock)success
                   failure:(HttpFailureBlock)failure {
    
    NSString *appcode = @"5291f413ae324e0482ed1fdcc880897f";
    NSString *host = @"https://ali-weather.showapi.com";
    NSString *path = @"/gps-to-weather";
    NSString *querys = @"?from=3&lat=40.242266&lng=116.2278&need3HourForcast=0&needAlarm=0&needHourData=0&needIndex=0&needMoreDay=0";
    NSString *url = [NSString stringWithFormat:@"%@%@%@",  host,  path , querys];
    
    //这只请求头
    [[[AFHttpClient sharedClient] requestSerializer] setValue:[NSString stringWithFormat:@"APPCODE %@" ,  appcode] forHTTPHeaderField:@"Authorization"];
    
    [[AFHttpClient sharedClient] GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         failure(error);
    }];
    
}

+ (void)postWithPath:(NSString *)path
              params:(NSDictionary *)params
             success:(HttpSuccessBlock)success
             failure:(HttpFailureBlock)failure
            alertMsg:(NSString *)alertMsg
          successMsg:(NSString *)successMsg
             failMsg:(NSString *)failMsg
            showView:(UIView *)showView{
    [HUDManager showHUDWithMsg:alertMsg superView:showView];
    //获取完整的url路径
    NSString * url = [baseAPI stringByAppendingPathComponent:path];
    if ([NSUSERDEFAULT objectForKey:@"token"] && ![path isEqualToString:url_login]) {
        url = [NSString stringWithFormat:@"%@?access_token=%@",url,[NSUSERDEFAULT objectForKey:@"token"]];
    }
    if ([path isEqualToString:url_token]){
        NSString * clientID = params[@"client_id"];
        NSString * clientSecret = params[@"client_secret"];
        NSString * idAndSecret = [NSString stringWithFormat:@"%@:%@",clientID,clientSecret];
        NSData * credentialData = [idAndSecret dataUsingEncoding:NSUTF8StringEncoding];
        NSString * userString = [credentialData base64EncodedStringWithOptions:0];
        
        NSString * auth = [NSString stringWithFormat:@"Basic %@",userString];
        
        //这只请求头
        [[[AFHttpClient sharedClient] requestSerializer] setValue:auth forHTTPHeaderField:@"Authorization"];
    }

    
    NSLog(@"url  -  %@",url);
    NSLog(@"%@",params);
    
    [[AFHttpClient sharedClient] POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [HUDManager hideHUDAfter:0.1 withMsg:successMsg];
        NSLog(@"%@",responseObject);
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [HUDManager hideHUDAfter:0.1 withMsg:failMsg];
        NSLog(@"%@",error);
        failure(error);
        
    }];
    
}

+ (void)postWithPath:(NSString *)path
              params:(NSDictionary *)params
             success:(HttpSuccessBlock)success
             failure:(HttpFailureBlock)failure{
    
    //获取完整的url路径
    NSString * url = [baseAPI stringByAppendingPathComponent:path];

    if ([path isEqualToString:url_token]){
        NSString * clientID = params[@"client_id"];
        NSString * clientSecret = params[@"client_secret"];
        NSString * idAndSecret = [NSString stringWithFormat:@"%@:%@",clientID,clientSecret];
        NSData * credentialData = [idAndSecret dataUsingEncoding:NSUTF8StringEncoding];
        NSString * userString = [credentialData base64EncodedStringWithOptions:0];
        
        NSString * auth = [NSString stringWithFormat:@"Basic %@",userString];
        
        //这只请求头
        [[[AFHttpClient sharedClient] requestSerializer] setValue:auth forHTTPHeaderField:@"Authorization"];
    }else if ([NSUSERDEFAULT objectForKey:@"token"] && ![path isEqualToString:url_login]) {
        url = [NSString stringWithFormat:@"%@?access_token=%@",url,[NSUSERDEFAULT objectForKey:@"token"]];
    }
    
    
    NSLog(@"url  -  %@",url);
    NSLog(@"%@",params);
    [[AFHttpClient sharedClient] POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"%@",responseObject);
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        failure(error);
        
    }];
    
}

+(void)patchWithPath:(NSString *)path
              params:(NSDictionary *)params
             success:(HttpSuccessBlock)success
             failure:(HttpFailureBlock)failure{
    //获取完整的url路径
    NSString * url = [baseAPI stringByAppendingPathComponent:path];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    AFJSONRequestSerializer *serializer = [[AFJSONRequestSerializer alloc] init];
    serializer.writingOptions =0;
    manager.requestSerializer = serializer;
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager PATCH:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}


+ (void)downloadWithPath:(NSString *)path
                 success:(HttpSuccessBlock)success
                 failure:(HttpFailureBlock)failure
                progress:(HttpDownloadProgressBlock)progress {
    
    //获取完整的url路径
    NSString * urlString = [baseAPI stringByAppendingPathComponent:path];
    
    //下载
    NSURL *URL = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [[AFHttpClient sharedClient] downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        progress(downloadProgress.fractionCompleted);
        
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        //获取沙盒cache路径
        NSURL * documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        if (error) {
            failure(error);
        } else {
            success(filePath.path);
        }
        
    }];
    
    [downloadTask resume];
    
}

+ (void)uploadImageWithPath:(NSString *)path
                     params:(NSDictionary *)params
                  thumbName:(NSString *)imagekey
                      image:(UIImage *)image
                    success:(HttpSuccessBlock)success
                    failure:(HttpFailureBlock)failure
                   progress:(HttpUploadProgressBlock)progress {
    
    //获取完整的url路径
    NSString * urlString = [baseAPI stringByAppendingPathComponent:path];
    urlString = [NSString stringWithFormat:@"%@?access_token=%@",urlString,[NSUSERDEFAULT objectForKey:@"token"]];
    NSData * data = UIImageJPEGRepresentation(image, 0.1);
    NSLog(@"datalength  %lu",[data length]/1024);
    UIWindow * window = [[UIApplication sharedApplication].delegate window];
    [HUDManager showHUDWithMsg:@"正在上传..." superView:window];
    
    [[AFHttpClient sharedClient] POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
//        if (type == ImageTypeJPEG || type == ImageTypeJPEG2000) {
//            [formData appendPartWithFileData:data name:imagekey fileName:@"header.png" mimeType:@"image/jpeg"];
//        }else{
            [formData appendPartWithFileData:data name:imagekey fileName:@"header.png" mimeType:@"image/png"];
//        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        progress(uploadProgress.fractionCompleted);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 200 && [responseObject[@"success"] integerValue] == 1){
            [HUDManager hideHUDAfter:1 withMsg:@"上传成功"];
            success(responseObject);
        }else{
            NSLog(@"%@",responseObject);
            [HUDManager hideHUDAfter:1 withMsg:responseObject[@"msg"]];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [HUDManager hideHUDAfter:1 withMsg:@"上传失败，请重试"];

        failure(error);
        
    }];
    
}

+ (void)uploadImageWithPath:(NSString *)path
                     params:(NSDictionary *)params
                  thumbName:(NSString *)imagekey
                   fileName:(NSString *)fileName
                      file:(NSData *)fileData
                    success:(HttpSuccessBlock)success
                    failure:(HttpFailureBlock)failure
                   progress:(HttpUploadProgressBlock)progress {
    
    //获取完整的url路径
    NSString * urlString = [baseAPI stringByAppendingPathComponent:path];
    urlString = [NSString stringWithFormat:@"%@?access_token=%@",urlString,[NSUSERDEFAULT objectForKey:@"token"]];
    UIWindow * window = [[UIApplication sharedApplication].delegate window];
    [HUDManager showHUDWithMsg:@"正在上传..." superView:window];
    
    [[AFHttpClient sharedClient] POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:fileData name:imagekey fileName:fileName mimeType:@"application/pdf"];

    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        progress(uploadProgress.fractionCompleted);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 200 && [responseObject[@"success"] integerValue] == 1){
            [HUDManager hideHUDAfter:1 withMsg:@"上传成功"];
            success(responseObject);
        }else{
            NSLog(@"%@",responseObject);
            [HUDManager hideHUDAfter:1 withMsg:responseObject[@"msg"]];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [HUDManager hideHUDAfter:1 withMsg:@"上传失败，请重试"];
        
        failure(error);
        
    }];
    
}


@end
