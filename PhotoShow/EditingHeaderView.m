//
//  EditingHeaderView.m
//  PhotoShow
//
//  Created by SFC-a on 2017/7/26.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "EditingHeaderView.h"

@implementation EditingHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
    }
    return self;
}

-(void)createUI{
    
    _photoview = [[UIImageView alloc]init];
    _photoview.image = [UIImage imageNamed:image_placeholder];
    _photoview.contentMode = UIViewContentModeScaleAspectFill;
    _photoview.clipsToBounds = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scaleBigger:)];
    _photoview.userInteractionEnabled = YES;
    [_photoview addGestureRecognizer:tap];
    [self addSubview:_photoview];
    [_photoview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    _cameraAgainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cameraAgainBtn setTitle:@"重新拍照" forState:UIControlStateNormal];
    [_cameraAgainBtn setTitleColor:RGBA(3, 95, 15, 1) forState:UIControlStateNormal];
    _cameraAgainBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    _cameraAgainBtn.layer.cornerRadius = 5;
    _cameraAgainBtn.layer.borderColor = RGBA(118, 195, 21, 1).CGColor;
    _cameraAgainBtn.layer.borderWidth = 1;
    [self addSubview:_cameraAgainBtn];
    [_cameraAgainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.top.equalTo(_photoview.mas_bottom).offset(15);
        make.bottom.offset(-25);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(35);
    }];
    
    _selectPhotoAgainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_selectPhotoAgainBtn setTitle:@"重选照片" forState:UIControlStateNormal];
    [_selectPhotoAgainBtn setTitleColor:RGBA(3, 95, 15, 1) forState:UIControlStateNormal];
    _selectPhotoAgainBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    _selectPhotoAgainBtn.layer.cornerRadius = 5;
    _selectPhotoAgainBtn.layer.borderColor = RGBA(118, 195, 21, 1).CGColor;
    _selectPhotoAgainBtn.layer.borderWidth = 1;
    [self addSubview:_selectPhotoAgainBtn];
    [_selectPhotoAgainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_cameraAgainBtn.mas_left).offset(-15);
        make.top.equalTo(_photoview.mas_bottom).offset(15);
        make.bottom.offset(-25);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(35);
    }];
    
    UIView * lineview = [[UIView alloc]init];
    lineview.backgroundColor = THEMEBGCOLOR;
    [self addSubview:lineview];
    [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset(0);
        make.height.mas_equalTo(10);
    }];
    
}

#pragma mark - 点击全屏显示照片
-(void)scaleBigger:(UITapGestureRecognizer *)tap{
    NSLog(@"%@",tap.view);
    UIImageView * sourceImgV = (UIImageView *)tap.view;
    UIImageView * substituteImageView = [[UIImageView alloc]initWithImage:sourceImgV.image];
    substituteImageView.backgroundColor = [UIColor blackColor];
    substituteImageView.contentMode = UIViewContentModeScaleAspectFit;
    substituteImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer * subtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeSubstituteView:)];
    [substituteImageView addGestureRecognizer:subtap];
    [[UIApplication sharedApplication].delegate.window addSubview:substituteImageView];
    [substituteImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(substituteImageView.frame.size.height);
        make.centerX.equalTo(substituteImageView.mas_centerX).offset(0);
        make.centerY.equalTo(substituteImageView.mas_centerY).offset(0);
    }];
    [substituteImageView layoutIfNeeded];
    [UIView animateWithDuration:0.2 animations:^{
        [substituteImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.height.mas_equalTo(SCREEN_HEIGHT);
            make.top.left.offset(0);
        }];
        [substituteImageView layoutIfNeeded];
    }];
    
    
}

-(void)removeSubstituteView:(UITapGestureRecognizer *)tap{
    [UIView animateWithDuration:0.2 animations:^{
        tap.view.alpha = 0;
    } completion:^(BOOL finished) {
        [tap.view removeFromSuperview];
    }];

}


@end
