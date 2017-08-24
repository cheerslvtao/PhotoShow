//
//  FilterOrderView.m
//  PhotoShow
//
//  Created by SFC-a on 2017/8/5.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "FilterOrderView.h"

@implementation FilterOrderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}


-(void)createUI{
    
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"订单查询";
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.height.mas_equalTo(45);
        make.top.offset(0);
    }];
    
    UIView * lineview1 = [self lineView];
    [self addSubview:lineview1];
    [lineview1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0) ;
        make.height.mas_equalTo(1);
        make.top.equalTo(titleLabel.mas_bottom).offset(0);
    }];
    
    UILabel * timeTitleLabel = [[UILabel alloc]init];
    timeTitleLabel.text = @"时间";
    timeTitleLabel.textColor = [UIColor grayColor];
    timeTitleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:timeTitleLabel];
    [timeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(lineview1.mas_bottom).offset(0);
        make.width.mas_equalTo(SCREEN_WIDTH-30);
        make.height.mas_equalTo(40);
    }];
    
    UIView * timeBtnBgView = [[UIView  alloc]init];
    [self addSubview:timeBtnBgView];
    [timeBtnBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(timeTitleLabel.mas_bottom).offset(0);
        make.height.mas_equalTo(40);
    }];
    
    NSArray * timeArr = @[@"一个月",@"三个月",@"一年内",@"一年前"];
    UIButton * beforeButton = nil;
    for (int i = 0; i<4; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:timeArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.backgroundColor = [UIColor whiteColor];
        btn.layer.borderColor = RGBA(228, 229, 230, 1).CGColor;
        btn.layer.borderWidth = 1;
        [timeBtnBgView addSubview:btn];
        
        if (i == 0) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(15);
                make.top.offset(5);
                make.width.mas_equalTo((SCREEN_WIDTH-90)/4);
                make.height.mas_equalTo(30);
            }];
            [btn addSubview:self.selectedFlagImgV];
            [self.selectedFlagImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.bottom.offset(0);
                make.height.width.mas_equalTo(18);
            }];
            btn.layer.borderColor = [UIColor orangeColor].CGColor;
            self.beforeBtn = btn;
            self.filterParameters[@"albumTime"] = @"1";

        }else{
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(beforeButton.mas_width);
                make.left.equalTo(beforeButton.mas_right).offset(15);
                make.height.equalTo(beforeButton.mas_height);
                make.top.offset(5);
            }];

        }

        [btn addTarget:self action:@selector(timeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        beforeButton = btn;
    }
    
    UIView * lineview2 = [self lineView];
    [self addSubview:lineview2];
    [lineview2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0) ;
        make.height.mas_equalTo(1);
        make.top.equalTo(timeBtnBgView.mas_bottom).offset(0);
    }];
    
    UILabel * typeTitleLabel = [[UILabel alloc]init];
    typeTitleLabel.text = @"类型";
    typeTitleLabel.textColor = [UIColor grayColor];
    typeTitleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:typeTitleLabel];
    [typeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(lineview2.mas_bottom).offset(0);
        make.width.mas_equalTo(SCREEN_WIDTH-30);
        make.height.mas_equalTo(40);
    }];
    
    UIView * typeBtnBgView = [[UIView  alloc]init];
    [self addSubview:typeBtnBgView];
    [typeBtnBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(typeTitleLabel.mas_bottom).offset(0);
        make.height.mas_equalTo(40);
    }];
    
    NSArray * typeArr = @[@"生活",@"旅行",@"成长",@"文件"];
    UIButton * beforeTypeButton = nil;
    for (int i = 0; i<typeArr.count; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:typeArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.backgroundColor = [UIColor whiteColor];
        btn.layer.borderColor = RGBA(228, 229, 230, 1).CGColor;
        btn.layer.borderWidth = 1;
        [typeBtnBgView addSubview:btn];
        
        if (i == 0) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(15);
                make.top.offset(5);
                make.width.mas_equalTo((SCREEN_WIDTH-90)/4);
                make.height.mas_equalTo(30);
            }];
            [btn addSubview:self.selectedFlagImgVType];
            [self.selectedFlagImgVType mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.bottom.offset(0);
                make.height.width.mas_equalTo(18);
            }];
            btn.layer.borderColor = [UIColor orangeColor].CGColor;
            self.typeBeforeBtn = btn;
            self.filterParameters[@"albumType"] = @"01";

        }else{
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(beforeTypeButton.mas_width);
                make.left.equalTo(beforeTypeButton.mas_right).offset(15);
                make.height.equalTo(beforeTypeButton.mas_height);
                make.top.offset(5);
            }];
            
        }
        
        [btn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        beforeTypeButton = btn;
    }
    
    UIView * lineview3 = [self lineView];
    [self addSubview:lineview3];
    [lineview3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0) ;
        make.height.mas_equalTo(1);
        make.top.equalTo(typeBtnBgView.mas_bottom).offset(0);
    }];

    
    self.searchtextField = [[UITextField alloc]init];
    self.searchtextField.delegate  =self;
    self.searchtextField.placeholder = @"相册名称";
    UIView * fixedview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.searchtextField.leftView = fixedview;
    self.searchtextField.leftViewMode = UITextFieldViewModeAlways;
    self.searchtextField.layer.borderColor = RGBA(228, 229, 230, 1).CGColor;
    self.searchtextField.layer.borderWidth = 1;
    self.searchtextField.layer.cornerRadius = 5;
    [self addSubview:self.searchtextField];
    [self.searchtextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(lineview3.mas_bottom).offset(20);
        make.height.mas_equalTo(35);
    }];
    
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"搜索" forState:UIControlStateNormal];
    
    sureBtn.layer.borderWidth = 1;
    sureBtn.layer.borderColor = RGBA(123, 198, 36, 1).CGColor;
    sureBtn.layer.cornerRadius = 20;
    [sureBtn setTitleColor:RGBA(63, 113, 71, 1) forState:UIControlStateNormal];
    [self addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(self.searchtextField.mas_bottom).offset(20);
        make.height.mas_equalTo(40);
    }];
    [sureBtn addTarget:self action:@selector(sureButton) forControlEvents:UIControlEventTouchUpInside];
}

