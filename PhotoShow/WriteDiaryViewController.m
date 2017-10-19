//
//  WriteDiaryViewController.m
//  PhotoShow
//
//  Created by SFC-a on 2017/8/31.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "WriteDiaryViewController.h"
#import "EditingHeaderView.h"
#import "EditingTableViewCell.h"
#import "WeatherManager.h"
#import "UIKit+AFNetworking.h"
#import "LTDatePicker.h"
#import <objc/runtime.h>
#import "ImageManager.h"
#import "TextViewTableViewCell.h"
#import "WriteDiaryModuleTableViewCell.h"

#import <CoreLocation/CoreLocation.h>


@interface WriteDiaryViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate>

@property (nonatomic,retain) UITableView * editingTableView;

@property (nonatomic,retain) NSDictionary * weatherInfo;

@property (nonatomic,retain) LTDatePicker * datePickerView;

@property (nonatomic,retain) UIImagePickerController * imagePickerController;

@property (nonatomic,retain) EditingHeaderView * headerView ;

@property (nonatomic,retain) ImageManager * imageManager;

/** 保存图片 提交的参数 */
@property (nonatomic,retain) NSMutableDictionary * savePhotoParameters;

@property (nonatomic,retain) CLLocationManager * locationManager;

@property (nonatomic,retain) CLGeocoder * getcoder;

/** 
    是否有图片 如果有haveImg = 1 ,否则haveImg = 0
 */
@property (nonatomic) int haveImg;

@property (nonatomic,retain) WriteDiaryModuleTableViewCell * DiaryModuleCell;

@end

@implementation WriteDiaryViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"创建日记";
    
    [self setNavigationBarRightItem:@"保存" itemImg:[UIImage imageNamed:@"nav_save"] currentNavBar:self.navigationItem curentViewController:self];
    WEAKSELF;
    self.rightNavBlock = ^{
        __strong typeof(weakself) strongself = weakself;

        NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:strongself.savePhotoParameters];
        
        if ([strongself.savePhotoParameters[@"mood"] isEqualToString:@"写下您的心情说说..."]) {
            [params setObject:@"" forKey:@"mood"];
        }else{
            [params setObject:strongself.savePhotoParameters[@"mood"]?strongself.savePhotoParameters[@"mood"]:@"" forKey:@"mood"];
        }
        
        [params setObject:strongself.savePhotoParameters[@"address"] forKey:@"address"];
        
        if (strongself.savePhotoParameters[@"photo_time"]) {
            [params setObject:strongself.savePhotoParameters[@"photo_time"] forKey:@"photo_time"];
        }else{
            [params setObject:[CommonTool getCurrentTime] forKey:@"photo_time"];
        }
        NSLog(@"%@",params);

        if (_haveImg == 1) {
            //有照片
            if (strongself.DiaryModuleCell.textTop.selected) {
                [params setObject:@"02" forKey:@"type"];
            }else{
                [params setObject:@"01" forKey:@"type"];
            }

            [HTTPTool uploadImageWithPath:url_createDiaryPhoto params:params thumbName:@"imageData" image:weakself.headerView.photoview.image success:^(id json) {
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
        }else{
            //无照片
            [HTTPTool postWithPath:url_createDiary params:params success:^(id json) {
                if ([json[@"code"] integerValue] == 200 && [json[@"success"] intValue] == 1) {
                    [HUDManager toastmessage:@"保存成功" superView:strongself.view];
                    sleep(1.6);
                    [strongself.navigationController popViewControllerAnimated:YES];
                }else{
                    [HUDManager toastmessage:json[@"msg"] superView:strongself.view];
                }
            } failure:^(NSError *error) {
                [HUDManager toastmessage:@"保存失败" superView:strongself.view];
            } alertMsg:@"保存中..." successMsg:@"保存成功..." failMsg:@"保存失败" showView:strongself.view];
        }
    };
    [self initTableView];
    
    
    [self getLocation];
    
}

