//
//  AddressModel.h
//  PhotoShow
//
//  Created by SFC-a on 2017/8/4.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "BaseModel.h"

@interface AddressModel : BaseModel

@property (nonatomic,retain) NSString * addressId;
@property (nonatomic,retain) NSString * userId;
@property (nonatomic,retain) NSString * name;
@property (nonatomic,retain) NSString * phone;
@property (nonatomic,retain) NSString * province;
@property (nonatomic,retain) NSString * city;
@property (nonatomic,retain) NSString * county;
@property (nonatomic,retain) NSString * address;
@property (nonatomic,retain) NSString * isDefault;

@end
