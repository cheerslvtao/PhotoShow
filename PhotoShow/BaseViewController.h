//
//  BaseViewController.h
//  PhotoShow
//
//  Created by SFC-a on 2017/7/17.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 点击导航按钮回调 */
typedef void(^leftNavigationItemCilck)();
typedef void(^rightNavigationItemCilck)();

@interface BaseViewController : UIViewController

/** 点击导航按钮回调 */
@property (nonatomic,copy) leftNavigationItemCilck leftNavBlock;
@property (nonatomic,copy) leftNavigationItemCilck rightNavBlock;


/** 设置导航栏  左右按钮 */

-(void)setNavigationBarRightItem:(NSString * )itemTitle itemImg:(UIImage *)itemImg currentNavBar:(UINavigationItem *)baritem curentViewController:(UIViewController *)currentVC;

-(void)setNavigationBarLeftItem:(NSString * )itemTitle itemImg:(UIImage *)itemImg currentNavBar:(UINavigationItem *)baritem curentViewController:(UIViewController *)currentVC;

@end
