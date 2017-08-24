//
//  AddressTableViewCell.h
//  PhotoShow
//
//  Created by SFC-a on 2017/7/21.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"

@protocol AddressInfoDelegate <NSObject>

/** 修改 */
-(void)fixedAddressInfo:(AddressModel *)addressmodel;
/** 删除 */
-(void)deleteAddress:(NSString *)addressId;

/** 刷新数据 */
-(void)tableviewReloadData;

@end

@interface AddressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *userNameAndPhoneNum;
@property (weak, nonatomic) IBOutlet UILabel *userAddressInfo;
@property (weak, nonatomic) IBOutlet UIButton *fixedButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;


@property (nonatomic,retain) NSArray * modelArr;

@property (nonatomic,weak) id<AddressInfoDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *defaultAddress;
@property (nonatomic,retain) AddressModel * model;

@end