#pragma mark - 如果是添加照片 获取位置信息
-(void)getLocation{
    //如果已经授权
    self.locationManager = [[CLLocationManager alloc]init];
    
    if (![CLLocationManager locationServicesEnabled]) {
        //如果没有开启位置信息 给一个默认的 lat=40.242266&lng=116.2278
        [self getWeatherWithLocationLat:@"40.24226" lon:@"116.2278"];
        return;
    }
    //如果没有授权则当使用定位的时候请求用户授权
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [_locationManager requestWhenInUseAuthorization];
    }else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        //设置代理
        _locationManager.delegate = self;
        //设置精度
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //定位频率，也就是每隔多少米定位一次
        _locationManager.distanceFilter = 100.0;//每隔10米定位一次
        //启动跟踪定位
        [_locationManager startUpdatingLocation];
    }
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation * location = [locations firstObject];//取出第一个位置
    //获得位置坐标
    CLLocationCoordinate2D coord = location.coordinate;
    
    //获取天气情况
    [self getWeatherWithLocationLat:[NSString stringWithFormat:@"%lf",coord.latitude] lon:[NSString stringWithFormat:@"%lf",coord.longitude]];
    
    _getcoder = [[CLGeocoder alloc]init];
    [_getcoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark * placemark = [placemarks firstObject];
        NSLog(@"逆向地理编码：详细信息~~~%@",placemark.addressDictionary);
        NSLog(@"%@",[NSString stringWithFormat:@"%@%@%@%@",placemark.addressDictionary[@"State"],placemark.addressDictionary[@"City"],placemark.addressDictionary[@"SubLocality"],placemark.addressDictionary[@"Name"]]);
        [_savePhotoParameters setObject:[NSString stringWithFormat:@"%@%@%@%@",placemark.addressDictionary[@"State"],placemark.addressDictionary[@"City"],placemark.addressDictionary[@"SubLocality"],placemark.addressDictionary[@"Name"]] forKey:@"address"];
        [self.editingTableView reloadData];
    }];
    
    //如果不使用定位服务，使用完成之后及时关闭定位
    [manager stopUpdatingLocation];
    
}



