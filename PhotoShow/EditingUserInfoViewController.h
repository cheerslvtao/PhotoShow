//
//  EditingUserInfoViewController.h
//  PhotoShow
//
//  Created by SFC-a on 2017/8/4.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "BaseViewController.h"


typedef void(^reloaduserInfo)();
@interface EditingUserInfoViewController : BaseViewController


/** 
    是否是编辑个人信息
    yes  个人信息编辑
    no   提现申请
 */
@property (nonatomic)BOOL isEditingUserInfo;

/** 如果是提现需要传递 手续费 */
@property (nonatomic,retain) NSString * cash_fee;
@property (nonatomic,retain) NSString * currentMoney;

/** 
    用户信息
 */
@property (nonatomic,retain) NSMutableArray * userInfoArr;

@property (nonatomic,copy) reloaduserInfo reloadBlock;

@end
