//
//  SubmitOrderViewController.m
//  PhotoShow
//
//  Created by SFC-a on 2017/7/24.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "SubmitOrderViewController.h"
#import "UserInfoDetailTableViewCell.h"
#import "SubmitOrderAddressTableViewCell.h"
#import "SubmitAlbumTempTableViewCell.h"
#import "PaymentTableViewCell.h"
#import "NumberPickerView.h"
#import "SubmitOrderBottomView.h"
#import "NumberAddTableViewCell.h"
#import "AddressModel.h"
#import "AddressViewController.h"
#import "LTSinglePicker.h"
#import "DocumentTableViewCell.h"
#import "AlipayHandle.h"
#import <AlipaySDK/AlipaySDK.h>

@interface SubmitOrderViewController ()<UITableViewDelegate,UITableViewDataSource,SubmitOrderDelegate,SelectAddressDelegate,alipayDelegate>

@property (nonatomic,retain) UITableView * submitTableView;

@property (nonatomic,retain) NSArray * titleArr;
/** contentArr to titleArr*/
@property (nonatomic,retain) NSMutableArray * contentArr;

@property (nonatomic,retain) SubmitOrderBottomView * bottomView;

@property (nonatomic,retain) NumberPickerView * numberView;

@property (nonatomic) CGFloat singlePrice;

@property (nonatomic,retain) AddressModel * currentAddressModel;

/** A4打印没份价钱 */
@property (nonatomic) CGFloat A4SinglePrice;
/** B5打印没份价钱 */
@property (nonatomic) CGFloat B5SinglePrice;
/** 运费 */
@property (nonatomic) CGFloat freight;
/** 积分 */
@property (nonatomic) NSInteger credit;

/** A4 B5 选择 */
@property (nonatomic,retain) LTSinglePicker * singlePicker;


@property (nonatomic,retain) NSString * order_id; //订单id
@property (nonatomic,retain) NSString * order_no; //订单编号

/** 支付方式  支付宝01 微信02 */
@property (nonatomic,retain) NSString * payment;

/** 制作份数 */
@property (nonatomic,retain) NSString * pageNumber;

/** 纸张类型 */
@property (nonatomic,retain) NSString * pageType;

@end

@implementation SubmitOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提交订单";
    [self initData];
    [self createTableview];
    
    /** 默认制作份数 1 */
    self.pageNumber = @"1";
    self.pageType = @"A4";
    self.bottomView = [[SubmitOrderBottomView alloc]init];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.mas_equalTo(49);
    }];
    self.bottomView.delegate = self;
}

#pragma mark - 初始化数据
-(void)initData{
    
    self.contentArr = [[NSMutableArray alloc]init];
    if (self.albumModel) {
        self.titleArr = @[@"制作效果预览",@"相册名称",@"相册类型",@"起止时间",@"纸张",@"制作份数"];
        [self.contentArr addObject:self.albumModel.albumPhoto];
        [self.contentArr addObject:self.albumModel.albumName];
        [self.contentArr addObject:[CommonTool getAlbumType:self.albumModel.albumType]];
        
        [self.contentArr addObject:[NSString stringWithFormat:@"%@至%@",[CommonTool dateStringFromData:[self.albumModel.startTime longLongValue]],[CommonTool dateStringFromData:[self.albumModel.endTime longLongValue]]]];
        [self.contentArr addObject:@"A4"]; //默认A4纸
        [self.contentArr addObject:@"1"]; //制作份数默认为1
    }else{
        self.titleArr = @[@"文档名称",@"文档类型",@"文档页数",@"纸张",@"制作份数"];
        [self.contentArr addObject:self.docModel.fileName];
        [self.contentArr addObject:self.docModel.fileType];
        [self.contentArr addObject:[NSString stringWithFormat:@"%@",self.docModel.filePage]];
        [self.contentArr addObject:@"A4"]; //默认A4纸
        [self.contentArr addObject:@"1"]; //制作份数默认为1
    }
    
    
    NSDictionary * dic = [[NSDictionary alloc]init];
    if (self.albumModel) {
        dic = @{@"id":self.albumModel.albumId,@"type":self.albumModel.albumType};
    }else if (self.docModel){
        dic = @{@"id":self.docModel.fileId,@"type":@"10"};
    }
    [HTTPTool postWithPath:url_printAlbum params:dic success:^(id json) {
        if ([json[@"code"] integerValue] == 200 && [json[@"success"] intValue] == 1) {
            self.currentAddressModel = [[AddressModel alloc]init];
            if (json[@"data"][@"userAddress"] != [NSNull null]) {
                [self.currentAddressModel setValuesForKeysWithDictionary:json[@"data"][@"userAddress"]];
            }
            self.credit = [json[@"data"][@"credit"] floatValue];
            self.freight = [json[@"data"][@"freight"] floatValue];

            if (self.albumModel){
                self.A4SinglePrice = [json[@"data"][@"a4money"] floatValue] * [json[@"data"][@"count"] intValue];
                self.B5SinglePrice = [json[@"data"][@"b5money"] floatValue] * [json[@"data"][@"count"] intValue];
                self.bottomView.orderPriceLabel.text = [NSString stringWithFormat:@"合计  ￥%.2f",_A4SinglePrice  + self.freight - self.credit];

            }else{
                self.A4SinglePrice = [json[@"data"][@"a4money"] floatValue] * [self.docModel.filePage intValue];
                self.B5SinglePrice = [json[@"data"][@"b5money"] floatValue] * [self.docModel.filePage intValue];
                self.bottomView.orderPriceLabel.text = [NSString stringWithFormat:@"合计  ￥%.2f",_B5SinglePrice + self.freight - self.credit];
            }

            [self.submitTableView reloadData];
        }else{
            [HUDManager toastmessage:json[@"msg"] superView:self.view];
        }
    } failure:^(NSError *error) {
        [HUDManager toastmessage:@"请求失败，请检查网络并重试" superView:self.view];
    }];
}

