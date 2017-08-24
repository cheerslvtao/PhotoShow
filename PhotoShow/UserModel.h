//
//  UserModel.h
//  PhotoShow
//
//  Created by SFC-a on 2017/8/4.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface UserModel : BaseModel

@property (nonatomic)        CGFloat  money;
@property (nonatomic,retain) NSString *phone;
@property (nonatomic,retain) NSString *sex;
@property (nonatomic,retain) NSString *nickname;
@property (nonatomic)        CGFloat  credit;
@property (nonatomic,retain) NSString *headPortrait;
@property (nonatomic,retain) NSString *email;
@property (nonatomic,retain) NSString *username;
@property (nonatomic,retain) NSString *realname;

@end
