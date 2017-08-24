//
//  UserInfoTableViewController.m
//  PhotoShow
//
//  Created by SFC-a on 2017/7/20.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "UserInfoTableViewController.h"
#import "UserInfoHeaderTableViewCell.h"
#import "UserInfoDetailTableViewCell.h"
#import "ImageManager.h"
#import <objc/runtime.h>
#import "EditingUserInfoViewController.h"
@interface UserInfoTableViewController ()

@property (nonatomic,retain) NSArray * titleArr;
@property (nonatomic,retain) ImageManager * imagemanager;


@end

@implementation UserInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"个人信息";
    self.titleArr = @[@"",@"用户名",@"真实姓名",@"性别",@"手机号",@"邮箱"];
    
    [self loadData];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"UserInfoHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"UserInfoHeaderTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"UserInfoDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"UserInfoDetailTableViewCell"];
    UIView * footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    footer.backgroundColor = RGBA(206, 207, 208, 1);
    self.tableView.separatorInset = UIEdgeInsetsMake(0, -15, 0, 0);
    self.tableView.tableFooterView = footer;
    [self setNavigationBarLeftItem:@"返回" itemImg:[UIImage imageNamed:@"back"]];
    [self setNavigationBarRightItem:@"编辑"];
    
}

#pragma mark - 读取存储的用户人信息
-(void)loadData{
    self.usermodel = [[UserModel alloc]init];
    NSDictionary * userinfoDic = [CommonTool dictionaryWithJsonString:[NSUSERDEFAULT objectForKey:key_userinfo]];
    [self.usermodel setValuesForKeysWithDictionary:userinfoDic];
}

-(void)setNavigationBarLeftItem:(NSString * )itemTitle itemImg:(UIImage *)itemImg {
    UIButton * button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:itemImg forState:UIControlStateNormal];
    if (itemTitle) {
        [button setTitle:itemTitle forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
        button.frame = CGRectMake(0, 0, 70, 40);
    }else{
        button.frame = CGRectMake(0, 0, 40, 40);
    }
    
    
    [button addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item_button = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item_button;
}

-(void)leftItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setNavigationBarRightItem:(NSString * )itemTitle{
    
    UIButton * button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:itemTitle forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 40, 40);
    
    [button addTarget:self action:@selector(rightItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item_button = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item_button;
    
}

#pragma mark -  编辑页面
-(void)rightItemClick:(UIButton *)btn{
    EditingUserInfoViewController * vc = [[EditingUserInfoViewController alloc]init];
    vc.isEditingUserInfo = YES;
    WEAKSELF;
    vc.reloadBlock = ^{
        [weakself loadData];//重新读取数据 再刷新
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userInfoChanged" object:nil userInfo:@{@"viewcontroller":weakself}];
        [weakself.tableView reloadData];
    };
    vc.userInfoArr = [[NSMutableArray alloc]init];
    [vc.userInfoArr addObject:self.usermodel.nickname?self.usermodel.nickname:self.usermodel.username];
    [vc.userInfoArr addObject:self.usermodel.realname?self.usermodel.realname:@""];
    [vc.userInfoArr addObject:self.usermodel.sex?self.usermodel.sex:@""];
    [vc.userInfoArr addObject:self.usermodel.phone?self.usermodel.phone:@""];
    [vc.userInfoArr addObject:self.usermodel.email?self.usermodel.email:@""];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 60;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0){
        UserInfoHeaderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoHeaderTableViewCell" forIndexPath:indexPath];
        [cell.userHeaderView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseAPI,self.usermodel.headPortrait]] placeholderImage:[UIImage imageNamed:@"headerImg"]];

        objc_setAssociatedObject(self, @"headerImageView", cell.userHeaderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return cell;
    }
    UserInfoDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoDetailTableViewCell" forIndexPath:indexPath];
    switch (indexPath.row) {
        case 1:
            cell.userInfoDetailInfo.text = self.usermodel.nickname?self.usermodel.nickname:self.usermodel.username;
            break;
        case 2:
            cell.userInfoDetailInfo.text = self.usermodel.realname;
            break;
        case 3:
            cell.userInfoDetailInfo.text = self.usermodel.sex;
            break;
        case 4:
            cell.userInfoDetailInfo.text = self.usermodel.phone;
            break;
        case 5:
            cell.userInfoDetailInfo.text = self.usermodel.email;
            break;
        default:
            break;
    }
    cell.userInfoDetailTitle.text = self.titleArr[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self uploadheaderImage];
    }
}

#pragma mark - 上传头像
-(void)uploadheaderImage{
    
    _imagemanager = [[ImageManager alloc]init];
    
    __weak typeof(self) weakself = self;
    _imagemanager.ruternImage = ^(UIImage * image) {
        UIImageView * imageview = objc_getAssociatedObject(weakself, @"headerImageView");
        imageview.image = image;
        
        //上传
        [HTTPTool uploadImageWithPath:url_updateInfoPhoto params:nil thumbName:@"imageData" image:image success:^(id json) {
            NSLog(@"%@",json);
            //上传成功 更新个人信息
            [[NSNotificationCenter defaultCenter] postNotificationName:@"userInfoChanged" object:nil userInfo:@{@"viewcontroller":weakself}];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        } progress:^(CGFloat progress) {
            NSLog(@"%lf",progress);
        }];
        
    };
    [_imagemanager selectedImage:self];
}


@end
