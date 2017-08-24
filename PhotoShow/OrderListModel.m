//
//  OrderListModel.m
//  PhotoShow
//
//  Created by SFC-a on 2017/8/13.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "OrderListModel.h"

@implementation OrderListModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if([key isEqualToString:@"id"] ){
        self.orderId = value;
    }
}

@end
