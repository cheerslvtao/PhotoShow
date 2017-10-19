//
//  FileUploadViewController.m
//  PhotoShow
//
//  Created by SFC-a on 2017/8/7.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "FileUploadViewController.h"
#import "FileManagerTool.h"
#import "AlbumDetailWebViewController.h"

@interface FileUploadViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain) NSArray * dataArr;

@property (nonatomic,retain) UITableView * fileTableview;

@end

@implementation FileUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"文件上传";
    
    self.dataArr = (NSMutableArray *)[FileManagerTool getFileFromDevice];
    
    if (_dataArr.count > 0){
        [self createUI];
    }else{
        UILabel * alertlabel = [[UILabel alloc]init];
        alertlabel.text = @"您还未导入任何文件\n请按照以下流程前往iTunes导入文件";
        alertlabel.textAlignment = NSTextAlignmentCenter;
        alertlabel.numberOfLines = 0;
        alertlabel.textColor = [UIColor grayColor];
        [self.view addSubview:alertlabel];
        [alertlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.offset(0);
            make.height.mas_equalTo(80);
        }];
        
        
        UIImage * image = [UIImage imageNamed:@"addFile"];
        UIImageView * imageView = [[UIImageView alloc]initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.clipsToBounds = YES;
        UIScrollView * scrolleView = [[UIScrollView alloc]init];
        [self.view addSubview:scrolleView];
        [scrolleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(alertlabel.mas_bottom).offset(0);
            make.left.offset(0);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.height.mas_equalTo(SCREEN_HEIGHT-64-80);
        }];
        [scrolleView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.offset(0);
            make.width.mas_equalTo(SCREEN_WIDTH);
        }];
        scrolleView.contentSize = CGSizeMake(SCREEN_WIDTH, imageView.frame.size.height);

    }
    
    
}

-(void)createUI{
    self.fileTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    [CommonTool setBGColor:self.fileTableview R:235 G:235 B:244 A:1];
    self.fileTableview.delegate = self;
    self.fileTableview.dataSource = self;
    self.fileTableview.separatorInset = UIEdgeInsetsMake(0, -15, 0, 0);
    [self.fileTableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"fileCell"];
    self.fileTableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    [self.view addSubview:self.fileTableview];

}

#pragma mark - 上传文当
-(void)uploadFile:(NSIndexPath *)indexPath{
    FileModel * model = self.dataArr[indexPath.row];
    //如果不是pdf 和 PPT 类型的文档 不允许上传
    
        [HTTPTool uploadImageWithPath:url_uploadFile params:nil thumbName:@"imageData" fileName:model.fileName file:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:model.filePath]] success:^(id json) {
            NSLog(@"%@",json);
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        } progress:^(CGFloat progress) {
            NSLog(@"%f",progress);
        }];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"fileCell"];
    cell.textLabel.text = [self.dataArr[indexPath.row] fileName];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AlbumDetailWebViewController * vc = [[AlbumDetailWebViewController alloc]init];
    FileModel * model = self.dataArr[indexPath.row];
    vc.filePath = model.filePath;
    vc.model = model;
    NSLog(@"%@",vc.filePath);
    [self.navigationController pushViewController:vc animated:YES];

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
