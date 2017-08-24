//
//  HUDManager.h
//  PhotoShow
//
//  Created by SFC-a on 2017/8/3.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface HUDManager : MBProgressHUD

+(void)showHUDWithMsg:(NSString *)msg superView:(UIView *)superView;

+(void)hideHUDAfter:(NSTimeInterval)delay withMsg:(NSString *)msg;

+(void)toastmessage:(NSString *)msg superView:(UIView *)superView;


@end
