//
//  Globleconst.h
//  PhotoShow
//
//  Created by SFC-a on 2017/7/12.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Globleconst : NSObject

extern NSString * const APPSchemes ;

#pragma mark - 第三方key
/** 友盟 */
extern NSString * const UMAppKey;
/** QQ QQ空间 */
extern NSString * const QQAppKey;
extern NSString * const QzoneAppKey;
/** 微信 */
extern NSString * const WechatAppKey;
extern NSString * const WechatAppSecret;
/** 支付宝 */
extern NSString * const AlipayAppkey;

/** 极光推动 */
extern NSString * const JPushKey;


#pragma mark -- URL 开始
/** 域名 */
extern NSString * const baseAPI;

/** 登录注册相关 */
extern NSString * const url_login;
extern NSString * const url_token;
extern NSString * const url_register;
extern NSString * const url_sendSms ;
extern NSString * const url_userinfo;
extern NSString * const url_updateInfoPhoto;
extern NSString * const url_updateInfo;
extern NSString * const url_updatePassword;

/** 地址相关 */
extern NSString * const url_addressAll;
extern NSString * const url_saveAddress;
extern NSString * const url_updateIsidefaultAddress;
extern NSString * const url_updateAddress;
extern NSString * const url_delAddress;

/** 相册相关 */
extern NSString * const url_findTemplate;
extern NSString * const url_getPhotos;
extern NSString * const url_createAlbums;
extern NSString * const url_getAlbums;
extern NSString * const url_delAlbums;
extern NSString * const url_findFiles;
extern NSString * const url_uploadFile;
extern NSString * const url_delFile;
extern NSString * const url_getPhonesByAlbums; 
extern NSString * const url_updateAlbumsPhotoFile;
extern NSString * const url_printAlbum;
extern NSString * const url_createOrder;
extern NSString * const url_getOrders;
extern NSString * const url_getOrder;
extern NSString * const url_subOrders;
extern NSString * const url_delOrders;

/** 支付成功通知后台 */
extern NSString * const url_alipay_notify;

/** 生活日记 */
extern NSString * const url_createDiaryPhoto; //带照片
extern NSString * const url_createDiary; //不带照片
extern NSString * const url_getDiarys; //查询日记本


/** 钱包相关 */
extern NSString * const url_myMoney;
extern NSString * const url_myCredit;
extern NSString * const url_userCache;

/** 上传照片 */
extern NSString * const url_uploadImage ;

extern NSString * const url_myShare;

#pragma mark -- URL 结束

/** 其他 */
extern NSString * const image_placeholder;


/** key */
extern NSString * const key_userinfo;

@end
