//
//  MyOrderViewController.m
//  PhotoShow
//
//  Created by SFC-a on 2017/7/21.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "MyOrderViewController.h"
#import "MyOrderTableViewCell.h"
#import "FilterOrderView.h"
#import "OrderDetailViewController.h"

@interface MyOrderViewController ()<UITableViewDelegate,UITableViewDataSource,FilterDelegate>

@property (nonatomic,retain) UITableView * orderTableView;

@property (nonatomic,strong) NSMutableArray * dataArr;

@property (nonatomic,retain) FilterOrderView * filterView ;

@property (nonatomic) int page;

@end

@implementation MyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"我的订单";

    [self setNavigationBarRightItem:@"筛选" itemImg:[UIImage imageNamed:@"nav_search"] currentNavBar:self.navigationItem curentViewController:self];
    
    WEAKSELF;
    self.rightNavBlock = ^{
        NSLog(@"right item");
        UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.5;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:weakself action:@selector(filterBGViewDismiss:)];
        [bgView addGestureRecognizer:tap];
        objc_setAssociatedObject(weakself, @"filterBGView", bgView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [weakself.view addSubview:bgView];
        
        weakself.filterView = [[FilterOrderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 360)];
        weakself.filterView.backgroundColor = [UIColor whiteColor];
        weakself.filterView.delegate = weakself;
        [weakself.view addSubview:weakself.filterView];
    };
    
    self.orderTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    self.orderTableView.delegate = self;
    self.orderTableView.dataSource = self;
    self.orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.orderTableView registerNib:[UINib nibWithNibName:@"MyOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyOrderTableViewCell"];
    self.orderTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakself.page = 0;
        [weakself loadData:nil];
    }];
    
    self.orderTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakself.page++;
        [weakself loadData:nil];
    }];

    [self.orderTableView.mj_header beginRefreshing];

    [self.view addSubview:self.orderTableView];
}

#pragma mark -- 筛选相关
-(void)filterBGViewDismiss:(UITapGestureRecognizer *)tap{
    [UIView animateWithDuration:0.3 animations:^{
        self.filterView.frame = CGRectMake(0, -300, SCREEN_WIDTH, 300);
        tap.view.alpha = 0;
    }completion:^(BOOL finished) {
        [tap.view removeFromSuperview];
        [self.filterView removeFromSuperview];
    }];
}

-(void)filterOrderWith:(NSDictionary *)filterParameter{
    NSLog(@"%@",filterParameter);
    UIView * view = objc_getAssociatedObject(self, @"filterBGView");
    [UIView animateWithDuration:0.3 animations:^{
        self.filterView.frame = CGRectMake(0, -300, SCREEN_WIDTH, 300);
        view.alpha = 0;
    }completion:^(BOOL finished) {
        [view removeFromSuperview];
        [self.filterView removeFromSuperview];
    }];
    self.page = 0;
    [self loadData:filterParameter];
}

#pragma mark - 加载数据
-(void)loadData:(NSDictionary *)dic{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:@{@"page":[NSString stringWithFormat:@"%d",self.page],@"size":@"10"}];
    if (dic) {
        [params setValue:dic[@"albumTime"] forKey:@"time"];
        [params setValue:dic[@"albumType"] forKey:@"type"];
        [params setValue:dic[@"albumName"] forKey:@"name"];
    }
    
    [HTTPTool postWithPath:url_getOrders params:params success:^(id json) {
        [self.orderTableView.mj_header endRefreshing];
        [self.orderTableView.mj_footer endRefreshing];
        if(self.page == 0){
            [self.dataArr removeAllObjects];
        }
        if ([json[@"code"] integerValue] == 200 && [json[@"success"] intValue] == 1) {
            if ([json[@"data"][@"list"] count] < 10) {
                [self.orderTableView.mj_footer endRefreshingWithNoMoreData];
            }
            for (int i = 0; i<[json[@"data"][@"list"] count]; i++) {
                OrderListModel * model = [[OrderListModel alloc]init];
                [model setValuesForKeysWithDictionary:json[@"data"][@"list"][i]];
                [self.dataArr addObject:model];
            }
            [self.orderTableView reloadData];
        }else{
            [HUDManager toastmessage:json[@"msg"] superView:self.view];
        }
    } failure:^(NSError *error) {
        [self.orderTableView.mj_header endRefreshing];
        [self.orderTableView.mj_footer endRefreshing];
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyOrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyOrderTableViewCell"];
    if (self.dataArr.count>0) {
        cell.orderModel = self.dataArr[indexPath.row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderDetailViewController * vc = [[OrderDetailViewController alloc]init];
    vc.orderModel = self.dataArr[indexPath.row];
    [self.navigationController pushViewController:vc
                                         animated:YES];
}


-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
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
