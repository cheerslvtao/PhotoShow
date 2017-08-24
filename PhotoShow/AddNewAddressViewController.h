//
//  AddNewAddressViewController.h
//  PhotoShow
//
//  Created by SFC-a on 2017/7/21.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "BaseViewController.h"
#import "AddressModel.h"
typedef void(^freshData)();
@interface AddNewAddressViewController : BaseViewController

@property (nonatomic,copy)freshData freshAddressData;

@property (nonatomic,retain) AddressModel * model;

@end
