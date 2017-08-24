//
//  MyWallet.h
//  PhotoShow
//
//  Created by SFC-a on 2017/7/25.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyWallet : UIView


/** 标题 */
@property (nonatomic,retain) UILabel * walletTitle;

/** 余额总数 积分总数 */
@property (nonatomic,retain) UILabel * walletTotal;

/** 手续费Label */
@property (nonatomic,retain) UILabel * cash_feeLabel;

@property (nonatomic) BOOL isMoney;

@property (nonatomic,copy) void(^getMoney)();

-(void)showOtherInfo;

@end
