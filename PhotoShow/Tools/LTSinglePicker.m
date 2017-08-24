//
//  LTSinglePicker.m
//  PickViewDemo
//
//  Created by SFC-a on 2017/8/7.
//  Copyright © 2017年 吕涛. All rights reserved.
//

#import "LTSinglePicker.h"

@implementation LTSinglePicker


-(instancetype)initWithFrame:(CGRect)frame dataArr:(NSArray *)datas{
    if (self = [super initWithFrame: frame]) {
        self.backgroundColor = [UIColor colorWithRed:244/255.0 green:245/255.0 blue:247/255.0 alpha:1];
        self.dataArr = datas;
        [self createUI];
    }
    return self;
}

-(void)createUI{
    for (int i=0; i < 2; i++){
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i==0) {
            btn.frame = CGRectMake(10, 0, 60, 40);
            [btn setTitle:@"取消" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(cancelSelect) forControlEvents:UIControlEventTouchUpInside];
        }else{
            btn.frame = CGRectMake(self.bounds.size.width - 70, 0, 60, 40);
            [btn setTitle:@"确定" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(sureSelect) forControlEvents:UIControlEventTouchUpInside];
        }
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:btn];
    }
    
    self.pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, self.bounds.size.width, self.bounds.size.height - 40)];
    self.pickView.delegate = self;
    self.pickView.dataSource =self;
    
    [self addSubview:self.pickView];
    
}
-(void)cancelSelect{
    self.block(nil);
}
-(void)sureSelect{
    self.block(_result);
}

#pragma mark = = UIPickerViewDataSource
//共有几组
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
//每组有多少项
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return  self.dataArr.count;
}

#pragma mark = =  UIPickerViewDelegate
//每组的宽
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return self.bounds.size.width;
}
//每组的高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 40;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.dataArr[row][@"name"];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.result = self.dataArr[row];
}


@end
