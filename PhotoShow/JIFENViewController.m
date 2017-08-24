//
//  JIFENViewController.m
//  PhotoShow
//
//  Created by SFC-a on 2017/7/25.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "JIFENViewController.h"

@interface JIFENViewController ()

/** 当前页数 */
@property (nonatomic) int page;
@property (nonatomic,retain) MJRefreshAutoNormalFooter * footerView ;


@end

@implementation JIFENViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.type = JIFENType;
    NSLog(@"jifen %@",self.mywalletTableView);

    self.topView.walletTotal.text = [NSString stringWithFormat:@"%@",[CommonTool getUserInfo][@"credit"]];
    
    WEAKSELF;
    self.mywalletTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakself.page = 0;
        weakself.isRefresh = YES;
        [weakself loadData];
    }];
    
    self.footerView = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakself.page++;
        weakself.isRefresh = NO;
        [weakself loadData];
    }];
    self.mywalletTableView.mj_footer = self.footerView;
    [self beginRefresh];

}


/** 加载数据 */

-(void)loadData{
    [HTTPTool postWithPath:url_myCredit params:@{@"page":[NSString stringWithFormat:@"%d",self.page],@"size":@"10"} success:^(id json) {
        if ([json[@"code"] intValue] == 200 && [json[@"success"] intValue] == 1) {
            if (self.isRefresh) {
                [self.dataArr removeAllObjects];
            }
            for (NSDictionary * creditDic in json[@"data"][@"creditLoglist"]) {
                MyWalletModel * model = [[MyWalletModel alloc]init];
                [model setValuesForKeysWithDictionary:creditDic];
                [self.dataArr addObject:model];
            }
            [self endRefresh];
            if ([json[@"data"][@"creditLoglist"] count] < 10) {
                [self.mywalletTableView.mj_footer endRefreshingWithNoMoreData];
            }
            if (self.dataArr.count>0){
                [self.footerView setTitle:@"没有更多数据了" forState:MJRefreshStateNoMoreData];
            }else{
                [self.footerView setTitle:@"暂无数据" forState:MJRefreshStateNoMoreData];
            }

            [self.mywalletTableView reloadData];
        }else{
            [HUDManager toastmessage:json[@"msg"] superView:self.view];
        }
    } failure:^(NSError *error) {
        [self endRefresh];
    }];
}


#pragma mark - UITableViewDelegate,UITableViewDataSource

//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (self.dataArr.count) {
//        self.footerView.text = @"";
//    }else{
//        self.footerView.text = @"暂无数据";
//        
//    }
//    return self.dataArr.count;
//}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    MywalletTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MywalletTableViewCell"];
//    if (self.dataArr) {
//        MyWalletModel * model = self.dataArr[indexPath.row];
//        cell.timeLabel.text = [CommonTool dateStringFromData:[model.createDate longLongValue]];
//        
//        cell.helperLabel.text = model.creditType;
//        cell.profitLabel.text = model.credit;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return cell;
//    }
//    
//    return nil;
//}


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
