//
//  AddNewAlbumViewController.m
//  PhotoShow
//
//  Created by SFC-a on 2017/7/23.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "AddNewAlbumViewController.h"
#import "NewAlbumInputTableViewCell.h"
#import "NewALbumOptionTableViewCell.h"
#import "NewAlbumPhotoTemplateTableViewCell.h"
#import "NewAlbumPhotoCollectionViewCell.h"
#import "AlbumHeaderCollectionReusableView.h"
#import "LTDatePicker.h"
#import "AddNewAlbumViewModel.h"
#import "LTSinglePicker.h"

@interface AddNewAlbumViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,retain) UITableView * addAlbumTableView;

@property (nonatomic,retain) UICollectionView * photoCollectionView;

@property (nonatomic,retain) LTDatePicker * datePickerView;

@property (nonatomic) int photospage;

@property (nonatomic,retain) NSMutableDictionary * parametersDic;

@property (nonatomic,retain) NSDictionary * currentAlbumType;


/** 相册模板数组 */
@property (nonatomic,retain) NSArray * templateArr;

/** 用户所有照片 */
@property (nonatomic,retain) NSMutableArray * userPhotoArr;
/** 选中的照片 */
@property (nonatomic,retain) NSMutableArray * selectedPhotoArr;

@end

@implementation AddNewAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"新建相册";
    [self setNavigationBarRightItem:@"保存" itemImg:[UIImage imageNamed:@"nav_save"] currentNavBar:self.navigationItem curentViewController:self];
    WEAKSELF;
    self.rightNavBlock = ^{
        
        NSString * phoneids = @"";
        for (PhotosModel * model in weakself.selectedPhotoArr) {
            if ([phoneids isEqualToString:@""]) {
                phoneids = model.photoid;
            }
            phoneids = [NSString stringWithFormat:@"%@,%@",phoneids,model.photoid];
        }
        if (phoneids.length == 0){
            [HUDManager toastmessage:@"您还未选择照片" superView:weakself.view];
        }
        
        weakself.parametersDic[@"phoneids"] = phoneids;
        NSLog(@"%@",weakself.parametersDic);
        [HTTPTool postWithPath:url_createAlbums params:weakself.parametersDic success:^(id json) {
            if([json[@"code"] intValue]==200 && [json[@"success"] intValue] == 1){
                [HUDManager toastmessage:@"创建成功" superView:weakself.view];
                weakself.successBlock();
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakself.navigationController popViewControllerAnimated:YES];
                });
            }else{
                [HUDManager toastmessage:@"创建失败，请重试" superView:weakself.view];
            }
        } failure:^(NSError *error) {
            
        } alertMsg:@"正在保存..." successMsg:@"保存保存..." failMsg:@"保存失败" showView:weakself.view];
    };
    
    [self createUI];
    [self createCollectionView];
    
}


-(void)createUI{
    self.addAlbumTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    [CommonTool setBGColor:self.addAlbumTableView R:235 G:235 B:244 A:1];
    self.addAlbumTableView.delegate = self;
    self.addAlbumTableView.dataSource = self;
    [self.addAlbumTableView setContentInset:UIEdgeInsetsMake(0, 0, 100, 0)];
    self.addAlbumTableView.separatorInset = UIEdgeInsetsMake(0, -15, 0, 0);
    self.addAlbumTableView.estimatedRowHeight = 44;
    self.addAlbumTableView.rowHeight = UITableViewAutomaticDimension;
    [self.addAlbumTableView registerNib:[UINib nibWithNibName:@"NewAlbumInputTableViewCell" bundle:nil] forCellReuseIdentifier:@"NewAlbumInputTableViewCell"];
    [self.addAlbumTableView registerNib:[UINib nibWithNibName:@"NewALbumOptionTableViewCell" bundle:nil] forCellReuseIdentifier:@"NewALbumOptionTableViewCell"];
    [self.addAlbumTableView registerNib:[UINib nibWithNibName:@"NewAlbumPhotoTemplateTableViewCell" bundle:nil] forCellReuseIdentifier:@"NewAlbumPhotoTemplateTableViewCell"];

    WEAKSELF;
    self.photospage = 0;
    self.addAlbumTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakself.photospage++;
        [weakself loadPhotosData];
    }];
    
    [self.addAlbumTableView.mj_footer beginRefreshing];
    
    [self.view addSubview:self.addAlbumTableView];

}

