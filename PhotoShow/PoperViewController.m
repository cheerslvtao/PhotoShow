//
//  PoperViewController.m
//  Lengendary
//
//  Created by SFC-a on 2017/3/18.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "PoperViewController.h"

@interface PoperViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * TBView;

@end

@implementation PoperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //制作  编辑   分享
//    NSArray * arr = @[@"制作",@"编辑",@"分享"];
    self.preferredContentSize = CGSizeMake(SCREEN_WIDTH/3, 45*self.itemTitles.count);
//    for (int i = 0; i<self.itemTitles.count; i++) {
//        UIButton *btn = [self createButtonwithRect:CGRectMake(0, 10+i*40, SCREEN_WIDTH*0.3, 30)];
//        [btn setTitle:self.itemTitles[i] forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
////        [btn setTitleColor:RGB(29, 45, 89, 1) forState:UIControlStateNormal];
//        btn.tag = 1045+i;
//        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 10+(i+1)*35, SCREEN_WIDTH*0.3, 1)];
//        lineView.backgroundColor = [UIColor lightGrayColor];
//        [self.view addSubview:lineView];
//        [self.view addSubview:btn] ;
//    }
    
    self.TBView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3, self.view.frame.size.height) style:UITableViewStylePlain];
    self.TBView.delegate = self;
    self.TBView.dataSource =self;
    self.TBView.separatorInset = UIEdgeInsetsMake(0, -15, 0, 0);
    [self.TBView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"popcell"];
    self.TBView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    [self.view addSubview:self.TBView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemTitles.count;
}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"popcell"];
    cell.textLabel.text = self.itemTitles[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    __weak typeof(self) weakself = self;
    [self dismissViewControllerAnimated:YES completion:^{
        weakself.block(indexPath.row);
    }];
}


-(UIButton *)createButtonwithRect:(CGRect)frame {
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

-(void)clickButton:(UIButton *)btn {
    __weak typeof(self) weakself = self;
    [self dismissViewControllerAnimated:YES completion:^{
         weakself.block(btn.tag - 1045);
    }];
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
