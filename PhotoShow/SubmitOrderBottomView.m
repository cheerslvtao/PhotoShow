//
//  SubmitOrderBottomView.m
//  PhotoShow
//
//  Created by SFC-a on 2017/7/25.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "SubmitOrderBottomView.h"

@implementation SubmitOrderBottomView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}


-(void)createUI{

    self.layer.shadowOffset = CGSizeMake(0, -1);
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.5;
    
    _orderPriceLabel = [[UILabel alloc]init];
    _orderPriceLabel.text = @"合计  ￥2323";
    _orderPriceLabel.backgroundColor = [UIColor whiteColor];
    _orderPriceLabel.textColor = RGBA(203, 0, 22, 1);
    _orderPriceLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_orderPriceLabel];
    [_orderPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.offset(0);
        make.width.mas_equalTo(SCREEN_WIDTH*3/5);
        make.height.mas_equalTo(49);
    }];
    
    
    self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.submitButton setTitle:@"提交订单" forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.submitButton.backgroundColor = RGBA(238, 113, 8, 1);
    [self.submitButton addTarget:self action:@selector(submitOrder) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.submitButton];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_orderPriceLabel.mas_right).offset(0);
        make.top.right.bottom.offset(0);
    }];
}

//提交订单
-(void)submitOrder{
    if (_delegate && [_delegate respondsToSelector:@selector(submitOrder)]) {
        [_delegate submitOrder];
    }
}


@end
