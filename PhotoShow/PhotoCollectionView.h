//
//  PhotoCollectionView.h
//  PhotoShow
//
//  Created by SFC-a on 2017/7/26.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^clickPhotoBlock)(NSDictionary * modelDic);
typedef void(^albumIsSubmit)();

@interface PhotoCollectionView : UIView<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic,retain) UICollectionView * photoCollectionView;

@property (nonatomic,retain) NSMutableArray * photoArray;

/** 前进按钮 */
@property (nonatomic,retain) UIButton * forwardButton;

/** 后退按钮 */
@property (nonatomic,retain) UIButton * backButton;

/** 相册id */
@property (nonatomic,retain) NSString * albumId;

/** 点击item回调 */
@property (nonatomic,copy) clickPhotoBlock block;

/** 改相册已经提交订单了 不能再修改 */
@property (nonatomic,copy) albumIsSubmit isSubmitBlock;

@end