-(void)createCollectionView{
    UICollectionViewFlowLayout * flow = [[UICollectionViewFlowLayout alloc]init];
    flow.itemSize = CGSizeMake(SCREEN_WIDTH/4, SCREEN_WIDTH*3/16);
    flow.minimumLineSpacing = 0;
    flow.minimumInteritemSpacing = 0;
    flow.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 44);
    _photoCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 303) collectionViewLayout:flow];
    _photoCollectionView.delegate = self;
    _photoCollectionView.dataSource = self;
    _photoCollectionView.bounces = NO;
    _photoCollectionView.backgroundColor = [UIColor whiteColor];
    [_photoCollectionView registerNib:[UINib nibWithNibName:@"NewAlbumPhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"NewAlbumPhotoCollectionViewCell"];
    
    [_photoCollectionView registerNib:[UINib nibWithNibName:@"AlbumHeaderCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"AlbumHeaderCollectionReusableView"];
    
    self.addAlbumTableView.tableFooterView = _photoCollectionView;
}

#pragma mark - 获取基础数据
-(void)loadBaseData{
    WEAKSELF;
    [AddNewAlbumViewModel getTemplateListWithType:self.parametersDic[@"albumType"] temlateContainer:objc_getAssociatedObject(self, @"templateContainer") Block:^(NSArray<TemplateModel *> * templateLists) {
        weakself.templateArr = templateLists;
    }];
}

#pragma mark - 获取所有相片
-(void)loadPhotosData{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithDictionary:@{@"page":[NSString stringWithFormat:@"%d",self.photospage],@"size":@"16"}];
    
    if (self.parametersDic[@"startTime"]) {
        dic[@"startTime"] =self.parametersDic[@"startTime"];
    }
    if (self.parametersDic[@"endTime"]) {
        dic[@"endTime"] =self.parametersDic[@"endTime"];
    }
    [AddNewAlbumViewModel getUserAllPhotosWithParameters:dic block:^(NSArray<PhotosModel *> * photomodels) {
        if (photomodels.count>0){
            [self.userPhotoArr addObjectsFromArray:photomodels];
            [self.photoCollectionView reloadData];
            [self.addAlbumTableView.mj_footer endRefreshing];
        }
        if (photomodels.count < 16) {
            [self.addAlbumTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } failure:^(NSError *error) {
        [self.addAlbumTableView.mj_footer endRefreshing];
    }];
}

#pragma mark - collectionView datasource
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView * view = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"AlbumHeaderCollectionReusableView" forIndexPath:indexPath];
    }
    return view;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64 + ((int)self.userPhotoArr.count/4+1)*SCREEN_WIDTH*3/16);
    self.addAlbumTableView.tableFooterView = collectionView;
    return self.userPhotoArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NewAlbumPhotoCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewAlbumPhotoCollectionViewCell" forIndexPath:indexPath];
    if (self.userPhotoArr.count > 0) {
        PhotosModel * model = self.userPhotoArr[indexPath.row];
        cell.selectItemButton.selected = model.isSelected;
        [cell.photoImageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseAPI,model.photoUrl]] placeholderImage:[UIImage imageNamed:image_placeholder]];
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotosModel * model = self.userPhotoArr[indexPath.item];
    NewAlbumPhotoCollectionViewCell * cell = (NewAlbumPhotoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (!model.isSelected) {
        model.isSelected = YES;
        cell.selectItemButton.selected = YES;
        [self.selectedPhotoArr addObject:model];
        //[cell addSubview:[self selectImageView:self.selectedPhotoArr.count + 1]];
    }else{
        model.isSelected = NO;
        cell.selectItemButton.selected = NO;
        for (int i = 0 ; i < self.selectedPhotoArr.count ; i++) {
            PhotosModel * selectedModel =self.selectedPhotoArr[i];
            if ([selectedModel.photoid integerValue] == [model.photoid integerValue]) {
                [_selectedPhotoArr removeObjectAtIndex:i];
                break;
            }
        }
    }
    [collectionView reloadData];

}

