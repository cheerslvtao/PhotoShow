//
//  ViewController.m
//  PhotoShow
//
//  Created by SFC-a on 2017/7/13.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "ViewController.h"
#import "HomeViewController.h"
#import "RegisterViewController.h"
@interface ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *pswTextfield;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIView *mainview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([NSUSERDEFAULT objectForKey:@"token"]) {
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:[[HomeViewController alloc]init]];
        [CommonTool changeRootViewController:nav];
    }else{
        [self configUI];
    }

}

#pragma mark - UI美化 加背景图、修饰
-(void)configUI {
    
    [CommonTool setBGColor:self.userName R:81 G:110 B:50 A:1];
    [CommonTool setBGColor:self.pswTextfield R:81 G:110 B:50 A:1];
    
    self.userName.layer.cornerRadius = self.userName.frame.size.height/2;
    self.pswTextfield.layer.cornerRadius = self.pswTextfield.frame.size.height/2;

    NSMutableAttributedString * userPlaceString = [[NSMutableAttributedString alloc]initWithString:@"用户名/邮箱/手机号"];
    NSMutableAttributedString * pswPlaceString = [[NSMutableAttributedString alloc]initWithString:@"请输入密码"];
    [userPlaceString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, userPlaceString.length)];
    [pswPlaceString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, pswPlaceString.length)];
    self.userName.attributedPlaceholder = userPlaceString;
    self.pswTextfield.attributedPlaceholder = pswPlaceString;

    
    UIView * fixview1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 38, 18)];
    UIView * fixview2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 38, 18)];

    UIImageView * userIconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_user"]];
    userIconView.frame = CGRectMake(20, 0, 18, 18);
    self.userName.leftViewMode = UITextFieldViewModeAlways;
    [fixview1 addSubview: userIconView];
    self.userName.leftView = fixview1;
    
    UIImageView * pswIconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_pass"]];
    pswIconView.frame = CGRectMake(20, 0, 18, 18);
    self.pswTextfield.leftViewMode = UITextFieldViewModeAlways;
    [fixview2 addSubview:pswIconView];
    self.pswTextfield.leftView = fixview2;
    
    self.userName.delegate =self;
    self.pswTextfield.delegate = self;
    
    [self.loginButton setBackgroundImage:[UIImage imageNamed:@"login_button"] forState:UIControlStateNormal];
     
}

- (IBAction)registNewAccount:(UIButton *)sender {
    RegisterViewController * vc = [[RegisterViewController alloc]init];
    vc.isRegister = YES;
    [self presentViewController:vc animated:NO completion:nil];
}

- (IBAction)forgetPassword:(UIButton *)sender {
    RegisterViewController * vc = [[RegisterViewController alloc]init];
    vc.isRegister = NO;
    [self presentViewController:vc animated:NO completion:nil];
}

- (IBAction)loginClick:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    if (_userName.text.length == 0 || _pswTextfield.text.length == 0 ) {
        [HUDManager toastmessage:@"请填写用户名和密码" superView:self.view];
        return;
    }
    [HTTPTool postWithPath:url_login params:@{@"username":_userName.text,@"password":_pswTextfield.text} success:^(id json) {
        if ([json[@"code"] integerValue] == 200 && [json[@"success"] integerValue] == 1) {
            //登录成功 -> 获取token
            [NSUSERDEFAULT setObject:json[@"data"][@"client_id"] forKey:@"clientId"];
            [NSUSERDEFAULT setObject:json[@"data"][@"client_secret"] forKey:@"secret"];
            [NSUSERDEFAULT synchronize];

            [self getTokenAndLogin:json[@"data"][@"client_id"] secret:json[@"data"][@"client_secret"]];
        }else{
            [HUDManager toastmessage:json[@"msg"] superView:self.view];
        }
        sender.userInteractionEnabled = YES;
    } failure:^(NSError *error) {
       sender.userInteractionEnabled = YES;
    }alertMsg:@"正在登陆..." successMsg:@"正在登陆..." failMsg:@"登录失败" showView:self.view];
}

-(void)getTokenAndLogin:(NSString *)clientId secret:(NSString *)secret{
    
    [HTTPTool postWithPath:url_token params:@{@"client_id":clientId,@"client_secret":secret,@"grant_type":@"client_credentials"} success:^(id json) {
        [NSUSERDEFAULT setObject:json[@"access_token"] forKey:@"token"];
        [NSUSERDEFAULT synchronize];
        //获取token成功
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:[[HomeViewController alloc]init]];
        [CommonTool changeRootViewController:nav];
        
    } failure:^(NSError *error) {
        
    }];
    
    
}

-(void)share{

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
