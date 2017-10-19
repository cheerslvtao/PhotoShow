//
//  AlipayHandle.h
//  PhotoShow
//
//  Created by SFC-a on 2017/8/25.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol alipayDelegate <NSObject>

/** 处理好的orderstring */
-(void)payWith:(NSString *)orderString;

@end

@interface AlipayHandle : NSObject



@property (nonatomic,weak) id <alipayDelegate> delegate;

+(AlipayHandle *)shareAlipay;

- (void)AlipayPayWithOrderName:(NSString *)orderName orderNo:(NSString *)orderNo orderAmount:(NSString *)price;

@end
