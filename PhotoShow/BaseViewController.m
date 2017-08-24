//
//  BaseViewController.m
//  PhotoShow
//
//  Created by SFC-a on 2017/7/17.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //235 235 244
    [CommonTool setBGColor:self.view R:235 G:235 B:244 A:1];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setNavigationBarLeftItem:@"返回" itemImg:[UIImage imageNamed:@"back"] currentNavBar:self.navigationItem curentViewController:self];
    __weak typeof(self) weakself = self;
    self.leftNavBlock = ^(){
        [weakself.navigationController popViewControllerAnimated:YES];
    };

}

#pragma mark - 设置导航 左右item
-(void)setNavigationBarRightItem:(NSString * )itemTitle itemImg:(UIImage *)itemImg currentNavBar:(UINavigationItem *)baritem curentViewController:(UIViewController *)currentVC{
    
    UIButton * button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:itemImg forState:UIControlStateNormal];
    if (itemTitle) {
        [button setTitle:itemTitle forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 48, 0, 0);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
        if ([itemTitle isEqualToString:@"更多"]){
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 58, 0, 0);
            button.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
        }else if ([itemTitle isEqualToString:@"分享"]){
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0);
            button.titleEdgeInsets = UIEdgeInsetsMake(0, -50, 0, 0);
        }else if ([itemTitle isEqualToString:@"制作"]){
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0);
            button.titleEdgeInsets = UIEdgeInsetsMake(0, -65, 0, 0);
        }

        button.frame = CGRectMake(0, 0, 70, 30);
    }else{
        button.frame = CGRectMake(0, 0, 40, 40);
    }
    
    [button addTarget:currentVC action:@selector(rightItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item_button = [[UIBarButtonItem alloc]initWithCustomView:button];
    baritem.rightBarButtonItem = item_button;
    
}

/** 右侧导航点击 */
-(void)rightItemClick:(UIButton *)btn{
    _rightNavBlock();
}

-(void)setNavigationBarLeftItem:(NSString * )itemTitle itemImg:(UIImage *)itemImg currentNavBar:(UINavigationItem *)baritem curentViewController:(UIViewController *)currentVC{
    UIButton * button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:itemImg forState:UIControlStateNormal];
    if (itemTitle) {
        [button setTitle:itemTitle forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
        button.frame = CGRectMake(0, 0, 70, 40);
    }else{
        button.frame = CGRectMake(0, 0, 40, 40);
    }

    
    [button addTarget:currentVC action:@selector(leftItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item_button = [[UIBarButtonItem alloc]initWithCustomView:button];
    baritem.leftBarButtonItem = item_button;
    
}

/** 左侧导航点击 */
-(void)leftItemClick:(UIButton *)btn{
    _leftNavBlock();
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