#pragma mark - 初始化 tableview
-(void)createTableview{
    _submitTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-48) style:UITableViewStylePlain];
    _submitTableView.delegate =self;
    _submitTableView.dataSource = self;
    _submitTableView.separatorInset = UIEdgeInsetsMake(0, -15, 0, 0);
    [_submitTableView registerNib:[UINib nibWithNibName:@"UserInfoDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"UserInfoDetailTableViewCell"];
    [_submitTableView registerNib:[UINib nibWithNibName:@"SubmitOrderAddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"SubmitOrderAddressTableViewCell"];
    [_submitTableView registerNib:[UINib nibWithNibName:@"SubmitAlbumTempTableViewCell" bundle:nil] forCellReuseIdentifier:@"SubmitAlbumTempTableViewCell"];
    [_submitTableView registerNib:[UINib nibWithNibName:@"PaymentTableViewCell" bundle:nil] forCellReuseIdentifier:@"PaymentTableViewCell"];
    [_submitTableView registerNib:[UINib nibWithNibName:@"NumberAddTableViewCell" bundle:nil] forCellReuseIdentifier:@"NumberAddTableViewCell"];
    if (self.docModel) {
        [_submitTableView registerNib:[UINib nibWithNibName:@"DocumentTableViewCell" bundle:nil] forCellReuseIdentifier:@"DocumentTableViewCell"];
    }

    _submitTableView.estimatedRowHeight = 44;
    _submitTableView.rowHeight = UITableViewAutomaticDimension;
    _submitTableView.backgroundColor = THEMEBGCOLOR;
    UIView * footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    footer.backgroundColor = THEMEBGCOLOR;
    _submitTableView.tableFooterView = footer;
    [self.view addSubview:_submitTableView];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3 ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return self.titleArr.count;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 2){
        return 50;
    }
    return UITableViewAutomaticDimension;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return  [self tableView:tableView addresscellForRowAtIndexPath:indexPath];
    }else if (indexPath.section == 1){
        if ( indexPath.row == 0) {
            return  [self tableView:tableView albumTemplateCellForRowAtIndexPath:indexPath];
        }else{
            return  [self tableView:tableView AlbumInfoCellForRowAtIndexPath:indexPath];
        }
    }
    
    return [self tableView:tableView paymentCellForRowAtIndexPath:indexPath];
}

/** 地址cell */
-(UITableViewCell *)tableView:(UITableView *)tableView addresscellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SubmitOrderAddressTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SubmitOrderAddressTableViewCell"];
    if (self.currentAddressModel && self.currentAddressModel.name) {
        cell.userNameAndPhoto.text = [NSString stringWithFormat:@"%@  %@",self.currentAddressModel.name,self.currentAddressModel.phone];
        cell.addressInfo.text = self.currentAddressModel.address;
    }else{
        cell.userNameAndPhoto.text = @"暂无地址信息";
        cell.addressInfo.text = @"点击选择地址";
    }
    return cell;
}

