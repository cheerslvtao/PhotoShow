//
//  AlbumModel.m
//  PhotoShow
//
//  Created by SFC-a on 2017/7/22.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "AlbumModel.h"

@implementation AlbumModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.albumId = value;
    }
}


@end