-(void)timeBtnClick:(UIButton *)btn{
    self.beforeBtn.layer.borderColor = RGBA(228, 229, 230, 1).CGColor;

    btn.layer.borderColor =  [UIColor orangeColor].CGColor;
    [btn addSubview:self.selectedFlagImgV];
    [self.selectedFlagImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.offset(0);
        make.height.width.mas_equalTo(18);
    }];
    
    self.beforeBtn = btn;
    btn.selected = YES;
    self.beforeBtn.selected = NO;
    if ([btn.titleLabel.text isEqualToString:@"一个月"]) {
        self.filterParameters[@"albumTime"] = @"1";
    }else if ([btn.titleLabel.text isEqualToString:@"三个月"]){
        self.filterParameters[@"albumTime"] = @"3";
    }else if ([btn.titleLabel.text isEqualToString:@"一年内"]){
        self.filterParameters[@"albumTime"] = @"12";
    }else if ([btn.titleLabel.text isEqualToString:@"一年前"]){
        self.filterParameters[@"albumTime"] = @"13";
    }

//    self.filterParameters[@"albumTime"] = btn.titleLabel.text;

}


-(void)typeBtnClick:(UIButton *)btn{
    self.typeBeforeBtn.layer.borderColor = RGBA(228, 229, 230, 1).CGColor;
    btn.layer.borderColor =  [UIColor orangeColor].CGColor;
    [btn addSubview:self.selectedFlagImgVType];
    [self.selectedFlagImgVType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.offset(0);
        make.height.width.mas_equalTo(18);
    }];
    self.typeBeforeBtn = btn;
    btn.selected = YES;
    self.typeBeforeBtn.selected = NO;
    //@[@"生活",@"旅行",@"成长",@"文件"]
    if ([btn.titleLabel.text isEqualToString:@"生活"]) {
        self.filterParameters[@"albumType"] = @"01";
    }else if ([btn.titleLabel.text isEqualToString:@"旅行"]){
        self.filterParameters[@"albumType"] = @"02";
    }else if ([btn.titleLabel.text isEqualToString:@"成长"]){
        self.filterParameters[@"albumType"] = @"03";
    }else if ([btn.titleLabel.text isEqualToString:@"文件"]){
        self.filterParameters[@"albumType"] = @"10";
    }

}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.filterParameters[@"albumName"] = textField.text;
}

-(void)sureButton{
    if (_delegate && [_delegate respondsToSelector:@selector(filterOrderWith:)]){
        [_delegate filterOrderWith:self.filterParameters];
    }
}

-(UIView *)lineView{
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = RGBA(228, 229, 230, 1);
    return view;
}

-(UIImageView *)selectedFlagImgV{
    if (!_selectedFlagImgV) {
        _selectedFlagImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_selected"]];
    }
    return _selectedFlagImgV;
}

-(UIImageView *)selectedFlagImgVType{
    if (!_selectedFlagImgVType) {
        _selectedFlagImgVType = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_selected"]];
    }
    return _selectedFlagImgVType;
}

-(NSMutableDictionary *)filterParameters{
    if (!_filterParameters) {
        _filterParameters = [[NSMutableDictionary alloc]init];
    }
    return _filterParameters;
}
@end
