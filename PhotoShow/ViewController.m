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
    
    [CommonTool setBGColor:self.userName R:220 G:222 B:221 A:1];
    [CommonTool setBGColor:self.pswTextfield R:220 G:222 B:221 A:1];
    
    self.userName.layer.cornerRadius = 8;
    self.pswTextfield.layer.cornerRadius = 8;

    NSMutableAttributedString * userPlaceString = [[NSMutableAttributedString alloc]initWithString:@"用户名/邮箱/手机号"];
    NSMutableAttributedString * pswPlaceString = [[NSMutableAttributedString alloc]initWithString:@"请输入验证码"];
    [userPlaceString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, userPlaceString.length)];
    [pswPlaceString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, pswPlaceString.length)];
    self.userName.attributedPlaceholder = userPlaceString;
    self.pswTextfield.attributedPlaceholder = pswPlaceString;

    
    UIView * fixview1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 38, 18)];
    UIView * fixview2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 38, 18)];

    UIImageView * userIconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_user"]];
    userIconView.frame = CGRectMake(10, 0, 18, 18);
    self.userName.leftViewMode = UITextFieldViewModeAlways;
    [fixview1 addSubview: userIconView];
    self.userName.leftView = fixview1;
    
    UIImageView * pswIconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_pass"]];
    pswIconView.frame = CGRectMake(10, 0, 18, 18);
    self.pswTextfield.leftViewMode = UITextFieldViewModeAlways;
    [fixview2 addSubview:pswIconView];
    self.pswTextfield.leftView = fixview2;
    
    self.userName.delegate =self;
    self.pswTextfield.delegate = self;
    
    [self.loginButton setBackgroundImage:[UIImage imageNamed:@"login_button"] forState:UIControlStateNormal];
    
    
    UIButton * getCode = [UIButton buttonWithType:UIButtonTypeCustom];
    getCode.frame = CGRectMake(0, 0, SCREEN_WIDTH/4, self.userName.frame.size.height);
    [getCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    getCode.titleLabel.font = [UIFont systemFontOfSize:15];
    getCode.backgroundColor = RGBA(123, 198, 36, 1);
    [getCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [getCode addTarget:self action:@selector(getPhoneCode:) forControlEvents:UIControlEventTouchUpInside];
    self.pswTextfield.rightView = getCode;
    self.pswTextfield.rightViewMode = UITextFieldViewModeAlways;

}


-(void)getPhoneCode:(UIButton *)btn{
    UITextField * phoneTextField = self.userName;
    if (phoneTextField.text.length != 11) {
        [HUDManager toastmessage:@"请输入手机号" superView:self.view];
        return;
    }
    btn.userInteractionEnabled = NO;
    btn.backgroundColor = [UIColor lightGrayColor];
    __block NSInteger time = 60;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (time <= 0) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮的样式
                [btn setTitle:@"重新发送" forState:UIControlStateNormal];
                btn.backgroundColor = RGBA(123, 198, 36, 1);
                btn.userInteractionEnabled = YES;
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮的样式
                [btn setTitle:[NSString stringWithFormat:@"%lds",time] forState:UIControlStateNormal];
            });
            time--;
        }
    });
    dispatch_resume(timer);
    
    [HTTPTool postWithPath:url_sendSms params:@{@"mobile":[self.userName text]} success:^(id json) {
        if (![json[@"code"] isEqual:[NSNull null]] && [json[@"code"] integerValue] == 200 && [json[@"success"] intValue] == 1){
            [HUDManager toastmessage:@"短信发送成功，请注意查收" superView:self.view];
        }else{
            dispatch_source_cancel(timer);
            [HUDManager toastmessage:json[@"msg"] superView:self.view];
            [btn setTitle:@"重新发送" forState:UIControlStateNormal];
            btn.backgroundColor = RGBA(123, 198, 36, 1);
            btn.userInteractionEnabled = YES;
        }
    } failure:^(NSError *error) {
        dispatch_source_cancel(timer);
        [HUDManager toastmessage:@"操作错误，请重试" superView:self.view];
        [btn setTitle:@"重新发送" forState:UIControlStateNormal];
        btn.backgroundColor = RGBA(123, 198, 36, 1);
        btn.userInteractionEnabled = YES;
    }];
}



//- (IBAction)registNewAccount:(UIButton *)sender {
//    RegisterViewController * vc = [[RegisterViewController alloc]init];
//    vc.isRegister = YES;
//    [self presentViewController:vc animated:NO completion:nil];
//}
//
//- (IBAction)forgetPassword:(UIButton *)sender {
//    RegisterViewController * vc = [[RegisterViewController alloc]init];
//    vc.isRegister = NO;
//    [self presentViewController:vc animated:NO completion:nil];
//}

- (IBAction)loginClick:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    if (_userName.text.length == 0 || _pswTextfield.text.length == 0 ) {
        [HUDManager toastmessage:@"请填写用户名和验证码" superView:self.view];
        return;
    }
    [HTTPTool postWithPath:url_login params:@{@"username":_userName.text,@"smsCode":_pswTextfield.text} success:^(id json) {
        if ([json[@"code"] integerValue] == 200 && [json[@"success"] integerValue] == 1) {
            //登录成功 -> 获取token
            [NSUSERDEFAULT setObject:json[@"data"][@"client_id"] forKey:@"clientId"];
            [NSUSERDEFAULT setObject:json[@"data"][@"client_secret"] forKey:@"secret"];
            [NSUSERDEFAULT synchronize];

            [self getTokenAndLogin:json[@"data"][@"client_id"] secret:json[@"data"][@"client_secret"]];
        }else{
            if (![json[@"msg"] isEqual:[NSNull null]]){
                [HUDManager toastmessage:json[@"msg"] superView:self.view];
            }
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
//        [self dismissViewControllerAnimated:YES completion:nil];
        
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
