//
//  MyOrderTableViewCell.h
//  PhotoShow
//
//  Created by SFC-a on 2017/7/21.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListModel.h"

@interface MyOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *topBGView;
@property (weak, nonatomic) IBOutlet UILabel *orderStatus;

@property (weak, nonatomic) IBOutlet UILabel *orderCode;

@property (weak, nonatomic) IBOutlet UILabel *AlbumName;
@property (weak, nonatomic) IBOutlet UILabel *albumType;

@property (weak, nonatomic) IBOutlet UILabel *albumNumber;
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UILabel *orderPrice;

@property (nonatomic,retain) OrderListModel * orderModel;

@end
