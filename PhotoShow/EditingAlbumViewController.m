//
//  EditingAlbumViewController.m
//  PhotoShow
//
//  Created by SFC-a on 2017/7/26.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "EditingAlbumViewController.h"
#import "EditingHeaderView.h"
#import "EditingTableViewCell.h"
#import "PhotoCollectionView.h"
#import "WeatherManager.h"
#import "UIKit+AFNetworking.h"
#import "LTDatePicker.h"
#import <objc/runtime.h>
#import "ImageManager.h"

@interface EditingAlbumViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,retain) UITableView * editingTableView;

@property (nonatomic,retain) UITextView * descriptionTextView;

@property (nonatomic,retain) PhotoCollectionView * photoCV;

@property (nonatomic,retain) NSDictionary * weatherInfo;

@property (nonatomic,retain) LTDatePicker * datePickerView;

@property (nonatomic,retain) UIImagePickerController * imagePickerController;

@property (nonatomic,retain) EditingHeaderView * headerView ;

@property (nonatomic,retain) ImageManager * imageManager;

/** 保存图片 提交的参数 */
@property (nonatomic,retain) NSMutableDictionary * savePhotoParameters;

@end

@implementation EditingAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (_type == AddAlbum){
        self.title = @"保存照片";
        [self getWeather]; //如果是保存照片 直接获取天气情况
    }else{
        self.title = @"编辑相册";
    }
    

    [self setNavigationBarRightItem:@"保存" itemImg:[UIImage imageNamed:@"nav_save"] currentNavBar:self.navigationItem curentViewController:self];
    WEAKSELF;
    self.rightNavBlock = ^{
        NSLog(@"%@",weakself.savePhotoParameters);
        __strong typeof(weakself) strongself = weakself;
        NSString * urlstring = @"";
        NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
        if (strongself.type == AddAlbum) {
            urlstring = url_uploadImage;
            params =  strongself.savePhotoParameters;
        }else{
            urlstring = url_updateAlbumsPhotoFile;
            [params setObject:strongself.savePhotoParameters[@"id"] forKey:@"album_photo_id"];
            [params setObject:strongself.savePhotoParameters[@"mood"] forKey:@"mood"];
            
            [params setObject:strongself.savePhotoParameters[@"address"] forKey:@"address"];

        }
        
        if (strongself.savePhotoParameters[@"photo_time"]) {
            [params setObject:strongself.savePhotoParameters[@"photo_time"] forKey:@"photoTime"];
        }else{
            [params setObject:[CommonTool getCurrentTime] forKey:@"photoTime"];
        }
        
        [HTTPTool uploadImageWithPath:urlstring params:params thumbName:@"imageData" image:weakself.headerView.photoview.image success:^(id json) {
            NSLog(@"%@",json);
            //
            [HUDManager toastmessage:@"保存成功" superView:strongself.view];
            sleep(1.6);
            [strongself.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        } progress:^(CGFloat progress) {
            NSLog(@"%lf",progress);
        }];
    };
    
    [self initTableView];

   
    
    
}

