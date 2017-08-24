//
//  HUDManager.m
//  PhotoShow
//
//  Created by SFC-a on 2017/8/3.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "HUDManager.h"
#import <objc/runtime.h>
@implementation HUDManager

+(void)showHUDWithMsg:(NSString *)msg superView:(UIView *)superView{
    MBProgressHUD * hud = [self showHUDAddedTo:superView animated:YES];
    hud.detailsLabel.text = msg;
    NSLog(@"%@",hud);
    objc_setAssociatedObject(self, @"hud", hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+(void)hideHUDAfter:(NSTimeInterval)delay withMsg:(NSString *)msg {
    MBProgressHUD * hud = objc_getAssociatedObject(self, @"hud");
    NSLog(@"%@",hud);
    hud.detailsLabel.text = msg;
    [hud hideAnimated:YES afterDelay:delay];
}

+(void)toastmessage:(NSString *)msg superView:(UIView *)superView{

    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(20, SCREEN_HEIGHT-100-40, SCREEN_WIDTH-40, 40)];
    label.text = msg;
    label.backgroundColor = [UIColor blackColor];
    label.textColor = [UIColor whiteColor];
    label.clipsToBounds = YES;
    label.layer.cornerRadius = 10;
    label.textAlignment = NSTextAlignmentCenter;
    NSLog(@"%@",superView);
    if (superView){
        [superView addSubview:label];
        [UIView animateWithDuration:0.8 delay:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            label.alpha = 0;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }
   
}

@end
