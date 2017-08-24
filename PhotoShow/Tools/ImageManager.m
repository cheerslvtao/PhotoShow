//
//  HeaderImageUpload.m
//  SFCProduct
//
//  Created by SFC-赵灿 on 2017/5/31.
//  Copyright © 2017年 SFC. All rights reserved.
//

#import "ImageManager.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ImageManager ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>




@end

@implementation ImageManager

- (void)selectedImage:(UIViewController *)viewController {
    
    _aViewController = viewController;
    //头像
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction        = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *action1             = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self getImgWithIndex:0];
    }];
    UIAlertAction *action2             = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self getImgWithIndex:1];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [viewController presentViewController:alertController animated:YES completion:nil];
    
}

- (void)getImgWithIndex:(NSInteger)index {
    UIImagePickerController * imagePicker=[[UIImagePickerController alloc]init];
    imagePicker.view.backgroundColor = [UIColor whiteColor];
    imagePicker.delegate = self;
    // 是否允许编辑图片
    imagePicker.allowsEditing = NO;
    if (index == 0)
    {
        // 相机
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)
        {
            //无权限
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"打开相机开关" message:@"相机服务未开启,请进入系统【设置】>【隐私】>【相机】中打开开关,并允许搜辅材使用相机" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction        = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *action1             = [UIAlertAction actionWithTitle:@"前往设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self goToiOSSetting];
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:action1];
            [_aViewController presentViewController:alertController animated:YES completion:nil];
        }else{
            
        }
    }
    if (index == 1){
        // 相册
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        
        
        if (author == AVAuthorizationStatusRestricted || author == AVAuthorizationStatusDenied)
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"打开照片开关" message:@"照片服务未开启,请进入系统【设置】>【隐私】>【照片】中打开开关,并允许搜辅材使用照片" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction        = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *action1             = [UIAlertAction actionWithTitle:@"前往设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self goToiOSSetting];
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:action1];
            [_aViewController presentViewController:alertController animated:YES completion:nil];

        }else{
            
        }
        
        
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        imagePicker.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [_aViewController presentViewController:imagePicker animated:YES completion:nil];
}


#pragma mark - 图片保存完成后调用的方法
- (void)image:(UIImage* )image didFinishSave:(NSError * )error contentsInfo:(void *)contentInfo
{
    if (error == nil) {
        NSLog(@"图片保存成功");
    }else
    {
        NSLog(@"保存失败: %ld %@",(long)error.code,error.description);
    }
}

#pragma mark - UIImagePickerControllerDelegate
// 点击Cancle调用的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
// 选中图片调用的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image;
    if (picker.allowsEditing) {
        image = [info objectForKey:UIImagePickerControllerEditedImage];
    }else{
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    // 把拍得照片保存到本地相册
    //UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSave:contentsInfo:), nil);
    self.ruternImage(image);
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    if ([navigationController isKindOfClass:[UIImagePickerController class]])
    {
        viewController.navigationController.navigationBar.translucent = NO;
        viewController.edgesForExtendedLayout                         = UIRectEdgeNone;
    }
}


-(void)goToiOSSetting{
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        
        [[UIApplication sharedApplication] openURL:url];
        
    }
}


#define _FOUR_CC(c1,c2,c3,c4) ((uint32_t)(((c4) << 24) | ((c3) << 16) | ((c2) << 8) | (c1)))
#define _TWO_CC(c1,c2) ((uint16_t)(((c2) << 8) | (c1)))

ImageType ImageDetectType(CFDataRef data) {
    if (!data) return ImageTypeUnknow;
    uint64_t length = CFDataGetLength(data);
    if (length < 16) return ImageTypeUnknow;
    
    const char *bytes = (char *)CFDataGetBytePtr(data);
    
    uint32_t magic4 = *((uint32_t *)bytes);
    switch (magic4) {
        case _FOUR_CC(0x4D, 0x4D, 0x00, 0x2A): { // big endian TIFF
            return ImageTypeTIFF;
        } break;
            
        case _FOUR_CC(0x49, 0x49, 0x2A, 0x00): { // little endian TIFF
            return ImageTypeTIFF;
        } break;
            
        case _FOUR_CC(0x00, 0x00, 0x01, 0x00): { // ICO
            return ImageTypeICO;
        } break;
            
        case _FOUR_CC('i', 'c', 'n', 's'): { // ICNS
            return ImageTypeICNS;
        } break;
            
        case _FOUR_CC('G', 'I', 'F', '8'): { // GIF
            return ImageTypeGIF;
        } break;
            
        case _FOUR_CC(0x89, 'P', 'N', 'G'): {  // PNG
            uint32_t tmp = *((uint32_t *)(bytes + 4));
            if (tmp == _FOUR_CC('\r', '\n', 0x1A, '\n')) {
                return ImageTypePNG;
            }
        } break;
            
        case _FOUR_CC('R', 'I', 'F', 'F'): { // WebP
            uint32_t tmp = *((uint32_t *)(bytes + 8));
            if (tmp == _FOUR_CC('W', 'E', 'B', 'P')) {
                return ImageTypeWebP;
            }
        } break;
    }
    
    uint16_t magic2 = *((uint16_t *)bytes);
    switch (magic2) {
        case _TWO_CC('B', 'A'):
        case _TWO_CC('B', 'M'):
        case _TWO_CC('I', 'C'):
        case _TWO_CC('P', 'I'):
        case _TWO_CC('C', 'I'):
        case _TWO_CC('C', 'P'): { // BMP
            return ImageTypeBMP;
        }
        case _TWO_CC(0xFF, 0x4F): { // JPEG2000
            return ImageTypeJPEG2000;
        }
    }
    if (memcmp(bytes,"\377\330\377",3) == 0) return ImageTypeJPEG;
    if (memcmp(bytes + 4, "\152\120\040\040\015", 5) == 0) return ImageTypeJPEG2000;
    return ImageTypeUnknow;
}

@end
