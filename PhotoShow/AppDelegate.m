//
//  AppDelegate.m
//  PhotoShow
//
//  Created by SFC-a on 2017/7/12.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"
#import "UMManager.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import <IQKeyboardManager.h>
@interface AppDelegate ()<WXApiDelegate,JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    [WXApi registerApp:WechatAppKey];
    [UMManager initUM];
    [self initJPushWithOptions:launchOptions];
    [self configNavStyle];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;

    return YES;
}


#pragma mark - 设置导航风格
-(void)configNavStyle{
    //设置导航背景图片
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_bg.jpg"] forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setBackgroundColor:RGBA(122, 198, 38, 1)];
    //设置导航字体颜色
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    //[[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
}


#pragma mark - 极光推送
-(void)initJPushWithOptions:(NSDictionary *)launchOptions {
    //初始化 APNs
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    //初始化 JPush
    [JPUSHService setupWithOption:launchOptions appKey:JPushKey
                          channel:@"App Store"
                 apsForProduction:0
            advertisingIdentifier:nil];
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    //注册 device Token
    NSLog(@"deviceToken --- %@",deviceToken);
    [JPUSHService registerDeviceToken:deviceToken];
}

/** 推送回调  */
//ios 7
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler{
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

//ios 10
-(void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}
//ios 10
-(void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark -  设置系统回调
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result){
        result = [WXApi handleOpenURL:url delegate:self];
    }
    return result;
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
        result = [WXApi handleOpenURL:url delegate:self];
    }
    return result;
}



#pragma mark - 微信API代理 WXApiDelegate

-(void)onReq:(BaseReq *)req{
    
}

-(void)onResp:(BaseResp *)resp{
    
}



@end
