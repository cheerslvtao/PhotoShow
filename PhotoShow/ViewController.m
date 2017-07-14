//
//  ViewController.m
//  PhotoShow
//
//  Created by SFC-a on 2017/7/13.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "ViewController.h"
#import <UShareUI/UShareUI.h>
#import "UMManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)share:(UIButton *)sender {
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        NSLog(@"%ld",(long)platformType);
        NSLog(@"%@",userInfo);
        // 构建分享信息
        UMShareInfoModel * model = [[UMShareInfoModel alloc]init];
        model.vc = self;
        model.platfromType = platformType;
        model.thumbURL = @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
        model.webpageUrl = @"https://www.baidu.com";
        model.shareTitle = @"分享标题";
        model.shareMsg = @"分享消息分享消息分享消息分享消息分享消息分享消息分享消息分享消息分享消息分享消息分享消息";
        [UMManager share:model];
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
