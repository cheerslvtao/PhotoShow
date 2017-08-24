//
//  MyWalletViewController.m
//  PhotoShow
//
//  Created by SFC-a on 2017/7/25.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "MyWalletViewController.h"
#import "JIFENViewController.h"
#import "YUEViewController.h"
@interface MyWalletViewController ()<UIScrollViewDelegate>

@property (nonatomic,retain) UIView * lineView;

@property (nonatomic,retain) UIScrollView * scrollview ;

@end

@implementation MyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的钱包";
    
    [self secondNav];
    [self createViewController];
}

#pragma mark - 二级导航
-(void)secondNav{
    UIView * navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navView];
    
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, 42);
    leftButton.tag = 1010;
    [leftButton setTitle:@"当前余额" forState:UIControlStateNormal];
    [leftButton setTitleColor:RGBA(3, 95, 15, 1) forState:UIControlStateSelected];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [leftButton addTarget:self action:@selector(changeSecondNav:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.selected = YES;
    [navView addSubview:leftButton];
    
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 42);
    [rightButton setTitle:@"当前积分" forState:UIControlStateNormal];
    rightButton.tag = 1011;
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButton setTitleColor:RGBA(3, 95, 15, 1) forState:UIControlStateSelected];
    [rightButton addTarget:self action:@selector(changeSecondNav:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:rightButton];
    
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 42, SCREEN_WIDTH/2, 2)];
    _lineView.backgroundColor = RGBA(107, 194, 0, 1);
    [navView addSubview:_lineView];
    
}

-(void)changeSecondNav:(UIButton *)navBtn{
    NSLog(@"%ld",navBtn.tag-1010);
    navBtn.selected = YES;
    UIButton * otherBtn = [navBtn.superview viewWithTag:navBtn.tag==1010?1011:1010];
    otherBtn.selected = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        _lineView.frame = CGRectMake((navBtn.tag-1010)*SCREEN_WIDTH/2, 42, SCREEN_WIDTH/2, 2);
        _scrollview.contentOffset = CGPointMake((navBtn.tag-1010)*SCREEN_WIDTH, 0);
    }];
    
}

#pragma mark - 子控制器创建
-(void)createViewController{
    _scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-44-64)];
    _scrollview.showsHorizontalScrollIndicator = NO;
    _scrollview.pagingEnabled = YES;
    _scrollview.delegate = self;
    _scrollview.contentSize = CGSizeMake(SCREEN_WIDTH*2, SCREEN_HEIGHT-44-64);
    _scrollview.userInteractionEnabled = YES;
    [self.view addSubview:_scrollview];
    
    
    
    JIFENViewController * jifenVC = [[JIFENViewController alloc]init];
    YUEViewController * yueVC = [[YUEViewController alloc]init];
    [self addChildViewController:jifenVC];
    [jifenVC willMoveToParentViewController:self];
    [self addChildViewController:yueVC];
    [yueVC willMoveToParentViewController:self];
    [_scrollview addSubview:jifenVC.view];
    [_scrollview addSubview:yueVC.view];
    [yueVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(_scrollview.mas_height);
    }];
    [jifenVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(yueVC.view.mas_right).offset(0);
        make.top.offset(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(_scrollview.mas_height);
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _lineView.frame = CGRectMake(scrollView.contentOffset.x/2, 42, SCREEN_WIDTH/2, 2);
    UIButton * rightbtn = [_lineView.superview viewWithTag:1011];
    UIButton * leftbtn = [_lineView.superview viewWithTag:1010];
    if(scrollView.contentOffset.x == 0){
        leftbtn.selected = YES;
        rightbtn.selected = NO;
    }else if (scrollView.contentOffset.x == SCREEN_WIDTH){
        rightbtn.selected = YES;
        leftbtn.selected = NO;
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
}

@end
