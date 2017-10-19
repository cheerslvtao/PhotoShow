//
//  RegisterViewController.m
//  PhotoShow
//
//  Created by SFC-a on 2017/8/3.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "RegisterViewController.h"
#import "HomeViewController.h"

@interface RegisterViewController ()<UIScrollViewDelegate,UITextFieldDelegate>

@property (nonatomic,retain) NSMutableArray * textfieldArr;
@property (nonatomic,retain) NSArray * placeholderArr;

@property (nonatomic,retain) UIScrollView * scrollview;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (_isRegister){
        //注册
        _placeholderArr = @[@"输入手机号",@"输入验证码",@"输入密码",@"输入邀请人"];
    }else{
        //忘记密码
        _placeholderArr = @[@"输入手机号",@"输入验证码",@"输入密码",@"确认密码"];
    }
    
    self.textfieldArr = [[NSMutableArray alloc]init];
    
    [self crateCustomNav];
    [self createUI];
    
}

#pragma mark - 自定义nav
-(void)crateCustomNav{
    UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    view.image = [UIImage imageNamed:@"nav_bg.jpg"];
    view.userInteractionEnabled = YES;
    [self.view addSubview:view];
    
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backLogin) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(20);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(80);
    }];
    
    UILabel * titleLabel = [[UILabel alloc]init];
    if (_isRegister) {
        titleLabel.text = @"注册";
    }else{
        titleLabel.text = @"找回密码";
    }
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:18];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX).offset(0);
        make.top.offset(20);
        make.height.mas_equalTo(44);
    }];
    
}

-(void)backLogin{
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark -- UI
-(void)createUI{
    self.scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.scrollview.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-63);
    self.scrollview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollview];
    
    for (int i = 0; i<self.placeholderArr.count; i++) {
        UITextField * textField = [[UITextField alloc]init];
        textField.placeholder = self.placeholderArr[i];
        textField.layer.borderWidth = 1;
        textField.layer.borderColor = RGBA(123, 198, 36, 1).CGColor;
        textField.layer.cornerRadius = 5;
        UIView * fixedView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
        textField.leftView = fixedView;
        textField.leftViewMode = UITextFieldViewModeAlways;
        [self.textfieldArr addObject:textField];
        [self.scrollview addSubview:textField];
        if (i == 0) {
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.view.mas_centerX).offset(0);
                make.top.offset(40);
                make.width.mas_equalTo(SCREEN_WIDTH*0.85);
                make.height.mas_equalTo(40);
            }];
        }else{
            UITextField * toptextfield = self.textfieldArr[i-1];
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.view.mas_centerX).offset(0);
                make.top.equalTo(toptextfield.mas_bottom).offset(20);
                make.width.mas_equalTo(SCREEN_WIDTH*0.85);
                make.height.mas_equalTo(40);
            }];
        }
        
        if (i == 1) {
            UIButton * getCode = [UIButton buttonWithType:UIButtonTypeCustom];
            getCode.frame = CGRectMake(0, 0, SCREEN_WIDTH/3, 40);
            [getCode setTitle:@"获取验证码" forState:UIControlStateNormal];
            getCode.backgroundColor = RGBA(123, 198, 36, 1);
            [getCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [getCode addTarget:self action:@selector(getPhoneCode:) forControlEvents:UIControlEventTouchUpInside];
            textField.rightView = getCode;
            textField.rightViewMode = UITextFieldViewModeAlways;
        }
        
    }

    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (_isRegister){
        [sureBtn setTitle:@"注册" forState:UIControlStateNormal];
    }else{
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    }
    sureBtn.layer.borderWidth = 1;
    sureBtn.layer.borderColor = RGBA(123, 198, 36, 1).CGColor;
    sureBtn.layer.cornerRadius = 20;
    [sureBtn setTitleColor:RGBA(63, 113, 71, 1) forState:UIControlStateNormal];
    [self.scrollview addSubview:sureBtn];
    UITextField * toptextfield = [self.textfieldArr lastObject];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).offset(0);
        make.top.equalTo(toptextfield.mas_bottom).offset(20);
        make.width.mas_equalTo(SCREEN_WIDTH*0.85);
        make.height.mas_equalTo(40);
    }];
    [sureBtn addTarget:self action:@selector(sureButton) forControlEvents:UIControlEventTouchUpInside];
}

