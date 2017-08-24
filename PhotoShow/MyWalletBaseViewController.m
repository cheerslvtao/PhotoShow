//
//  MyWalletBaseViewController.m
//  PhotoShow
//
//  Created by SFC-a on 2017/7/25.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "MyWalletBaseViewController.h"
#import "EditingUserInfoViewController.h"
@interface MyWalletBaseViewController ()


@property (nonatomic,retain) NSArray * sectionTitles;



@end

@implementation MyWalletBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}

-(void)createUI{
    WEAKSELF;
    _topView = [[MyWallet alloc]initWithFrame:CGRectMake(0 , 20, SCREEN_WIDTH, 110)];
    _topView.getMoney = ^{
        EditingUserInfoViewController * vc = [[EditingUserInfoViewController alloc]init];
        vc.isEditingUserInfo = NO;
        vc.cash_fee = weakself.case_fee;
        
        [weakself.navigationController pushViewController:vc
                                                 animated:YES];
    };
    [self.view addSubview:_topView];
    
    self.mywalletTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 229, SCREEN_WIDTH, SCREEN_HEIGHT-229-64-44) style:UITableViewStylePlain];
    self.mywalletTableView.delegate =self;
    self.mywalletTableView.dataSource =self;
    self.mywalletTableView.separatorInset = UIEdgeInsetsMake(0, -15, 0, 0);
    self.mywalletTableView.contentInset = UIEdgeInsetsMake(0, 0, 15, 0);
    self.mywalletTableView.backgroundColor = THEMEBGCOLOR;
    [self.mywalletTableView registerNib:[UINib nibWithNibName:@"MywalletTableViewCell" bundle:nil] forCellReuseIdentifier:@"MywalletTableViewCell"];
    [self.view addSubview:self.mywalletTableView];
    
    //headerview
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 130, SCREEN_WIDTH, 55)];
    [self.view addSubview:self.headerView];
    
    UILabel * textLabel = [[UILabel alloc]init];
    textLabel.text = @"积分明细";
    textLabel.textColor = RGBA(3, 95, 15, 1);
    [self.headerView addSubview:textLabel];
    
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.equalTo(weakself.headerView.mas_centerY).offset(0);
    }];
    
    self.mywalletTableView.tableFooterView = [self footerViewForButi];

    self.sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 185, SCREEN_WIDTH, 44)];
    self.sectionView.backgroundColor = RGBA(246, 246, 255, 1);
    UILabel * profitLabel = [[UILabel alloc]init];
    profitLabel.text = @"积分数";
    [self.sectionView addSubview:profitLabel];

    [profitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.equalTo(weakself.sectionView.mas_centerY).offset(0);
    }];
    
    UILabel * helperlabel = [[UILabel alloc]init];
    helperlabel.text = @"获得渠道";
    [self.sectionView addSubview:helperlabel];
    [helperlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.sectionView.mas_centerX).offset(0);
        make.centerY.equalTo(weakself.sectionView.mas_centerY).offset(0);
        make.width.mas_equalTo(120);
    }];
    
    UILabel * timeLabel = [[UILabel alloc]init];
    timeLabel.text = @"时间";
    [self.sectionView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.equalTo(weakself.sectionView.mas_centerY).offset(0);
        make.width.mas_equalTo(80);
    }];
    [self.view addSubview:self.sectionView];
}


#pragma mark - 表尾
-(UIView *)footerViewForButi{
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    return footerView;
}

#pragma mark - 设置试图类型  余额、积分
-(void)setType:(walletType)type{
    _type = type;
    if(type == YUEType){
        [_topView showOtherInfo];
        _topView.walletTitle.text = @"当前余额";
    }
}


#pragma mark - UITableViewDelegate,UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MywalletTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MywalletTableViewCell"];
    if (self.dataArr) {
        MyWalletModel * model = self.dataArr[indexPath.row];
        cell.timeLabel.text = [CommonTool dateStringFromData:[model.createDate longLongValue]];
        
        if (_type == YUEType) {
            //余额
            cell.helperLabel.text = model.inviteUser;
            cell.profitLabel.text = model.money;
        }else{
            cell.helperLabel.text = model.creditType;
            cell.profitLabel.text = model.credit;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}


#pragma mark - 开始 、 结束 刷新
-(void)beginRefresh{
    [self.mywalletTableView.mj_header beginRefreshing];
}

-(void)endRefresh{
    [self.mywalletTableView.mj_header endRefreshing];
    [self.mywalletTableView.mj_footer endRefreshing];
}

-(NSMutableArray *)YuEdataArr{
    if (!_YuEdataArr) {
        _YuEdataArr = [[NSMutableArray alloc]init];
    }
    return _YuEdataArr;
}

-(NSMutableArray *)jifenDataArr{
    if (!_jifenDataArr) {
        _jifenDataArr =[[NSMutableArray alloc]init];

    }
    return _jifenDataArr;
}
@end
