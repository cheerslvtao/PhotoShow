//
//  PhotosModel.m
//  PhotoShow
//
//  Created by SFC-a on 2017/8/7.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "PhotosModel.h"

@implementation PhotosModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if([key isEqualToString:@"id"]){
        self.photoid = value;
    }
}

@end
