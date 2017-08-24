//
//  WeatherManager.h
//  PhotoShow
//
//  Created by SFC-a on 2017/7/28.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^getWeatherSuccessBlock)(id obj);
@interface WeatherManager : NSObject

+(void)getWeather:(getWeatherSuccessBlock)success;

@end
