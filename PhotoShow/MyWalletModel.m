//
//  MyWalletModel.m
//  PhotoShow
//
//  Created by SFC-a on 2017/8/5.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "MyWalletModel.h"

@implementation MyWalletModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.walletid = value;
    }
}

@end
