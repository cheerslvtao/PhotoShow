//
//  AddNewAddressViewController.m
//  PhotoShow
//
//  Created by SFC-a on 2017/7/21.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "AddNewAddressViewController.h"
#import "AddNewAddressTableViewCell.h"
@interface AddNewAddressViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,retain) UITableView * addNewAddressTableView;

@property (nonatomic,strong) NSArray * dataArr;

@property (nonatomic,strong) NSArray * placeholdArr;

@property (nonatomic,retain) NSMutableArray * parameterArr;

@property (nonatomic,retain) UIButton * defaultAddressButton;

@end

@implementation AddNewAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"新增地址";
    
    self.dataArr = @[@"收件人",@"联系电话",@"详细地址"];
    self.placeholdArr = @[@"收件人姓名",@"收件人联系电话",@"详细到门牌号"];
    self.parameterArr = [[NSMutableArray alloc]initWithObjects:@"",@"",@"",@"0", nil];
    
    [self setNavigationBarLeftItem:@"返回" itemImg:[UIImage imageNamed:@"back"] currentNavBar:self.navigationItem curentViewController:self];
    __weak typeof(self) weakself = self;
    self.leftNavBlock = ^(){
        [weakself.navigationController popViewControllerAnimated:YES];
    };
    
    self.addNewAddressTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    [CommonTool setBGColor:self.addNewAddressTableView R:235 G:235 B:244 A:1];
    self.addNewAddressTableView.delegate = self;
    self.addNewAddressTableView.dataSource = self;
    [self.addNewAddressTableView setContentInset:UIEdgeInsetsMake(20, 0, 0, 0)];
    self.addNewAddressTableView.separatorInset = UIEdgeInsetsMake(0, -15, 0, 0);
    [self.addNewAddressTableView registerNib:[UINib nibWithNibName:@"AddNewAddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddNewAddressTableViewCell"];
    self.addNewAddressTableView.tableFooterView = [self footerview];
    [self.view addSubview:self.addNewAddressTableView];
}

#pragma mark - footerview
-(UIView *)footerview{
    UIView * footerV = [[UIView alloc]initWithFrame:CGRectMake(-1, 0, SCREEN_WIDTH+2, 120)];
    footerV.layer.borderColor = RGBA(206, 207, 208, 1).CGColor;
    footerV.layer.borderWidth = 1;
    footerV.backgroundColor = [UIColor whiteColor];
    UILabel * lable = [[UILabel alloc]initWithFrame:CGRectMake(50, 20, 100, 25)];
    lable.text = @"设为默认地址";
    lable.textColor = [UIColor blackColor];
    lable.font = [UIFont systemFontOfSize:16];
    [footerV addSubview:lable];
    //设置默认地址按钮
    [footerV addSubview:self.defaultAddressButton];
    [self.defaultAddressButton addTarget:self action:@selector(setDefaultAddress:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(15, 65, SCREEN_WIDTH-30, 40);
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:RGBA(13, 75, 16, 1) forState:UIControlStateNormal];
    sureButton.layer.cornerRadius = 20;
    sureButton.layer.borderWidth = 1;
    sureButton.layer.borderColor = RGBA(127, 202, 0, 1).CGColor;
    [sureButton addTarget:self action:@selector(sureAddNewAddress) forControlEvents:UIControlEventTouchUpInside];
    [footerV addSubview:sureButton];
    return  footerV;
}

#pragma mark - 设为默认地址
-(void)setDefaultAddress:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.parameterArr[3] = @"1";
    }else{
        self.parameterArr[3] = @"0";
    }
}

#pragma mark - 确定添加新地址
-(void)sureAddNewAddress{
    NSMutableDictionary * paras = [[NSMutableDictionary alloc]init];
    NSArray * keyArr = @[@"name",@"phone",@"address",@"is_default"];
    for (int i =0 ; i<keyArr.count; i++) {
        if ([_parameterArr[i] isEqualToString:@""]) {
            [HUDManager toastmessage:@"请填写完整信息" superView:self.view];
            return;
        }
        [paras setObject:_parameterArr[i] forKey:keyArr[i]];
    }
    NSLog(@"%@",paras);
    [HTTPTool postWithPath:url_saveAddress params:paras success:^(id json) {
        if ([json[@"code"] intValue] == 200 && [json[@"success"] intValue] == 1) {
            [HUDManager toastmessage:@"保存成功" superView:self.view];
            self.freshAddressData();
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [HUDManager toastmessage:json[@"msg"] superView:self.view];
        }

    } failure:^(NSError *error) {
        
    } alertMsg:@"保存中..." successMsg:@"保存中..." failMsg:@"请求失败，请重试" showView:self.view];
}


-(UIButton *)defaultAddressButton{
    if (!_defaultAddressButton) {
        _defaultAddressButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _defaultAddressButton.frame = CGRectMake(15, 22.5, 20, 20);
        [_defaultAddressButton setImage:[UIImage imageNamed:@"select_fang_off"] forState:UIControlStateNormal];
        [_defaultAddressButton setImage:[UIImage imageNamed:@"select_fang_on"] forState:UIControlStateSelected];
    }
    return _defaultAddressButton;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddNewAddressTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AddNewAddressTableViewCell"];
    if (self.model) {
        switch (indexPath.row) {
            case 0:
                cell.infocontent.text = _model.name;
                self.parameterArr[0] = _model.name;
                break;
            case 1:
                cell.infocontent.text = _model.phone;
                self.parameterArr[1] = _model.phone;
                break;
            case 2:
                cell.infocontent.text = _model.address;
                self.parameterArr[2] = _model.address;
                break;
            default:
                break;
        }
        if ([_model.isDefault integerValue] == 1) {
            UIButton * defaultBtn = [self.addNewAddressTableView.tableFooterView.subviews lastObject];
            defaultBtn.selected = YES;
            self.parameterArr[3] = @"1";
        }else{
            self.parameterArr[3] = @"0";
        }
    }
    
    cell.infotitle.text = self.dataArr[indexPath.row];
    cell.infocontent.placeholder = self.placeholdArr[indexPath.row];
    cell.infocontent.delegate = self;
    cell.infocontent.tag = 1494+indexPath.row;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - 输入框delegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSInteger idx = textField.tag - 1494;
    self.parameterArr[idx] = textField.text;
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
