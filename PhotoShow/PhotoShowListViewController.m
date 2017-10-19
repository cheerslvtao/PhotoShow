//
//  PhotoShowListViewController.m
//  PhotoShow
//
//  Created by SFC-a on 2017/7/22.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "PhotoShowListViewController.h"
#import "PhotoShowListTableViewCell.h"
#import "PoperViewController.h"
#import "AddNewAlbumViewController.h"
#import "AlbumDetailWebViewController.h"
#import "FileManagerTool.h"
#import "AlbumModel.h"
#import "DocumentModel.h"
#import "FileUploadViewController.h"
#import "DocumentTableViewCell.h"
#import "SubmitOrderViewController.h"
#import "EditingAlbumViewController.h"
#import "WriteDiaryViewController.h"

@interface PhotoShowListViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIPopoverPresentationControllerDelegate>

@property (nonatomic,retain) UITableView * albumTableView;

@property (nonatomic,strong) NSMutableArray * dataArr;

@property (nonatomic,retain) UITextField * keyWordTextField;

@property (nonatomic,retain) UILabel * footerView;

@property (nonatomic) int filepage;

@property (nonatomic) BOOL isrefresh;

@end

@implementation PhotoShowListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.albumTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    [CommonTool setBGColor:self.albumTableView R:235 G:235 B:244 A:1];
    self.albumTableView.delegate = self;
    self.albumTableView.dataSource = self;
    [self.albumTableView setContentInset:UIEdgeInsetsMake(0, 0, 100, 0)];
    self.albumTableView.separatorInset = UIEdgeInsetsMake(0, -15, 0, 0);
    [self.albumTableView registerNib:[UINib nibWithNibName:@"PhotoShowListTableViewCell" bundle:nil] forCellReuseIdentifier:@"PhotoShowListTableViewCell"];
    [self.albumTableView registerNib:[UINib nibWithNibName:@"DocumentTableViewCell" bundle:nil] forCellReuseIdentifier:@"DocumentTableViewCell"];
    [self.view addSubview:self.albumTableView];
    self.albumTableView.tableHeaderView = [self headerView];
    self.albumTableView.tableFooterView = [self footerView];
    [self setAddNewAddressButton];
    
    if (self.albumtype == documentAlbum) {
        WEAKSELF;
        self.albumTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakself.filepage = 0;
            weakself.isrefresh = YES;
            [weakself loadFileDataWithSearch:NO];
        }];
        
        self.albumTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            weakself.filepage++;
            weakself.isrefresh = NO;
            [weakself loadFileDataWithSearch:NO];
        }];
        
        [self.albumTableView.mj_header beginRefreshing];
    }else if(self.albumtype == LifeAlbum){
        UIButton * button =  [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"写日记" forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, 60, 44);
        [button addTarget:self action:@selector(writeDiray) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem * item_button = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = item_button;
        
        [self loadData:NO];
        
    }else{
        [self loadData:NO];
    }
}