#pragma mark - 获取天气
-(void)getWeather{
    //请求天气信息 成功后刷新列表
    WEAKSELF;
    [HTTPTool getWeatherSuccess:^(id json) {
        __strong typeof(weakself) strongself = weakself;
        strongself.weatherInfo = json;
        NSLog(@"天气 -----  %@",json);
        [strongself.savePhotoParameters setObject:json[@"showapi_res_body"][@"now"][@"weather"] forKey:@"weather"];
        [strongself.savePhotoParameters setObject:json[@"showapi_res_body"][@"now"][@"weather_pic"] forKey:@"Weather_url"];
        [strongself.editingTableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 初始化tableview
-(void)initTableView{
    self.editingTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    self.editingTableView.delegate = self;
    self.editingTableView.dataSource = self;
    [self.editingTableView registerNib:[UINib nibWithNibName:@"EditingTableViewCell" bundle:nil] forCellReuseIdentifier:@"EditingTableViewCell"];
    self.editingTableView.estimatedRowHeight = 44;
    self.editingTableView.rowHeight = UITableViewAutomaticDimension;
    self.editingTableView.separatorInset = UIEdgeInsetsMake(0, -15, 0, 0);
    self.editingTableView.backgroundColor = THEMEBGCOLOR;
    self.headerView = [[EditingHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 270)];
    [self.headerView.cameraAgainBtn addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.selectPhotoAgainBtn addTarget:self action:@selector(getPhotoFromLibray) forControlEvents:UIControlEventTouchUpInside];
    if (self.type == AddAlbum) {
        self.headerView.photoview.image = [UIImage imageWithData:self.takePhotoImageData];
        [self.headerView.selectPhotoAgainBtn removeFromSuperview];
    }
    
    self.editingTableView.tableHeaderView = self.headerView;
    if (_type == EditingAlbum){
        //如果是编辑相册 才显示相片列表
        self.editingTableView.tableFooterView = self.photoCV;
    }
    [self.view addSubview:self.editingTableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EditingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"EditingTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0 ) {
        cell.editingcontent.placeholder = @"输入拍照地点";
        cell.editingcontent.delegate = self;
        if (self.weatherInfo.count>0 && self.type == AddAlbum) {
            [cell.rightlogoImgView setImageWithURL:[NSURL URLWithString:self.weatherInfo[@"showapi_res_body"][@"now"][@"weather_pic"]] placeholderImage:[UIImage imageNamed:@"photo_tianqi"]];
        }
        if (self.savePhotoParameters.count > 0){
            if (![_savePhotoParameters[@"address"] isEqual:[NSNull null]]) {
                cell.editingcontent.text = _savePhotoParameters[@"address"];
            }
            if (![_savePhotoParameters[@"weatherUrl"] isEqual:[NSNull null]]) {
                [cell.rightlogoImgView setImageWithURL:[NSURL URLWithString:self.savePhotoParameters[@"weatherUrl"]] placeholderImage:[UIImage imageNamed:@"photo_tianqi"]];
            }
        }

    }else if (indexPath.row == 1){
        //时间
        [cell.rightlogoImgView removeFromSuperview];
        cell.editingcontent.userInteractionEnabled = NO;
        cell.editingcontent.placeholder = @"点击选择时间";
        cell.leftlogoImgView.image = [UIImage imageNamed:@"photo_time"];
        NSLog(@"%@",[CommonTool getCurrentTime]);

        if (self.savePhotoParameters.count > 0 && _savePhotoParameters[@"photo_time"]) {
            cell.editingcontent.text = [CommonTool dateStringFromData:[_savePhotoParameters[@"photo_time"] doubleValue]];
        }else{
            cell.editingcontent.text = [CommonTool getCurrentTime];
        }
    }else if (indexPath.row == 2){
        [cell.rightlogoImgView removeFromSuperview];
        [cell.leftlogoImgView removeFromSuperview];
        [cell.editingcontent removeFromSuperview];
        [cell.contentView addSubview:self.descriptionTextView];
        [self.descriptionTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.offset(15);
            make.right.bottom.offset(-15);
            make.height.mas_equalTo(100);
        }];
        if (self.savePhotoParameters.count > 0 && ![_savePhotoParameters[@"mood"] isEqual:[NSNull null]]){
            self.descriptionTextView.text = _savePhotoParameters[@"mood"];
        }else{
            self.descriptionTextView.text = @"";
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    LTDatePicker * view = [[LTDatePicker alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT*2/3, SCREEN_WIDTH, SCREEN_HEIGHT/3)];
    if (indexPath.row == 1) {
        [self.view addSubview:self.datePickerView];
        [UIView animateWithDuration:0.3 animations:^{
            self.datePickerView.frame = CGRectMake(0, SCREEN_HEIGHT-300, SCREEN_WIDTH, 300);
        }];
        __weak typeof(self) weakSelf = self;
        void (^myblock)(NSString *) = ^(NSString * time){
            NSLog(@"%@",time);
            EditingTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.editingcontent.text = time;
            [_savePhotoParameters setObject:time forKey:@"photo_time"];
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.datePickerView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300);
            }completion:^(BOOL finished) {
                [weakSelf.datePickerView removeFromSuperview];
            }];
        };
        self.datePickerView.returnBlock = myblock;
    }
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.datePickerView removeFromSuperview];
}

-(LTDatePicker *)datePickerView{
    if (!_datePickerView) {
        _datePickerView = [[LTDatePicker alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300)];
    }
    return _datePickerView;
}


#pragma mark - 心情输入框
-(UITextView *)descriptionTextView{
    if(!_descriptionTextView){
        _descriptionTextView = [[UITextView alloc]init];
        _descriptionTextView.delegate = self;
        _descriptionTextView.layer.borderWidth =1;
        _descriptionTextView.layer.borderColor = THEMEBGCOLOR.CGColor;
        _descriptionTextView.layer.cornerRadius = 5;
        _descriptionTextView.text = @"写下此刻心情...";
    }
    return _descriptionTextView;
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"写下此刻心情..."]) {
        textView.text = @"";
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    [_savePhotoParameters setObject:textView.text forKey:@"mood"];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [_savePhotoParameters setObject:textField.text forKey:@"address"];
}

