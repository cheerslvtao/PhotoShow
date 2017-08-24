//
//  YUEViewController.m
//  PhotoShow
//
//  Created by SFC-a on 2017/7/25.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "YUEViewController.h"

@interface YUEViewController ()

/** 当前页数 */
@property (nonatomic) int page;

@property (nonatomic,retain) MJRefreshAutoNormalFooter * footerView ;

@end

@implementation YUEViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.type = YUEType;
    NSLog(@"yue %@",self.mywalletTableView);
    NSArray * sectionLables = [self.sectionView subviews];
    NSArray * titles = @[@"分润金额",@"贡献人",@"购买时间"];
    NSLog(@"%@",sectionLables);
    for (int i =0; i<sectionLables.count; i++) {
        UILabel * label = sectionLables[i];
        label.text = titles[i];
    }
    
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
    [HTTPTool postWithPath:url_myMoney params:@{@"page":[NSString stringWithFormat:@"%d",self.page],@"size":@"10"} success:^(id json) {
        if ([json[@"code"] intValue] == 200 && [json[@"success"] intValue] == 1) {
            !self.isRefresh?:[self.dataArr removeAllObjects];
            for (NSDictionary * creditDic in json[@"data"][@"userRewardList"]) {
                MyWalletModel * model = [[MyWalletModel alloc]init];
                [model setValuesForKeysWithDictionary:creditDic];
                [self.dataArr addObject:model];
            }
            self.topView.walletTotal.text = [NSString stringWithFormat:@"%@",json[@"data"][@"money"]];
            self.topView.cash_feeLabel.text = [NSString stringWithFormat:@"温馨提示：提现将会收取%.2f%%的手续费",[json[@"data"][@"cash_fee"] floatValue]];
            self.case_fee = [NSString stringWithFormat:@"%@",json[@"data"][@"cash_fee"]];
            [self endRefresh];
            if ([json[@"data"][@"userRewardList"] count] < 10) {
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
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (self.dataArr.count) {
//        self.footerView.text = @"";
//    }else{
//        self.footerView.text = @"暂无数据";
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
//        //余额
//        cell.helperLabel.text = model.inviteUser;
//        cell.profitLabel.text = model.money;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return cell;
//    }
//    
//    return nil;
//}


@end