-(void)writeDiray{
    WriteDiaryViewController * vc = [[WriteDiaryViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 加载日记列表
-(void)loadDiaryDataWithSearch:(BOOL)isSearch{
//    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:@{@"page":[NSString stringWithFormat:@"%d",self.filepage],@"size":@"10"}];
//    if (_keyWordTextField.text.length > 0 && isSearch) {
//        params[@"album_name"] = _keyWordTextField.text;
//    }
//    [HTTPTool postWithPath:url_getDiarys params:params success:^(id json) {
//        if ([json[@"code"] integerValue] == 200 && [json[@"success"] integerValue] == 1) {
//            if (self.isrefresh) {
//                [self.dataArr removeAllObjects];
//            }
//            for (NSDictionary * dic in json[@"data"][@"userFiles"]) {
////                DocumentModel * model = [[DocumentModel alloc]init];
////                [model setValuesForKeysWithDictionary:dic];
////                [self.dataArr addObject:model];
//            }
//            [self.albumTableView reloadData];
//        }
//        [self.albumTableView.mj_header endRefreshing];
//        if ([json[@"data"][@"userFiles"] count] == 0) {
//            [self.albumTableView.mj_footer endRefreshingWithNoMoreData];
//        }else{
//            [self.albumTableView.mj_footer endRefreshing];
//        }
//    } failure:^(NSError *error) {
//        [self.albumTableView.mj_header endRefreshing];
//        
//        [self.albumTableView.mj_footer endRefreshing];
//    } ];
    [self loadData:NO];
}


#pragma mark - 加载相册列表
-(void)loadData:(BOOL)isSearch{
    
    //02旅游相册，03成长相册
    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:@{@"albumType":[NSString stringWithFormat:@"0%lu",(unsigned long)self.albumtype]}];
    if (_keyWordTextField.text.length > 0 && isSearch) {
        params[@"album_name"] = _keyWordTextField.text;
    }
    [HTTPTool postWithPath:url_getAlbums params:params success:^(id json) {
        if ([json[@"code"] integerValue] == 200 && [json[@"success"] integerValue] == 1) {
            [self.dataArr removeAllObjects];
            for (NSDictionary * dic in json[@"data"][@"albumList"]) {
                AlbumModel * model = [[AlbumModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArr addObject:model];
            }
            [self.albumTableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }alertMsg:@"加载中..." successMsg:@"加载中..." failMsg:@"加载失败" showView:self.view];
}

#pragma mark - 加载文件列表
-(void)loadFileDataWithSearch:(BOOL)isSearch{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:@{@"page":[NSString stringWithFormat:@"%d",self.filepage],@"size":@"10"}];
    if (_keyWordTextField.text.length > 0 && isSearch) {
        params[@"album_name"] = _keyWordTextField.text;
    }
    [HTTPTool postWithPath:url_findFiles params:params success:^(id json) {
        if ([json[@"code"] integerValue] == 200 && [json[@"success"] integerValue] == 1) {
            if (self.isrefresh) {
                [self.dataArr removeAllObjects];
            }
            for (NSDictionary * dic in json[@"data"][@"userFiles"]) {
                DocumentModel * model = [[DocumentModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArr addObject:model];
            }
            [self.albumTableView reloadData];
        }
        [self.albumTableView.mj_header endRefreshing];
        if ([json[@"data"][@"userFiles"] count] == 0) {
            [self.albumTableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.albumTableView.mj_footer endRefreshing];
        }
    } failure:^(NSError *error) {
        [self.albumTableView.mj_header endRefreshing];
  
        [self.albumTableView.mj_footer endRefreshing];
    } ];
}

#pragma mark - 新建相册
-(void)setAddNewAddressButton{
    UIButton * addNewAlbumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addNewAlbumBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    addNewAlbumBtn.frame = CGRectMake(SCREEN_WIDTH/2-25, SCREEN_HEIGHT - 135, 50, 50);
    [addNewAlbumBtn addTarget:self action:@selector(addNewAlbum) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addNewAlbumBtn];
}

-(void)addNewAlbum{
    if(self.albumtype == documentAlbum){
        [self.navigationController pushViewController:[[FileUploadViewController alloc]init] animated:YES];
    }else{
       AddNewAlbumViewController * vc = [[AddNewAlbumViewController alloc]init];
        vc.successBlock = ^{
            [self loadData:NO];
        };
        if (self.albumtype == LifeAlbum) {
            vc.albumType = @"01";
        }
        switch (self.albumtype) {
            case LifeAlbum:
                vc.albumType = @"01";
                break;
            case travelAlbum:
                vc.albumType = @"02";
                break;
            case growupAlbum:
                vc.albumType = @"03";
                break;
            case documentAlbum:
                vc.albumType = @"10";
                break;
            default:
                break;
        }
        vc.albumName = self.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArr.count == 0) {
//        return 1;
        self.footerView.text = @"暂无数据";
    }else{
        self.footerView.text = @"";
    }
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataArr.count == 0) {
        
        return nil;
    }
    if (_albumtype == documentAlbum) {
        DocumentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DocumentTableViewCell"];
        DocumentModel * model = self.dataArr[indexPath.row];
        cell.FileNameLabel.text = [NSString stringWithFormat:@"%@%@",model.fileName,model.fileType];
        cell.FileTypeLabel.text = model.fileType;
        return cell;
    }else{
        PhotoShowListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoShowListTableViewCell"];

        cell.album_name.numberOfLines = 1;
        cell.model = self.dataArr[indexPath.row];
          return cell;
    }
    
    return nil;
    
  
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if(self.albumtype == documentAlbum){
        //文档列表点击直接进入提交订单页面
        SubmitOrderViewController * vc = [[SubmitOrderViewController alloc]init];
        vc.docModel = self.dataArr[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        //相册详情
        AlbumDetailWebViewController * vc = [[AlbumDetailWebViewController alloc]init];
        vc.albumModel = self.dataArr[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
   
}

#pragma mark - 侧滑删除

//是否可以编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//左滑 组件定义
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * paramsDic = nil;
    NSString * del_url = @"";
    if (self.albumtype == documentAlbum) {
        DocumentModel * model = self.dataArr[indexPath.row];
        paramsDic = @{@"file_id":model.fileId};
        del_url = url_delFile;
    }else{
        AlbumModel * model = self.dataArr[indexPath.row];
        paramsDic = @{@"id":model.albumId};
        del_url = url_delAlbums;
    }
    
    //创建 左滑 的选项 以及点击事件
    UITableViewRowAction * deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        //写点击选项时候的事件
        [HTTPTool postWithPath:del_url params:paramsDic success:^(id json) {
            if ([json[@"code"] integerValue] == 200 && [json[@"success"] intValue] == 1) {
                [self.dataArr removeObjectAtIndex:indexPath.row];
                [tableView reloadData];
            }
        } failure:^(NSError *error) {
            
        } alertMsg:@"正在删除..." successMsg:@"正在删除..." failMsg:@"删除失败" showView:self.view];
    }];
    deleteRowAction.backgroundColor = [UIColor redColor];
    return @[deleteRowAction];
}



-(void)setAlbumtype:(albumType)albumtype{
    _albumtype = albumtype;
    switch (_albumtype-1) {
        case 0:
            self.title = @"生活日记";
            break;
        case 1:
            self.title = @"旅游相册";
            break;
        case 2:
            self.title = @"成长相册";
            break;
        case 3:
            self.title = @"文档印刷";
            break;
            
        default:
            break;
    }
}



#pragma mark - 筛选 headerView
-(UIView *)headerView{
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
    [CommonTool setBGColor:headerView R:235 G:235 B:244 A:1];
    
    self.keyWordTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH-30, 40)];
    self.keyWordTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.keyWordTextField.placeholder = @"输入名称";
    self.keyWordTextField.layer.borderColor = RGBA(161, 189, 125, 1).CGColor;
    self.keyWordTextField.layer.borderWidth = 1;
    self.keyWordTextField.layer.cornerRadius = 5.f;
    
    UIView * rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    rightView.layer.cornerRadius = 5.f;
    //竖线
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, 1, 20)];
    lineView.backgroundColor =  RGBA(119, 148, 127, 1);
    [rightView addSubview:lineView];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(5, 0, 75, 40);
    [btn setTitle:@"筛选" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn addTarget:self action:@selector(showSelectPop:) forControlEvents:UIControlEventTouchUpInside];
    
    [rightView addSubview:btn];
    
    self.keyWordTextField.rightView = rightView;
    self.keyWordTextField.rightViewMode = UITextFieldViewModeAlways;
    [headerView addSubview:self.keyWordTextField];
    
    return headerView;
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

#pragma mark - 筛选
-(void)showSelectPop:(UIButton *)btn{
    
    [self loadData:YES];
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