#pragma mark - 获取照片信息并展示
-(PhotoCollectionView *)photoCV{
    if (!_photoCV) {
        _photoCV = [[PhotoCollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        _photoCV.albumId = self.albumId;
        WEAKSELF;
        _photoCV.block = ^(NSDictionary *modelDic) {
            weakself.savePhotoParameters = [[NSMutableDictionary alloc]initWithDictionary:modelDic];
            [weakself.headerView.photoview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseAPI,modelDic[@"photoUrl"]]] placeholderImage:[UIImage imageNamed:image_placeholder]];
            [weakself.editingTableView reloadData];
        };
    }
    return _photoCV;
}

-(NSMutableDictionary *)savePhotoParameters{
    if (!_savePhotoParameters) {
        _savePhotoParameters = [[NSMutableDictionary alloc]init];
    }
    return _savePhotoParameters;
}

#pragma mark - 拍照
-(void)getPhotoFromLibray{

    [self.imageManager getImgWithIndex:1];
    WEAKSELF;
    _imageManager.ruternImage = ^(UIImage * image) {
        weakself.headerView.photoview.image = image;
    };

}

-(void)takePhoto{
    [self.imageManager getImgWithIndex:0];
    WEAKSELF;
    _imageManager.ruternImage = ^(UIImage * image) {
        weakself.headerView.photoview.image = image;
    };
    
}

-(ImageManager *)imageManager{
    if (!_imageManager) {
        _imageManager = [[ImageManager alloc]init];
        _imageManager.aViewController = self;
    }
    return _imageManager;
}
//
//-(void)getPhotoFrom:(int)type{
//    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
//    {
//        //无权限
//        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"无法使用您的相机\n请前往设置->相册日记->相机打开开关" preferredStyle:UIAlertControllerStyleAlert];
//        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            
//        }]];
//        [alert addAction:[UIAlertAction actionWithTitle:@"现在就去" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//            
//            if([[UIApplication sharedApplication] canOpenURL:url]) {
//                NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
//                [[UIApplication sharedApplication] openURL:url];
//            }
//            
//        }]];
//        [self presentViewController:alert animated:YES completion:nil];
//        
//    }else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        [self presentViewController:self.imagePickerController animated:YES completion:nil];
//    }
//
//}
//
//-(UIImagePickerController *)imagePickerController{
//    if (!_imagePickerController) {
//        _imagePickerController = [[UIImagePickerController alloc]init];
//        _imagePickerController.delegate =self;
//        _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//        _imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage]; //相机类型（拍照、录像...）字符串需要做相应的类型转换
//        _imagePickerController.videoQuality = UIImagePickerControllerQualityTypeMedium; //相片质量
//        _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto; //摄像头模式
//        _imagePickerController.allowsEditing = NO;
//        _imagePickerController.modalTransitionStyle = UIModalTransitionStylePartialCurl;
//    }
//    return _imagePickerController;
//}
//
///** 取消 */
//-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
///** 完成选择 */
//-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
//    
//    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
//    //判断资源类型
//    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
//        //如果是图片
//        self.headerView.photoview.image = info[UIImagePickerControllerOriginalImage];
//        //保存图片至相册
//        //        UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
//    }
//    
//    [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
//}

@end
