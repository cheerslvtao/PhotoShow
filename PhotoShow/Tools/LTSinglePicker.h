//
//  LTSinglePicker.h
//  PickViewDemo
//
//  Created by SFC-a on 2017/8/7.
//  Copyright © 2017年 吕涛. All rights reserved.
//

#import <UIKit/UIKit.h>

// 这个 block 返回选择
typedef void(^returnBlock)(NSDictionary * result);

@interface LTSinglePicker : UIView<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,copy) returnBlock block;

@property (nonatomic,strong) UIPickerView * pickView ;

@property (nonatomic,strong) NSArray * dataArr;

@property (nonatomic,retain) NSDictionary * result;

-(instancetype)initWithFrame:(CGRect)frame dataArr:(NSArray *)datas;

@end