-(void)getPhoneCode:(UIButton *)btn{
    UITextField * phoneTextField = self.textfieldArr[0];
    if (phoneTextField.text.length != 11) {
        [HUDManager toastmessage:@"请输入手机号" superView:self.view];
        return;
    }
    btn.userInteractionEnabled = NO;
    btn.backgroundColor = [UIColor grayColor];
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
    
    [HTTPTool postWithPath:url_sendSms params:@{@"mobile":[self.textfieldArr[0] text]} success:^(id json) {
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


-(void)sureButton{
    
    if (_isRegister){
        [self registe];
    }else{
        [self changePassword];
    }
}



#pragma mark - 注册
-(void)registe{
    //配置参数
    NSArray * keys = @[@"username",@"smsCode",@"password",@"referee"];
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    for (int i =0 ;i< self.textfieldArr.count ;i++) {
        UITextField * textfield = self.textfieldArr[i];
        if (textfield.text.length == 0 && i != 3) {
            [HUDManager toastmessage:@"请填写完整信息" superView:self.view];
            return;
        }
        [params setObject:[textfield text] forKey:keys[i]];
    }
    //注册加type参数
    [params setObject:@"register" forKey:@"type"];
    [HTTPTool postWithPath:url_register params:params success:^(id json) {
        if ([json[@"code"] intValue] == 200){
            //注册成功
            [NSUSERDEFAULT setObject:json[@"data"][@"client_id"] forKey:@"clientId"];
            [NSUSERDEFAULT setObject:json[@"data"][@"client_secret"] forKey:@"secret"];
            [NSUSERDEFAULT synchronize];
            [self getTokenAndLogin:json[@"data"][@"client_id"] secret:json[@"data"][@"client_secret"]];
        }else{
            [HUDManager toastmessage:json[@"msg"] superView:self.view];
        }
    } failure:^(NSError *error) {
        
    } alertMsg:@"正在注册..." successMsg:@"正在注册..." failMsg:@"注册失败，请重试" showView:self.view];
}

#pragma mark - 获取token 并且登录进入首页
-(void)getTokenAndLogin:(NSString *)clientId secret:(NSString *)secret{
    
    [HTTPTool postWithPath:url_token params:@{@"client_id":clientId,@"client_secret":secret,@"grant_type":@"client_credentials"} success:^(id json) {
        [NSUSERDEFAULT setObject:json[@"access_token"] forKey:@"token"];
        [NSUSERDEFAULT synchronize];
        //获取token成功
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:[[HomeViewController alloc]init]];
        [CommonTool changeRootViewController:nav];

    } failure:^(NSError *error) {
        
    }alertMsg:@"正在登录..." successMsg:@"正在登录..." failMsg:@"登录失败，请重试" showView:self.view];
    
}

#pragma mark -  修改密码
-(void)changePassword{
    //配置参数
    NSArray * keys = @[@"username",@"smsCode",@"password"];
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    for (int i =0 ;i< keys.count ;i++) {
        UITextField * textfield = self.textfieldArr[i];
        if (textfield.text.length == 0) {
            [HUDManager toastmessage:@"请填写完整信息" superView:self.view];
            return;
        }
        if (i == keys.count-1) {
            if (![textfield.text isEqualToString:[self.textfieldArr[i+1] text]]) {
                [HUDManager toastmessage:@"两次输入密码不一致" superView:self.view];
                return;
            }
        }
        [params setObject:[textfield text] forKey:keys[i]];
    }
    
    [HTTPTool postWithPath:url_updatePassword params:params success:^(id json) {
        if ([json[@"code"] intValue] == 200){
            //修改成功
            [HUDManager toastmessage:@"修改成功" superView:self.view];
        }else{
            [HUDManager toastmessage:json[@"msg"] superView:self.view];
        }
    } failure:^(NSError *error) {
        
    } alertMsg:@"修改中..." successMsg:@"修改中..." failMsg:@"修改失败，请重试" showView:self.view];
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
