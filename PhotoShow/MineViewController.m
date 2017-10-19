//
//  MineViewController.m
//  PhotoShow
//
//  Created by SFC-a on 2017/7/19.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "MineViewController.h"
#import "MineListTableViewCell.h"
#import "UserInfoTableViewController.h"
#import "AlbumDetailWebViewController.h"
#import "MyOrderViewController.h"
#import "MyWalletViewController.h"
#import "ViewController.h"
#import "UserModel.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain) UITableView * mineTV;
@property (nonatomic,retain) NSArray * dataArr;
/** 头像 */
@property (nonatomic,retain) UIImageView * headerImageView;

/** 姓名 */
@property (nonatomic,retain) UILabel * userNameLabel;
@property (nonatomic,retain) UIButton * moneyButton ;
@property (nonatomic,retain) UIButton * jifenButton;

@property (nonatomic,retain) NSArray * nextViewControllers;

@property (nonatomic,retain) UserModel * usermodel;



@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"我的";
    self.dataArr = @[@{@"title":@"我的钱包",@"img":@"mine_jifen"},@{@"title":@"我的订单",@"img":@"mine_myorder"},@{@"title":@"地址管理",@"img":@"mine_address"},@{@"title":@"我的分享",@"img":@"mine_share"}];//
    self.nextViewControllers = @[@"MyWalletViewController",@"MyOrderViewController",@"AddressViewController",@"AlbumDetailWebViewController"];//

    [self createUI];
    [self logout];
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoChanged:) name:@"userInfoChanged" object:nil];
    
    __weak typeof(self) weakself = self;
    self.leftNavBlock = ^{
        [[NSNotificationCenter defaultCenter] removeObserver:weakself];
        [weakself.navigationController popViewControllerAnimated:YES];
    };
}

#pragma mark - 创建UI
-(void)createUI{
    self.mineTV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49) style:UITableViewStylePlain];
    self.mineTV.delegate = self;
    self.mineTV.dataSource = self;
    self.mineTV.separatorInset = UIEdgeInsetsMake(0, -15, 0, 0);
    self.mineTV.scrollIndicatorInsets = UIEdgeInsetsMake(20, 0, 0, 0);

    [self.mineTV registerNib:[UINib nibWithNibName:@"MineListTableViewCell" bundle:nil] forCellReuseIdentifier:@"MineListTableViewCell"];
    [self.view addSubview:self.mineTV];
    
    //footerview
    UIView * footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.3)];
    footer.backgroundColor = [UIColor lightGrayColor];
    self.mineTV.tableFooterView = footer;
    
    //headerview
    UIImageView * headerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160)];
    headerView.userInteractionEnabled = YES;
    headerView.image = [UIImage imageNamed:@"nav_bg"];
    [headerView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoUserInfo:)]];
    
    self.headerImageView =  [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 65, 65)];
    self.headerImageView.layer.cornerRadius = 32.5;
    self.headerImageView.clipsToBounds = YES;
    self.headerImageView.image = [UIImage imageNamed:@"headerImg"];
    [headerView addSubview:self.headerImageView];
   
    
    self.userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 32.5, SCREEN_WIDTH/2, 30)];
    self.userNameLabel.text = @"名字";
    self.userNameLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:self.userNameLabel];
    
    UIImageView * rightArrow = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-40, 27.5, 40, 40)];
    rightArrow.image = [UIImage imageNamed:@"right_arrow"];
    [headerView addSubview:rightArrow];
    
    //底部站位视图
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 140, SCREEN_WIDTH, 20)];
    [CommonTool setBGColor:bottomView R:235 G:235 B:244 A:1];
    [headerView addSubview:bottomView];
    
    
    //左右两个button
    _moneyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _moneyButton.frame = CGRectMake(0, 95, SCREEN_WIDTH/2, 45);
    NSMutableAttributedString * leftattrstr = [[NSMutableAttributedString alloc]initWithString:@"余额 0元"];
    [leftattrstr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} range:NSMakeRange(0, 2)];
    [leftattrstr addAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, leftattrstr.length)];
    _moneyButton.layer.borderWidth = 0.5;
    _moneyButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [_moneyButton setAttributedTitle:leftattrstr forState:UIControlStateNormal];
    
    _jifenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _jifenButton.frame = CGRectMake(SCREEN_WIDTH/2, 95, SCREEN_WIDTH/2, 45);
    
    NSMutableAttributedString * rightattrstr = [[NSMutableAttributedString alloc]initWithString:@"积分 0"];
    [rightattrstr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} range:NSMakeRange(0, 2)];
    [rightattrstr addAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, rightattrstr.length)];
    _jifenButton.layer.borderWidth = 0.5;
    _jifenButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [_jifenButton setAttributedTitle:rightattrstr forState:UIControlStateNormal];
    [_jifenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [headerView addSubview:_moneyButton];
    [headerView addSubview:_jifenButton];
    
    [_moneyButton addTarget:self action:@selector(gotoMyWallet:) forControlEvents:UIControlEventTouchUpInside];
    [_jifenButton addTarget:self action:@selector(gotoMyWallet:) forControlEvents:UIControlEventTouchUpInside];

    self.mineTV.tableHeaderView = headerView;
}

