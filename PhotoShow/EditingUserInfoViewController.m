//
//  EditingUserInfoViewController.m
//  PhotoShow
//
//  Created by SFC-a on 2017/8/4.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "EditingUserInfoViewController.h"
#import "NewAlbumInputTableViewCell.h"

@interface EditingUserInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,retain) NSArray * titleArr;

@property (nonatomic,retain) UITableView * editingTableView;

@property(nonatomic,retain) NSArray * placeholderArr;

@end

@implementation EditingUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.isEditingUserInfo) {
        //编辑个人信息
        self.titleArr = @[@"用户名",@"真实姓名",@"性别",@"手机号",@"邮箱"];
        self.title = @"编辑个人信息";
    }else{
        //提现申请
        self.titleArr = @[@"提现金额",@"银行卡号",@"银行名称",@"开户行",@"手续费"];
        self.placeholderArr = @[@"请输入提现金额",@"请输入银行卡号",@"请输入银行名称",@"请输入开户行",@""];
        self.title = @"提现";
        self.userInfoArr = [[NSMutableArray alloc]initWithArray:@[@"",@"",@"",@""]];
    }
    NSLog(@"%@",self.userInfoArr);
    [self createUI];
    
    
}

-(void)createUI{
    self.editingTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    self.editingTableView.delegate = self;
    self.editingTableView.dataSource = self;
    [self.editingTableView setContentInset:UIEdgeInsetsMake(20, 0, 0, 0)];
    self.editingTableView.separatorInset = UIEdgeInsetsMake(0, -15, 0, 0);
    [self.editingTableView registerNib:[UINib nibWithNibName:@"NewAlbumInputTableViewCell" bundle:nil] forCellReuseIdentifier:@"NewAlbumInputTableViewCell"];
    UIView * footerview =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    footerview.backgroundColor = RGBA(221, 220, 223, 1);
    self.editingTableView.tableFooterView = footerview;
    [self.view addSubview:self.editingTableView];
    
    
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self.isEditingUserInfo){
        [sureBtn setTitle:@"保存" forState:UIControlStateNormal];
    }else{
        [sureBtn setTitle:@"提现" forState:UIControlStateNormal];
    }
    sureBtn.layer.borderWidth = 1;
    sureBtn.layer.borderColor = RGBA(123, 198, 36, 1).CGColor;
    sureBtn.layer.cornerRadius = 20;
    [sureBtn setTitleColor:RGBA(63, 113, 71, 1) forState:UIControlStateNormal];
    [self.view addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).offset(0);
        make.bottom.offset(-50);
        make.width.mas_equalTo(SCREEN_WIDTH*0.85);
        make.height.mas_equalTo(40);
    }];
    [sureBtn addTarget:self action:@selector(sureButton) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 保存信息 提现申请
-(void)sureButton{
    
    NSLog(@"---");
    if (_isEditingUserInfo){
        //编辑信息
        [self saveUserInfo];
    }else{
        //提现申请
        [self getMoneyApply];
    }
}

#pragma mark - 保存信息
-(void)saveUserInfo{
    NSArray * keyArr = @[@"nickname",@"realname",@"sex",@"phone",@"email"];
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    for (int i =0 ; i<keyArr.count; i++) {
        [params setObject:self.userInfoArr[i] forKey:keyArr[i]];
    }
    NSLog(@"%@",params);
    
    [HTTPTool postWithPath:url_updateInfo params:params success:^(id json) {
        if ([json[@"code"] intValue] == 200 && [json[@"success"] intValue] == 1) {
            [self requestUserInfo];
        }else{
            [HUDManager toastmessage:json[@"msg"] superView:self.view];
        }
    } failure:^(NSError *error) {
        
    } alertMsg:@"正在保存..." successMsg:@"正在保存..." failMsg:@"保存失败，请重试" showView:self.view];
}
#pragma mark - 再次获取最新数据保存到本地  
// 保存完成后返回并且刷新上一个页面
-(void)requestUserInfo{
    [HTTPTool postWithPath:url_userinfo params:nil success:^(id json) {
        if ([json[@"code"] intValue] == 200 && [json[@"success"] intValue]) {
            //保存个人信息
            [CommonTool setUserInfo:json[@"data"]];
            self.reloadBlock() ;
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [HUDManager toastmessage:json[@"msg"] superView:self.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -  提现申请
-(void)getMoneyApply{
    NSArray * keyArr = @[@"cash_money",@"bank_no",@"bank_name",@"bank_branch"];
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];

    for (int i =0 ; i<self.userInfoArr.count; i++) {
        if ([self.userInfoArr[i] isEqualToString:@""]) {
            [HUDManager toastmessage:@"请完善信息" superView:self.view];
            return;
        }
        [params setObject:self.userInfoArr[i] forKey:keyArr[i]];
    }
    [params setObject:self.currentMoney forKey:@"money"];
    NSLog(@"%@",params);
    
    [HTTPTool postWithPath:url_userCache params:params success:^(id json) {
        if ([json[@"code"] intValue] == 200 && [json[@"success"] intValue] == 1) {
            [HUDManager toastmessage:@"操作成功，请耐心等待" superView:self.view];
        }else{
            [HUDManager toastmessage:json[@"msg"] superView:self.view];
        }
    } failure:^(NSError *error) {
        [HUDManager toastmessage:@"操作失败，请重试" superView:self.view];
    } alertMsg:@"信息上传中..." successMsg:@"信息上传中..." failMsg:@"信息上传失败，请重试" showView:self.view];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewAlbumInputTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NewAlbumInputTableViewCell"];
    cell.cellTitle.text = self.titleArr[indexPath.row];
    
    if (_isEditingUserInfo && ![self.userInfoArr[indexPath.row] isEqualToString:@""]) {
        cell.cellTextfield.text = self.userInfoArr[indexPath.row];
    }
    
    if (!_isEditingUserInfo && indexPath.row == 4 ) {
        cell.cellTextfield.userInteractionEnabled = NO;
        cell.cellTextfield.text = [NSString stringWithFormat:@"手续费%@%%",self.cash_fee];
    }
    cell.cellTextfield.placeholder = [NSString stringWithFormat:@"请输入%@",self.titleArr[indexPath.row]];

    cell.cellTextfield.delegate = self;
    cell.cellTextfield.tag = 74835+indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mari - UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    NSInteger index = textField.tag -74835;
    if(_isEditingUserInfo){
        //编辑个人信息
        if (index == 3) {
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }else if(index == 4){
            textField.keyboardType = UIKeyboardTypeEmailAddress;
        }
    }else{
        
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSInteger index = textField.tag -74835;
    self.userInfoArr[index] = textField.text;
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
