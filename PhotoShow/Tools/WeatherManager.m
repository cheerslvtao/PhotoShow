//
//  WeatherManager.m
//  PhotoShow
//
//  Created by SFC-a on 2017/7/28.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "WeatherManager.h"

@implementation WeatherManager

+(void)getWeather:(getWeatherSuccessBlock)success{
    NSString *appcode = @"5291f413ae324e0482ed1fdcc880897f";
    NSString *host = @"https://ali-weather.showapi.com";
    NSString *path = @"/gps-to-weather";
    NSString *method = @"GET";
    NSString *querys = @"?from=3&lat=40.242266&lng=116.2278&need3HourForcast=0&needAlarm=0&needHourData=0&needIndex=0&needMoreDay=0";
    NSString *url = [NSString stringWithFormat:@"%@%@%@",  host,  path , querys];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: url]  cachePolicy:1  timeoutInterval:  5];
    request.HTTPMethod  =  method;
    [request addValue:  [NSString  stringWithFormat:@"APPCODE %@" ,  appcode]  forHTTPHeaderField:  @"Authorization"];
    NSURLSession *requestSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task = [requestSession dataTaskWithRequest:request
                                                   completionHandler:^(NSData * _Nullable body , NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                       NSLog(@"Response object: %@" , response);
                                                       
                                                       success([NSJSONSerialization JSONObjectWithData:body options:NSJSONReadingMutableContainers error:nil]);

                                                   }];
    [task resume];
    
    
}

@end
