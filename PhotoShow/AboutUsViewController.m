//
//  AboutUsViewController.m
//  PhotoShow
//
//  Created by SFC-a on 2017/8/1.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"关于我们";
    
    UIImageView * logoImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_logo"]];
    logoImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:logoImgView];
    [logoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(25);
        make.right.offset(-25);
        make.top.offset(25);
    }];
    
    UILabel * label = [[UILabel alloc]init];
    label.text = @"照片整理云存储，相册个性定制APP";
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.layer.borderColor = [UIColor lightGrayColor].CGColor;
    label.layer.borderWidth = 1;
    label.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(logoImgView.mas_bottom).offset(25);
        make.height.mas_equalTo(100);
    }];
    
    
    UILabel * bottomLabel = [[UILabel alloc]init];
    bottomLabel.font = [UIFont systemFontOfSize:15];
    bottomLabel.textColor = [UIColor lightGrayColor];
    bottomLabel.text = @"Copyright©2006-2013\n北京锐曼德科技有限公司";
    bottomLabel.numberOfLines = 2;
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:bottomLabel];
    
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.bottom.offset(-50);
    }];
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