#pragma mark tableview datasource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  UITableViewAutomaticDimension;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NewAlbumInputTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NewAlbumInputTableViewCell"];
        cell.cellTextfield.delegate =self;
        return cell;
    }else if (indexPath.row == 2){
        NewAlbumPhotoTemplateTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NewAlbumPhotoTemplateTableViewCell"];
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            objc_setAssociatedObject(self, @"templateContainer", cell.templateAlbumContainer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [self loadBaseData];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(templateChanged:) name:@"templateChanged" object:nil];
        });
        return cell;
    }
    
    NewALbumOptionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NewALbumOptionTableViewCell"];
    if(indexPath.row == 1){
        if (self.currentAlbumType.count > 0) {
            cell.timeLabel.text = self.currentAlbumType[@"name"];
        }else{
            //默认是生活相册
            cell.timeLabel.text = @"生活日记";
            self.parametersDic[@"albumType"] = @"01";
        }
        cell.rightLogo.image = [UIImage imageNamed:@"daosanjiao"];
        [cell.rightLogo mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(19);
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(-19);
            make.width.mas_equalTo(10);
        }];
        
        cell.optionTitle.text = @"相册类型";
    }else if(indexPath.row == 3){
        cell.optionTitle.text = @"开始时间";
        cell.timeLabel.text = self.parametersDic[@"startTime"]?self.parametersDic[@"startTime"]:@"";
    }else if(indexPath.row == 4){
        cell.optionTitle.text = @"结束时间";
        cell.timeLabel.text = self.parametersDic[@"endTime"]?self.parametersDic[@"endTime"]:@"";
    }
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        LTSinglePicker * picker = [[LTSinglePicker alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-300, SCREEN_WIDTH, 300) dataArr:@[@{@"name":@"生活日记",@"type":@"01"},@{@"name":@"旅游相册",@"type":@"02"},@{@"name":@"成长相册",@"type":@"03"}]];
        __weak typeof(picker) weakpicker = picker;
        picker.block = ^(NSDictionary *result) {
            NewALbumOptionTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
            if (result) {
                cell.timeLabel.text = result[@"name"];
                _parametersDic[@"albumType"] = result[@"type"];
                _currentAlbumType = result;
            }
            [self loadBaseData];
            [weakpicker removeFromSuperview];
        };
        [self.view addSubview:picker];
    }else if (indexPath.row == 3 || indexPath.row == 4) {
        [self.view addSubview:self.datePickerView];
        [UIView animateWithDuration:0.3 animations:^{
            self.datePickerView.frame = CGRectMake(0, SCREEN_HEIGHT-300, SCREEN_WIDTH, 300);
        }];
        __weak typeof(self) weakSelf = self;
        void (^myblock)(NSString *) = ^(NSString * time){
            NSLog(@"%@",time);
            NewALbumOptionTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.timeLabel.text = time;
            if(indexPath.row == 3){
                //开始时间
                _parametersDic[@"startTime"] = time;
            }else{
                _parametersDic[@"endTime"] = time;
            }
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.datePickerView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300);
            }completion:^(BOOL finished) {
                [weakSelf.datePickerView removeFromSuperview];
            }];
        };
        self.datePickerView.returnBlock = myblock;
    }

}

#pragma mark -- 相册名称赋值
-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.parametersDic[@"albumName"] = textField.text;
}

#pragma mark - 收到模板改变发出的通知
-(void)templateChanged:(NSNotification *)noti{
    for (int i =0 ; i<self.templateArr.count; i++) {
        TemplateModel * model = self.templateArr[i];
        if (model.selectedImageView == noti.object) {
            _parametersDic[@"albumTemplateId"] = model.templateid;
        }
    }
    NSLog(@"%@",noti.object);
}

#pragma mark - 选中imageview 加 蒙版
-(UIView *)selectImageView:(NSInteger)idx{
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH/4-10, SCREEN_WIDTH*3/16-10)];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.5;
    UILabel * label = [[UILabel alloc]init];
    label.text = [NSString stringWithFormat:@"%ld",idx];
    label.textColor = [UIColor whiteColor];
    label.alpha = 1;
    label.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView.mas_centerX).offset(0);
        make.centerY.equalTo(bgView.mas_centerY).offset(0);
    }];
    return bgView;
}

#pragma mark - 懒加载
-(LTDatePicker *)datePickerView{
    if (!_datePickerView) {
        _datePickerView = [[LTDatePicker alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300)];
    }
    return _datePickerView;
}

-(NSMutableDictionary *)parametersDic{
    if (!_parametersDic) {
        _parametersDic = [[NSMutableDictionary alloc]init];
        _parametersDic[@"startTime"] = @"";
        _parametersDic[@"endTime"] = @"";
    }
    return _parametersDic;
}

-(NSDictionary *)currentAlbumType{
    if (!_currentAlbumType) {
        _currentAlbumType = [[NSDictionary alloc]init];
    }
    return _currentAlbumType;
}

-(NSMutableArray *)userPhotoArr{
    if (!_userPhotoArr) {
        _userPhotoArr = [[NSMutableArray alloc]init];
    }
    return _userPhotoArr;
}

-(NSMutableArray *)selectedPhotoArr{
    if (!_selectedPhotoArr ) {
        _selectedPhotoArr = [[NSMutableArray alloc]init];
    }
    return _selectedPhotoArr;
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
