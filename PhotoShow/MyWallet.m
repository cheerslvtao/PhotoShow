//
//  MyWallet.m
//  PhotoShow
//
//  Created by SFC-a on 2017/7/25.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "MyWallet.h"

@implementation MyWallet
{
    UIImageView * _bgView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    _bgView = [[UIImageView alloc]init];
    _bgView.image = [UIImage imageNamed:@"mine_mywalletBG"];
    _bgView.userInteractionEnabled = YES;
    [self addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
    
    self.walletTitle = [[UILabel alloc]init];
    self.walletTitle.textColor = [UIColor whiteColor];
    self.walletTitle.text = @"当前积分";
    [_bgView addSubview:self.walletTitle];
    [self.walletTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(15);
    }];
    
    self.walletTotal = [[UILabel alloc]init];
    self.walletTotal.textColor = [UIColor whiteColor];
   
    self.walletTotal.text = @"0";
    self.walletTotal.font = [UIFont systemFontOfSize:40 ];
    [_bgView addSubview:self.walletTotal];
    __weak typeof(self) weakself = self;
    [self.walletTotal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(weakself.walletTitle.mas_bottom).offset(2);
    }];
    
    
}

-(void)showOtherInfo{
    _cash_feeLabel = [[UILabel alloc]init];
    _cash_feeLabel.font = [UIFont systemFontOfSize:13];
    _cash_feeLabel.textColor = [UIColor whiteColor];
    _cash_feeLabel.text = @"";
    [_bgView addSubview:_cash_feeLabel];
    [_cash_feeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-10);
        make.right.offset(-15);
    }];
    
    
    UIButton * getMoneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [getMoneyBtn setTitle:@"提 现" forState:UIControlStateNormal];
    [getMoneyBtn setTitleColor:RGBA(3, 95, 15, 1) forState:UIControlStateNormal];
    getMoneyBtn.layer.cornerRadius = 3;
    getMoneyBtn.layer.borderColor = RGBA(118, 195, 21, 1).CGColor;
    getMoneyBtn.layer.borderWidth = 1;
    getMoneyBtn.backgroundColor = [UIColor whiteColor];
    getMoneyBtn.alpha = 0.5;
    getMoneyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [getMoneyBtn addTarget:self action:@selector(getMoneyButton) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:getMoneyBtn];
    
    [getMoneyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.bottom.equalTo(_cash_feeLabel.mas_top).offset(-10);
        make.width.mas_equalTo(95);
        make.height.mas_equalTo(34);
    }];

}

#pragma mark - 提现
-(void)getMoneyButton{
    self.getMoney();
}

@end
