//
//  AddressViewController.m
//  PhotoShow
//
//  Created by SFC-a on 2017/7/21.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "AddressViewController.h"
#import "AddressTableViewCell.h"
#import "AddressModel.h"
#import "AddNewAddressViewController.h"
@interface AddressViewController ()<UITableViewDelegate,UITableViewDataSource,AddressInfoDelegate>

@property (nonatomic,retain) UITableView * addressTableView;

@property (nonatomic,strong) NSMutableArray * dataArr;

@property (nonatomic,retain) UILabel * footerView;

@property (nonatomic) int page;

@end

@implementation AddressViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"地址管理";
    
    self.addressTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    [CommonTool setBGColor:self.addressTableView R:235 G:235 B:244 A:1];
    self.addressTableView.delegate = self;
    self.addressTableView.dataSource = self;
    [self.addressTableView setContentInset:UIEdgeInsetsMake(20, 0, 100, 0)];
    self.addressTableView.separatorInset = UIEdgeInsetsMake(0, -15, 0, 0);
    [self.addressTableView registerNib:[UINib nibWithNibName:@"AddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddressTableViewCell"];
    self.addressTableView.tableFooterView = self.footerView;
    [self.view addSubview:self.addressTableView];
    [self loadData];
    [self setAddNewAddressButton];
}

#pragma mark - 数据处理
-(void)loadData{
    [HTTPTool postWithPath:url_addressAll params:nil success:^(id json) {
        if ([json[@"code"] intValue] == 200 && [json[@"success"] intValue] == 1) {
            [self.dataArr removeAllObjects];
            for (NSDictionary * addressDic in json[@"data"][@"userAddressList"]) {
                AddressModel * model = [[AddressModel alloc]init];
                [model setValuesForKeysWithDictionary:addressDic];
                [self.dataArr addObject:model];
            }
            [self.addressTableView reloadData];
        }else{
            [HUDManager toastmessage:json[@"msg"] superView:self.view];
        }
    } failure:^(NSError *error) {
        
    } alertMsg:@"加载中..." successMsg:@"加载中..." failMsg:@"请求失败，请重试" showView:self.view];
}


#pragma mark - 添加新地址按钮
-(void)setAddNewAddressButton{
    UIButton * addNewAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addNewAddressBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    addNewAddressBtn.frame = CGRectMake(SCREEN_WIDTH/2-25, SCREEN_HEIGHT - 135, 50, 50);
    [addNewAddressBtn addTarget:self action:@selector(addNewAddress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addNewAddressBtn];
}

-(void)addNewAddress{
    AddNewAddressViewController  * vc = [[AddNewAddressViewController alloc]init];
    WEAKSELF;
    vc.freshAddressData = ^{
        [weakself loadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArr.count == 0) {
        self.footerView.text = @"暂无数据";
    }else{
        self.footerView.text = @"";
    }

    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddressTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AddressTableViewCell"];
//    [cell.fixedButton addTarget:self action:@selector(fixedAddress:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.dataArr) {
        cell.defaultAddress.tag = indexPath.row + 74526;
        cell.fixedButton.tag = indexPath.row + 5448;
        cell.deleteButton.tag  = indexPath.row + 675843;
        cell.modelArr = self.dataArr;
        cell.model = self.dataArr[indexPath.row];
        cell.delegate = self;
    }
    return cell;
    
}

#pragma mark - 修改删除订单  AddressInfoDelegate
-(void)tableviewReloadData{
    [self loadData];
}

-(void)fixedAddressInfo:(AddressModel *)addressmodel{
    AddNewAddressViewController  * vc = [[AddNewAddressViewController alloc]init];
    vc.model = addressmodel;
    WEAKSELF;
    vc.freshAddressData = ^{
        [weakself loadData];
    };
    [self.navigationController pushViewController:vc animated:YES];

}

-(void)deleteAddress:(NSString *)addressId{
    
    [HTTPTool postWithPath:url_delAddress params:@{@"id":addressId} success:^(id json) {
        if ([json[@"code"]integerValue]==200 && [json[@"success"] integerValue]== 1) {
            [self loadData];
        }else{
            [HUDManager toastmessage:json[@"msg"] superView:self.view];
        }
    } failure:^(NSError *error) {
        
    } alertMsg:@"删除中..." successMsg:@"删除中..." failMsg:@"操作失败，请重试" showView:self.view];
}

-(void)fixedAddress:(UIButton *)btn{
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(selectAddress:)]) {
        [_delegate selectAddress:self.dataArr[indexPath.row]];
        [self.navigationController popViewControllerAnimated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return  _dataArr;
}

#pragma mark - 表尾
-(UILabel *)footerView{
    if (!_footerView) {
        _footerView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _footerView.textAlignment = NSTextAlignmentCenter;
        _footerView.textColor = [UIColor lightGrayColor];
    }
    return _footerView;
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