/** 相册模板cell  文档cell */
-(UITableViewCell *)tableView:(UITableView *)tableView albumTemplateCellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.docModel){
        DocumentTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"DocumentTableViewCell"];
        cell.FileNameLabel.text = [NSString stringWithFormat:@"%@%@",self.docModel.fileName,self.docModel.fileType];
        cell.FileTypeLabel.text = self.docModel.fileType;
        return cell;
    }else{
        SubmitAlbumTempTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SubmitAlbumTempTableViewCell"];
        [cell.templateAlbumImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseAPI,self.contentArr[indexPath.row]]] placeholderImage:[UIImage imageNamed:image_placeholder]];
        return cell;
    }
    return nil;
}

/** 其他信息cell */
-(UITableViewCell *)tableView:(UITableView *)tableView AlbumInfoCellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserInfoDetailTableViewCell * cell =  [tableView dequeueReusableCellWithIdentifier:@"UserInfoDetailTableViewCell"];
    cell.userInfoDetailTitle.text = self.titleArr[indexPath.row];
    if ((self.albumModel && indexPath.row == 5) || (self.docModel && indexPath.row == 4)) {
        NumberAddTableViewCell * numbercell = [tableView dequeueReusableCellWithIdentifier:@"NumberAddTableViewCell"];
        numbercell.numberView.numberTextField.text = self.contentArr[indexPath.row];
        WEAKSELF;
        numbercell.numberView.numberChanged = ^(NSString *number) {
            NSLog(@"%@",number);
            __strong typeof(weakself) strongself = weakself;

            strongself.pageNumber = number;
            
            [strongself caculate];
           
        };
        [self caculate];
        return numbercell;
    }else{
        cell.userInfoDetailInfo.text = self.contentArr[indexPath.row];
    }
    return cell;
}

#pragma mark - 计算金额
-(void)caculate{
    if ([self.pageType isEqualToString:@"A4"]) {
        //计算金额
        NSLog(@"%f * %@ + %f - %ld = ",_A4SinglePrice,self.pageNumber,self.freight,(long)self.credit);
        
        self.bottomView.orderPriceLabel.text = [NSString stringWithFormat:@"合计  ￥%.2f",_A4SinglePrice * [self.pageNumber intValue] + self.freight - self.credit/100];
    }else{            //计算金额
        NSLog(@"%f * %@ + %f - %ld = ",_B5SinglePrice,self.pageNumber,self.freight,(long)self.credit);
        
        self.bottomView.orderPriceLabel.text = [NSString stringWithFormat:@"合计  ￥%.2f",_B5SinglePrice * [self.pageNumber intValue] + self.freight - self.credit/100];
    }

}

/** 支付方式cell */
-(UITableViewCell *)tableView:(UITableView *)tableView paymentCellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PaymentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PaymentTableViewCell"];
//    if (indexPath.row == 0) {
//        cell.payment_title.text = @"微信支付";
//        cell.payment_icon.image = [UIImage imageNamed:@"icon_weixin"];
//        cell.payment_rightlogo.selected = YES;
//        self.payment = @"02";
//    }else{
    cell.payment_title.text = @"支付宝支付";
    cell.payment_icon.image = [UIImage imageNamed:@"icon_alipay"];
    cell.payment_rightlogo.selected = YES;
//    }
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        AddressViewController * vc = [[AddressViewController alloc]init];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if ((self.albumModel && indexPath.section == 1 && indexPath.row == 4) || (self.docModel && indexPath.section == 1 && indexPath.row == 3)) {
        [self.view addSubview:self.singlePicker];
        __weak typeof(_singlePicker) weaksinglePicker = _singlePicker;
        WEAKSELF;
        _singlePicker.block = ^(NSDictionary *result) {
            UserInfoDetailTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.userInfoDetailInfo.text = result[@"name"];
            weakself.pageType = result[@"name"];
            [weakself caculate];
            [weaksinglePicker removeFromSuperview];
        };
    }

