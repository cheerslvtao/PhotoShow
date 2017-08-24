//
//  LTDatePicker.h
//  PickViewDemo
//
//  Created by 吕涛 on 16/8/5.
//  Copyright © 2016年 吕涛. All rights reserved.
//

#import <UIKit/UIKit.h>

// 这个 block 返回选择的日期
typedef void(^returnTimeBlock)(NSString * time);

@interface LTDatePicker : UIView

@property (nonatomic,copy) returnTimeBlock returnBlock;

@property (nonatomic,strong) UIDatePicker * datePicker;

@end
