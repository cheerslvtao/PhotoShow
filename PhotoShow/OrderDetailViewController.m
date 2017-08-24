//
//  OrderDetailViewController.m
//  PhotoShow
//
//  Created by SFC-a on 2017/8/9.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "UserInfoDetailTableViewCell.h"
#import "PaymentTableViewCell.h"
#import "SubmitOrderAddressTableViewCell.h"
#import "SubmitAlbumTempTableViewCell.h"
#import "DocumentTableViewCell.h"

#import "SubmitOrderBottomView.h"
#import "AlbumModel.h"
#import "DocumentModel.h"

@interface OrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,SubmitOrderDelegate>

@property (nonatomic,retain) UITableView * orderDetailTableView;

@property (nonatomic,retain) NSArray * titleArr;

@property (nonatomic,retain) NSArray * contentArr;

@property (nonatomic,retain) SubmitOrderBottomView * bottomView;

@property (nonatomic,retain) AlbumModel * albumModel;
@property (nonatomic,retain) DocumentModel * documentModel;

@end

@implementation OrderDetailViewController

//-(AlbumModel *)albumModel{
//    if (!_albumModel) {
//        _albumModel = [[AlbumModel alloc]init];
//    }
//    return _albumModel;
//}
//-(DocumentModel *)documentModel{
//    if (!_documentModel) {
//        _documentModel = [[DocumentModel alloc]init];
//    }
//    return _documentModel;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"订单详情";
    if([[NSString stringWithFormat:@"%@",self.orderModel.goodsType] isEqualToString:@"10"]){
        self.titleArr = @[@"文档",@"订单状态",@"相册名称",@"相册类型",@"订单时间",@"纸张大小",@"制作份数"];
    }else{
        self.titleArr = @[@"相册模板",@"订单状态",@"相册名称",@"相册类型",@"订单时间",@"纸张大小",@"制作份数"];
    }
    self.contentArr = @[@"",self.orderModel.status,self.orderModel.goodsName,[CommonTool getAlbumType:[NSString stringWithFormat:@"%@",self.orderModel.goodsType]],[CommonTool dateStringFromData:[self.orderModel.addTime longLongValue]],self.orderModel.pageType,self.orderModel.quantity];
    
    [self createUI];
    [self loadOrderData];
    
}

-(void)createUI{
    self.orderDetailTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-55) style:UITableViewStylePlain];
    self.orderDetailTableView.delegate =self;
    self.orderDetailTableView.dataSource =self;
    self.orderDetailTableView.separatorInset = UIEdgeInsetsMake(0, -15, 0, 0);
    self.orderDetailTableView.backgroundColor = THEMEBGCOLOR;
    self.orderDetailTableView.estimatedRowHeight = 44;
    self.orderDetailTableView.rowHeight =  UITableViewAutomaticDimension;
    [self.orderDetailTableView registerNib:[UINib nibWithNibName:@"PaymentTableViewCell" bundle:nil] forCellReuseIdentifier:@"PaymentTableViewCell"];
    [self.orderDetailTableView registerNib:[UINib nibWithNibName:@"UserInfoDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"UserInfoDetailTableViewCell"];
    [self.orderDetailTableView registerNib:[UINib nibWithNibName:@"SubmitOrderAddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"SubmitOrderAddressTableViewCell"];
    
    if ([self.orderModel.status integerValue] == 0) {
        [self.orderDetailTableView registerNib:[UINib nibWithNibName:@"PaymentTableViewCell" bundle:nil] forCellReuseIdentifier:@"paycell"];
    }
    
    if ([[NSString stringWithFormat:@"%@",self.orderModel.goodsType] isEqualToString:@"10"]) {
        //文档
        [self.orderDetailTableView registerNib:[UINib nibWithNibName:@"DocumentTableViewCell" bundle:nil] forCellReuseIdentifier:@"DocumentTableViewCell"];
    }else{
        //相册
        [self.orderDetailTableView registerNib:[UINib nibWithNibName:@"SubmitAlbumTempTableViewCell" bundle:nil] forCellReuseIdentifier:@"SubmitAlbumTempTableViewCell"];
    }
    
    [self.view addSubview:self.orderDetailTableView];
    
    [self.view addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.mas_equalTo(49);
    }];
}

-(SubmitOrderBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[SubmitOrderBottomView alloc]init];
        [_bottomView.submitButton setTitle:@"支付" forState:UIControlStateNormal];
        _bottomView.delegate = self;
    }
    return _bottomView;
}

-(void)loadOrderData{
    [HTTPTool postWithPath:url_getOrder params:@{@"order_id":self.orderModel.orderId} success:^(id json) {
        if ([json[@"code"] intValue] == 200) {
            if ([[NSString stringWithFormat:@"%@",self.orderModel.goodsType] isEqualToString:@"10"]) {
                self.documentModel = [[DocumentModel alloc]init];
                [self.documentModel setValuesForKeysWithDictionary:json[@"data"][@"userFile"]];
            }else{
                self.albumModel = [[AlbumModel alloc]init];
                [self.albumModel setValuesForKeysWithDictionary:json[@"data"][@"userAlbum"]];
            }
            [self.orderDetailTableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -  提交订单 去支付
-(void)submitOrder{
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self.orderModel.status integerValue] == 0){
        return 3;
    }
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    if (section == 0) {
        return 1;
    }
    
    if ([self.orderModel.status integerValue] == 0 && section == 2){
        return 2;
    }
    return self.titleArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.orderModel.status intValue] == 0 && indexPath.section == 2){
        return 50;
    }
    return UITableViewAutomaticDimension;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 0){
            if (self.albumModel) {
                SubmitAlbumTempTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SubmitAlbumTempTableViewCell"];
                [cell.templateAlbumImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseAPI,self.albumModel.albumPhoto]] placeholderImage:[UIImage imageNamed:image_placeholder]];
                return cell;
            }else if(self.documentModel){
                DocumentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DocumentTableViewCell"];
                cell.FileTypeLabel.text = self.documentModel.fileType;
                cell.FileNameLabel.text = self.documentModel.fileName;
                return cell;
            }
        }
        UserInfoDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoDetailTableViewCell"];
        cell.userInfoDetailTitle.text = self.titleArr[indexPath.row];
        cell.userInfoDetailInfo.text = [NSString stringWithFormat:@"%@",self.contentArr[indexPath.row]];
        return  cell;
    }
    
    if ([self.orderModel.status intValue] == 0 && indexPath.section == 2){
        PaymentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"paycell"];
        if (indexPath.row == 0) {
            cell.payment_title.text = @"微信支付";
            cell.payment_icon.image = [UIImage imageNamed:@"icon_weixin"];
        }
        return cell;
    }
    
    SubmitOrderAddressTableViewCell * addresscell = [tableView dequeueReusableCellWithIdentifier:@"SubmitOrderAddressTableViewCell"];
    addresscell.userNameAndPhoto.text = [NSString stringWithFormat:@"%@  %@",self.orderModel.adressName,self.orderModel.adressPhone];
    addresscell.addressInfo.text = self.orderModel.address;
    addresscell.rightArrow.hidden = YES;
    return  addresscell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    if ([self.orderModel.status intValue] == 0 && section == 1) {
        return 10;
    }
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    view.backgroundColor = THEMEBGCOLOR;
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
