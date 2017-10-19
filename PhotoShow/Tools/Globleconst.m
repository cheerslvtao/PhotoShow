//
//  Globleconst.m
//  PhotoShow
//
//  Created by SFC-a on 2017/7/12.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "Globleconst.h"

@implementation Globleconst

NSString * const APPSchemes = @"photoshow";

#pragma mark - 第三方key
/** 友盟 */
NSString * const UMAppKey = @"596639a9b27b0a236b001b9e";
/** QQ QQ空间 */
NSString * const QQAppKey = @"";
NSString * const QzoneAppKey = @"";
/** 微信 */
NSString * const WechatAppKey = @"wxae7c3cd416b7fbc5";
NSString * const WechatAppSecret = @"343e69eaf745f66432bfcb5873a55ca6";

/** 支付宝 */
NSString * const AlipayAppkey =@"2017080107985594";


/** 极光推送 */
NSString * const JPushKey = @"115992f78a81b3aee60612fb";

//http://123.56.222.110:8080
//http://60.205.113.35:8080
//1n588801d6.iok.la:19191
//NSString * const baseAPI = @"http://1n588801d6.iok.la:19191";

NSString * const baseAPI = @"http://60.205.113.35:8080";

/** 登录注册相关 */
NSString * const url_login = @"/api/login";
NSString * const url_token = @"/oauth/token";
NSString * const url_register = @"/api/register";
NSString * const url_sendSms = @"/api/sms/send";
NSString * const url_userinfo = @"/api/info";
NSString * const url_updateInfoPhoto = @"/api/updateInfoPhoto";
NSString * const url_updateInfo = @"/api/updateInfo";
NSString * const url_updatePassword = @"/api/updatePassword";

/** 地址相关 */
NSString * const url_addressAll = @"/api/findAddressAll";
NSString * const url_saveAddress = @"/api/saveAddress";
NSString * const url_updateIsidefaultAddress = @"/api/updateIsidefaultAddress";
NSString * const url_updateAddress = @"/api/updateAddress";
NSString * const url_delAddress = @"/api/delAddress";

/** 相册相关 */
NSString * const url_findTemplate = @"/api/findTemplate";
NSString * const url_getPhotos = @"/api/getPhotos";
NSString * const url_createAlbums = @"/api/createAlbums";
NSString * const url_getAlbums = @"/api/getAlbums";
NSString * const url_delAlbums = @"/api/delAlbums";
NSString * const url_findFiles = @"/api/findFiles";
NSString * const url_uploadFile = @"/api/uploadFile";
NSString * const url_delFile = @"/api/delFile";
NSString * const url_getPhonesByAlbums =  @"/api/getPhonesByAlbums";
NSString * const url_updateAlbumsPhotoFile = @"/api/updateAlbumsPhotoFile";
NSString * const url_printAlbum = @"/api/printAlbum";
NSString * const url_createOrder = @"/api/createOrder";
NSString * const url_getOrders = @"/api/getOrders";
NSString * const url_getOrder = @"/api/getOrder";
NSString * const url_subOrders = @"/api/subOrders";
NSString * const url_delOrders = @"/api/delOrders";

/** 支付成功通知后台 */
NSString * const url_alipay_notify = @"/notify/aliPay_notify";

/** 生活日记 */
NSString * const url_createDiaryPhoto = @"/api/createDiaryPhoto"; //带照片
NSString * const url_createDiary = @"/api/createDiary"; //不带照片
NSString * const url_getDiarys = @"/api/getDiarys"; //查询日记本

/** 钱包相关 */
NSString * const url_myMoney =@"/api/myMoney";
NSString * const url_myCredit =@"/api/myCredit";
NSString * const url_userCache = @"/api/userCache";

/** 上传照片 */
NSString * const url_uploadImage =@"/api/uploadImage";

/** 分享 */
NSString * const url_myShare = @"/api/myShare";

NSString * const image_placeholder = @"placeholderImg";


NSString * const key_userinfo = @"userinfo";

@end