-(void)gotoMyWallet:(UIButton *)btn{
    MyWalletViewController * vc = [[MyWalletViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MineListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MineListTableViewCell"];
    cell.mine_cell_img.image = [UIImage imageNamed:self.dataArr[indexPath.row][@"img"]];
    cell.mine_cell_title.text = self.dataArr[indexPath.row][@"title"];
    return cell;
}

#pragma mark - cell 点击跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 3) {
        AlbumDetailWebViewController * vc = [[AlbumDetailWebViewController alloc]init];
        vc.isShare = YES;
        vc.title = @"我的分享";
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        Class cl = NSClassFromString(self.nextViewControllers[indexPath.row]);
        [self.navigationController pushViewController:[[cl alloc]init] animated:YES];
    }
}

#pragma mark - 个人信息
-(void)gotoUserInfo:(UITapGestureRecognizer *)tap{
    
    UserInfoTableViewController * vc = [[UserInfoTableViewController alloc]init];
    [self.navigationController pushViewController:vc
                                         animated:YES];
}


#pragma mark - 退出登录
-(void)logout{
    UIButton * logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutBtn.backgroundColor = [UIColor whiteColor];
    
    [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [logoutBtn addTarget:self action:@selector(logoutClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutBtn];
    [logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.mas_equalTo(49);
    }];
    
    UIView * lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(logoutBtn.mas_top).offset(0);
    }];
}

-(void)logoutClick{
    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //获取Main.storyboard中的第2个视图
    ViewController * vc = [mainStory instantiateViewControllerWithIdentifier:@"ViewController"];
    [CommonTool logout];
    //设置窗体的根视图为Storyboard里的视图
    [CommonTool changeRootViewController:vc] ;
    NSLog(@"%@",vc);
}

#pragma mark -- 加载数据
-(void)loadData{
    [HTTPTool postWithPath:url_userinfo params:@{} success:^(id json) {
        if ([json[@"code"] intValue] == 200 && [json[@"success"] intValue]) {
            //保存个人信息
            [CommonTool setUserInfo:json[@"data"]];
            [self.usermodel setValuesForKeysWithDictionary:json[@"data"]];
            NSLog(@"%@",self.usermodel);
            NSLog(@"%@",[NSString stringWithFormat:@"%@%@",baseAPI,self.usermodel.headPortrait]);
            [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseAPI,self.usermodel.headPortrait]] placeholderImage:[UIImage imageNamed:@"headerImg"]];
            self.userNameLabel.text = self.usermodel.nickname ? self.usermodel.nickname : self.usermodel.username;
            NSMutableAttributedString * rightattrstr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"积分 %.0lf",self.usermodel.credit]];
            [rightattrstr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} range:NSMakeRange(0, 2)];
            [rightattrstr addAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, rightattrstr.length)];
            [_jifenButton setAttributedTitle:rightattrstr forState:UIControlStateNormal];
            
            NSMutableAttributedString * leftattrstr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"余额 %.2lf元",self.usermodel.money]];
            [leftattrstr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} range:NSMakeRange(0, 2)];
            [leftattrstr addAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, leftattrstr.length)];
            [_moneyButton setAttributedTitle:leftattrstr forState:UIControlStateNormal];

        }else{
            [HUDManager toastmessage:json[@"msg"] superView:self.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(UserModel *)usermodel{
    if (!_usermodel) {
        _usermodel = [[UserModel alloc]init];
    }
    return _usermodel;
}

#pragma mark -- 收到用户信息改变通知
-(void)userInfoChanged:(NSNotification *)noti{
    NSLog(@"%@",noti);
    [self loadData];
}


@end