#pragma mark - 获取天气
-(void)getWeatherWithLocationLat:(NSString *)lat lon:(NSString *)lon {
    //请求天气信息 成功后刷新列表
    WEAKSELF;
    [HTTPTool getWeatherWithLocationLat:lat lon:lon Success:^(id json) {
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
    [self.editingTableView registerNib:[UINib nibWithNibName:@"TextViewTableViewCell" bundle:nil] forCellReuseIdentifier:@"TextViewTableViewCell"];
    [self.editingTableView registerNib:[UINib nibWithNibName:@"WriteDiaryModuleTableViewCell" bundle:nil] forCellReuseIdentifier:@"WriteDiaryModuleTableViewCell"];

    self.editingTableView.estimatedRowHeight = 44;
    self.editingTableView.rowHeight = UITableViewAutomaticDimension;
    self.editingTableView.separatorInset = UIEdgeInsetsMake(0, -15, 0, 0);
    self.editingTableView.backgroundColor = THEMEBGCOLOR;
    self.headerView = [[EditingHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 270)];
    [self.headerView.cameraAgainBtn addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];

    [self.headerView.cameraAgainBtn setTitle:@"拍摄照片" forState:UIControlStateNormal];
    [self.headerView.selectPhotoAgainBtn setTitle:@"相册库" forState:UIControlStateNormal];

    [self.headerView.selectPhotoAgainBtn addTarget:self action:@selector(getPhotoFromLibray) forControlEvents:UIControlEventTouchUpInside];

    self.editingTableView.tableHeaderView = self.headerView;
    [self.view addSubview:self.editingTableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_haveImg == 1 && indexPath.row == 0) {
        //有照片
        return 158;
    }
    if (indexPath.row == 2+_haveImg){
        return 130;
    }
    return UITableViewAutomaticDimension;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3+_haveImg;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EditingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"EditingTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_haveImg == 1 && indexPath.row == 0) {
        WriteDiaryModuleTableViewCell * moduleCell = [tableView dequeueReusableCellWithIdentifier:@"WriteDiaryModuleTableViewCell"];
        self.DiaryModuleCell = moduleCell;
        return moduleCell;
    }else if (indexPath.row == (0+_haveImg)) {
        cell.rightlogoImgView.hidden =NO;
        cell.editingcontent.userInteractionEnabled = YES;
        cell.editingcontent.placeholder = @"输入地点";
        cell.editingcontent.delegate = self;
        if (self.weatherInfo.count>0) {
            [cell.rightlogoImgView setImageWithURL:[NSURL URLWithString:self.weatherInfo[@"showapi_res_body"][@"now"][@"weather_pic"]] placeholderImage:[UIImage imageNamed:@"photo_tianqi"]];
        }
        if (self.savePhotoParameters.count > 0){
            if (![_savePhotoParameters[@"address"] isEqual:[NSNull null]]) {
                cell.editingcontent.text = _savePhotoParameters[@"address"];
            }
            if (_savePhotoParameters[@"weatherUrl"] && ![_savePhotoParameters[@"weatherUrl"] isEqual:[NSNull null]]) {
                [cell.rightlogoImgView sd_setImageWithURL:[NSURL URLWithString:self.savePhotoParameters[@"weatherUrl"]] placeholderImage:[UIImage imageNamed:@"photo_tianqi"]];
            }
        }
        
        cell.leftlogoImgView.image = [UIImage imageNamed:@"photo_address"];

        
    }else if (indexPath.row == (1+_haveImg)){
        //时间
        cell.rightlogoImgView.hidden =YES ;
        cell.editingcontent.userInteractionEnabled = NO;
        cell.editingcontent.placeholder = @"点击选择时间";
        cell.leftlogoImgView.image = [UIImage imageNamed:@"photo_time"];
        NSLog(@"%@",[CommonTool getCurrentTime]);
        
        if (self.savePhotoParameters.count > 0 && _savePhotoParameters[@"photo_time"]) {
            cell.editingcontent.text = [CommonTool dateStringFromData:[_savePhotoParameters[@"photo_time"] doubleValue]];
        }else{
            cell.editingcontent.text = [CommonTool getCurrentTime];
        }
    }else if (indexPath.row == (2+_haveImg)){
        
        TextViewTableViewCell * textCell = [tableView dequeueReusableCellWithIdentifier:@"TextViewTableViewCell"];
        textCell.contentTextView.delegate = self;
        if (self.savePhotoParameters.count > 0 && ![_savePhotoParameters[@"mood"] isEqual:[NSNull null]]){
            textCell.contentTextView.text = _savePhotoParameters[@"mood"];
        }else{
            textCell.contentTextView.text = @"写下您的心情说说...";
        }
        return textCell;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    LTDatePicker * view = [[LTDatePicker alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT*2/3, SCREEN_WIDTH, SCREEN_HEIGHT/3)];
    if (indexPath.row == (1+_haveImg)) {
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


#pragma mark - textView  textField delegate

-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"写下您的心情说说..."]) {
        textView.text = @"";
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    [_savePhotoParameters setObject:textView.text forKey:@"mood"];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [_savePhotoParameters setObject:textField.text forKey:@"address"];
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
        _haveImg = 1;
        weakself.headerView.photoview.image = image;
        [weakself.editingTableView reloadData];
    };
    
}
-(void)takePhoto{
    [self.imageManager getImgWithIndex:0];
    WEAKSELF;
    _imageManager.ruternImage = ^(UIImage * image) {
        weakself.headerView.photoview.image = image;
        _haveImg = 1;
        [weakself.editingTableView reloadData];
    };
}

-(ImageManager *)imageManager{
    if (!_imageManager) {
        _imageManager = [[ImageManager alloc]init];
        _imageManager.aViewController = self;
    }
    return _imageManager;
}
@end
