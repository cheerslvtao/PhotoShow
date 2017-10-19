//
//  HomeViewController.m
//  PhotoShow
//
//  Created by SFC-a on 2017/7/16.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeCollectionViewCell.h"
#import "FooterCollectionReusableView.h"
#import "MineViewController.h"
#import "PhotoShowListViewController.h"
#import "EditingAlbumViewController.h"
#import "SettingViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "ViewController.h"

@interface HomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,retain) UICollectionView * homeCollectionView;
@property (nonatomic,retain) NSArray * DataSource;

@property (nonatomic,retain) UIImagePickerController * imagePickerController;

@property (nonatomic,retain) UIImageView * imageView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.DataSource = @[@{@"title":@"生活日记",@"img":@"home_life_album"},@{@"title":@"旅游相册",@"img":@"home_travel_album"},@{@"title":@"成长相册",@"img":@"home_growup_album"},@{@"title":@"文档印刷",@"img":@"home_document_album"}];
    [self configNav];
    [self createUI];
}


#pragma mark - 配置导航
-(void)configNav{
    self.title = @"首页";

    [self setNavigationBarRightItem:nil itemImg:[UIImage imageNamed:@"home_rightitem"] currentNavBar:self.navigationItem curentViewController:self];
    [self setNavigationBarLeftItem:nil itemImg:[UIImage imageNamed:@"home_leftitem"] currentNavBar:self.navigationItem curentViewController:self];
    __weak typeof(self) weakself = self;
    self.rightNavBlock = ^{
        NSLog(@"right item click");
        [weakself.navigationController pushViewController:[[SettingViewController alloc]init] animated:YES];

    };
    self.leftNavBlock = ^{
        NSLog(@"left item click");
        [weakself.navigationController pushViewController:[[MineViewController alloc]init] animated:YES];
    };
}

#pragma mark - 检查是否登录
-(BOOL)checkLogin{
    
    return [NSUSERDEFAULT objectForKey:@"token"]?YES:NO;

}

#pragma mark - 配置UI
-(void)createUI{
    
    //添加一张大图作为背景图片
    UIImageView * bgImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    bgImageView.image = [UIImage imageNamed:@"bgIMG"];
    bgImageView.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:bgImageView];
    
    
    //Collectionview
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(SCREEN_WIDTH/2, SCREEN_WIDTH/2);
    layout.minimumInteritemSpacing = 0;
    layout.footerReferenceSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH/2);
    self.homeCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) collectionViewLayout:layout];
    self.homeCollectionView.delegate = self;
    self.homeCollectionView.dataSource = self;
    self.homeCollectionView.backgroundColor = [UIColor clearColor];
    
    [self.homeCollectionView registerNib:[UINib nibWithNibName:@"FooterCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterCollectionReusableView"];
    
    [self.homeCollectionView registerNib:[UINib nibWithNibName:@"HomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeCollectionViewCell"];
    
    
    [self.view addSubview:self.homeCollectionView];
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.DataSource.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionViewCell" forIndexPath:indexPath];
    cell.homeItemImageView.image = [UIImage imageNamed:self.DataSource[indexPath.item][@"img"]];
    cell.homeItemTitle.text = self.DataSource[indexPath.item][@"title"];
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",indexPath.item);
    if ([self checkLogin]) {
        PhotoShowListViewController * vc = [[PhotoShowListViewController alloc]init];
        vc.albumtype = indexPath.row+1;
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }else{
        UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //获取Main.storyboard中的第2个视图
        ViewController * vc = [mainStory instantiateViewControllerWithIdentifier:@"ViewController"];
        [self presentViewController:vc animated:YES completion:nil];
    }
   
}


-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionFooter) {
        FooterCollectionReusableView * footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"FooterCollectionReusableView" forIndexPath:indexPath];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(takePhoto:)];
        
        [footer.TakePhotoImageView addGestureRecognizer:tap];

        return footer;
    }
    return nil;
}


#pragma mark - 拍照相关
-(void)takePhoto:(UITapGestureRecognizer *)tap{
    
    //检测相机是否可用
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        //无权限
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"无法使用您的相机\n请前往设置->相册日记->相机打开开关" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"现在就去" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:url];
            }
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];

    }else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    }
    
}

-(UIImagePickerController *)imagePickerController{
    if (!_imagePickerController) {
        _imagePickerController = [[UIImagePickerController alloc]init];
        _imagePickerController.delegate =self;
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        _imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage]; //相机类型（拍照、录像...）字符串需要做相应的类型转换
        _imagePickerController.videoQuality = UIImagePickerControllerQualityTypeMedium; //相片质量
        _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto; //摄像头模式
        _imagePickerController.allowsEditing = NO;
        _imagePickerController.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    }
    return _imagePickerController;
}

/** 取消 */
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
     [self dismissViewControllerAnimated:YES completion:nil];
}

/** 完成选择 */
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
     EditingAlbumViewController * VC =  [[EditingAlbumViewController alloc]init];

     NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //如果是图片
        UIImage * sourceImage = info[UIImagePickerControllerOriginalImage];
        //压缩图片
        NSData *fileData = UIImageJPEGRepresentation(sourceImage, 1.0);
        
        VC.takePhotoImageData = fileData;
        
        //保存图片至相册
//        UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
    VC.type = AddAlbum;

    [self dismissViewControllerAnimated:NO completion:^{
        [self.navigationController pushViewController:VC animated:YES];
    }];
   
    
}



@end
