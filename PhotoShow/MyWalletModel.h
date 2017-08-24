//
//  MyWalletModel.h
//  PhotoShow
//
//  Created by SFC-a on 2017/8/5.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "BaseModel.h"

@interface MyWalletModel : BaseModel

@property (nonatomic,retain) NSString * walletid;
@property (nonatomic,retain) NSString * userId;
@property (nonatomic,retain) NSString * credit;
@property (nonatomic,retain) NSString * creditType;
@property (nonatomic,retain) NSString * albumPhoneId;
@property (nonatomic,retain) NSString * createDate;


/** 余额 */
@property (nonatomic,retain) NSString * money;
@property (nonatomic,retain) NSString * rewardType;
@property (nonatomic,retain) NSString * inviteUser;

@end
