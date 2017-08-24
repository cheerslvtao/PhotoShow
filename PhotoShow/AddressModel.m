//
//  AddressModel.m
//  PhotoShow
//
//  Created by SFC-a on 2017/8/4.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "AddressModel.h"

@implementation AddressModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.addressId = value;
    }
}

@end
