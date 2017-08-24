//
//  MyWalletBaseViewController.h
//  PhotoShow
//
//  Created by SFC-a on 2017/7/25.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "BaseViewController.h"
#import "MyWallet.h"
#import "MywalletTableViewCell.h"
#import "MyWalletModel.h"

typedef enum : NSUInteger {
    YUEType,
    JIFENType,
} walletType;

@interface MyWalletBaseViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>

/** 数据源 */
@property (nonatomic,retain) NSMutableArray * dataArr;
@property (nonatomic,retain) NSMutableArray * YuEdataArr;
@property (nonatomic,retain) NSMutableArray * jifenDataArr;

/** 表 */
@property (nonatomic,retain) UITableView * mywalletTableView;

/** 类型 （余额、积分） */
@property (nonatomic) walletType type;

/** 展示积分余额总数 */
@property (nonatomic,retain) MyWallet * topView;

/** headerview */
@property (nonatomic,retain) UIView * headerView;

/** section header View */
@property (nonatomic,retain) UIView * sectionView;

/** 是否是下拉刷新 */
@property (nonatomic)BOOL isRefresh;

@property (nonatomic,retain) NSString * case_fee; //手续费

/** 开始刷新 */
-(void)beginRefresh;
/** 结束刷新 */
-(void)endRefresh;


@end

