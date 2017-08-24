//
//  AddressViewController.h
//  PhotoShow
//
//  Created by SFC-a on 2017/7/21.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "BaseViewController.h"

@class AddressModel;

@protocol SelectAddressDelegate <NSObject>

-(void)selectAddress:(AddressModel * )model;

@end

@interface AddressViewController : BaseViewController

@property (nonatomic,weak) id<SelectAddressDelegate> delegate;

@end
