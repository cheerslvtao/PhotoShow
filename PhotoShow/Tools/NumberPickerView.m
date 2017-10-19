//
//  NumberPickerView.m
//  PhotoShow
//
//  Created by SFC-a on 2017/7/25.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "NumberPickerView.h"

@implementation NumberPickerView
{
    int _number;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _number = 1;
        [self createUI];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _number = 1;
        [self createUI];
    }
    return self;
}

-(void)createUI{
    
    self.layer.borderColor = RGBA(147, 148, 149, 1).CGColor;
    self.layer.borderWidth = 1;
    self.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    
    UIButton * reduceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [reduceButton setTitle:@"-" forState:UIControlStateNormal];
    [reduceButton setTitleColor:RGBA(61, 62, 63, 1) forState:UIControlStateNormal];
    [reduceButton addTarget:self action:@selector(reduceNumber:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:reduceButton];
    [reduceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.offset(0);
        make.width.offset(30);
    }];
   
    
    _numberTextField = [[UITextField alloc]init];
    _numberTextField.delegate = self;
    _numberTextField.layer.borderColor = RGBA(147, 148, 149, 1).CGColor;
    _numberTextField.layer.borderWidth = 1;
    _numberTextField.text = @"1";
    _numberTextField.textAlignment = NSTextAlignmentCenter;
    _numberTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:_numberTextField];

    [_numberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.equalTo(reduceButton.mas_right).offset(0);
        make.width.mas_equalTo(35);
    }];
    
    
    UIButton * addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setTitle:@"+" forState:UIControlStateNormal];
    [addButton setTitleColor:RGBA(61, 62, 63, 1) forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addNumber:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addButton];

    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.offset(0);
        make.width.equalTo(reduceButton.mas_width);
        make.left.equalTo(_numberTextField.mas_right).offset(0);
    }];
    
}

-(void)reduceNumber:(UIButton *)reduceBtn{
    
    if(_number > 1){
        _number--;
        _numberTextField.text = [NSString stringWithFormat:@"%d",_number];
        self.numberChanged([NSString stringWithFormat:@"%d",_number]);
    }
}


-(void)addNumber:(UIButton *)reduceBtn{
    _number++;
    self.numberChanged([NSString stringWithFormat:@"%d",_number]);
    _numberTextField.text = [NSString stringWithFormat:@"%d",_number];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.numberChanged(textField.text);
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"textfield text %@",textField.text);
    NSLog(@"%ld -- %ld",range.location,range.length);
    NSLog(@"replacementString %@",string);
    
    return YES;
}



@end