//    if (indexPath.section == 2) {
//        PaymentTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
//        cell.payment_rightlogo.selected = YES;
//
//        if (indexPath.row == 0) {
//            //微信支付
//            self.payment = @"02";
//            PaymentTableViewCell * cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]];
//            cell.payment_rightlogo.selected = NO;
//
//        }else{
////            支付宝支付
//            self.payment = @"01";
//            PaymentTableViewCell * cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
//            cell.payment_rightlogo.selected = NO;
//
//        }
//        
//    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)selectAddress:(AddressModel *)model{
    self.currentAddressModel = model;
    [self.submitTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - SubmitOrderDelegate  提交订单
-(void)submitOrder{
    
    if (self.currentAddressModel.addressId == nil){
        [HUDManager toastmessage:@"请添加收货信息" superView:self.view];
        return;
    }
    
    //支付宝支付
    self.payment = @"01";

    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:@{@"addrssId":self.currentAddressModel.addressId,@"goodsType":self.albumModel?self.albumModel.albumType:@"10",@"goodsId":self.albumModel?self.albumModel.albumId:self.docModel.fileId,@"credit":@"0",@"payType":self.payment,@"quantity":self.pageNumber}];

    if ([self.pageType isEqualToString:@"A4"]) {
        [params setObject:@"A4" forKey:@"pageType"];
        [params setObject:[NSString stringWithFormat:@"%.2lf",_A4SinglePrice * [self.pageNumber intValue] + self.freight - self.credit/100] forKey:@"price"];
    }else{
        [params setObject:@"B5" forKey:@"pageType"];
        [params setObject:[NSString stringWithFormat:@"%.2lf",_B5SinglePrice * [self.pageNumber intValue] + self.freight - self.credit/100] forKey:@"price"];
    }
    
    [HTTPTool postWithPath:url_createOrder params:params success:^(id json) {
        if ([json[@"code"] integerValue] == 200 && [json[@"success"] intValue] == 1) {
            //[HUDManager toastmessage:@"订单已提交" superView:self.view];
            self.order_id =json[@"data"][@"order_id"];
            self.order_no =json[@"data"][@"pay_no"] ;

            [self payWithOrderName:json[@"data"][@"goods_name"] orderNo:json[@"data"][@"pay_no"] orderAmount:json[@"data"][@"price"]];
        }else{
            [HUDManager toastmessage:json[@"msg"] superView:self.view];
        }
    } failure:^(NSError *error) {
        [HUDManager toastmessage:@"提交失败，请重试" superView:self.view];
    } alertMsg:@"正在提交..." successMsg:@"正在提交..." failMsg:@"提交失败，请重试" showView:self.view];
    
    NSLog(@"提交订单");
}

#pragma mark - 支付
-(void)payWithOrderName:(NSString *)orderName orderNo:(NSString *)orderNo orderAmount:(NSString *)price{
    [AlipayHandle shareAlipay].delegate = self;
    [[AlipayHandle shareAlipay] AlipayPayWithOrderName:orderName orderNo:orderNo orderAmount:price];
}

-(void)payWith:(NSString *)orderString{
    
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:APPSchemes callback:^(NSDictionary *resultDic) {
        NSLog(@"submitOrder reslut = %@",resultDic);
        if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]){
            //支付成功
            [HUDManager toastmessage:@"支付成功" superView:self.view];
            [HTTPTool postWithPath:url_alipay_notify params:@{@"pay_no":self.order_no,@"order_id":self.order_id,@"success_order_id":resultDic[@"resultStatus"]} success:^(id json) {

                [HUDManager toastmessage:@"支付结果上传成功" superView:self.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            } failure:^(NSError *error) {
                
            } alertMsg:@"正在上传支付结果" successMsg:@"正在上传支付结果" failMsg:@"上传失败" showView:self.view];
        }else{
            //支付失败
            [HUDManager toastmessage:@"支付失败" superView:self.view];
        }
    }];
}

-(NumberPickerView *)numberView{
    if (!_numberView) {
        _numberView = [[NumberPickerView alloc]init];
    }
    return _numberView;
}

-(LTSinglePicker *)singlePicker{
    if (!_singlePicker) {
        _singlePicker = [[LTSinglePicker alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-250, SCREEN_WIDTH, 250) dataArr:@[@{@"name":@"A4"},@{@"name":@"B5"}]];
    }
    return _singlePicker;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
