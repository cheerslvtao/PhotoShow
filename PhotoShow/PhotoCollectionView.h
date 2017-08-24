//
//  PhotoCollectionView.h
//  PhotoShow
//
//  Created by SFC-a on 2017/7/26.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^clickPhotoBlock)(NSDictionary * modelDic);

@interface PhotoCollectionView : UIView<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic,retain) UICollectionView * photoCollectionView;

@property (nonatomic,retain) NSMutableArray * photoArray;

/** 前进按钮 */
@property (nonatomic,retain) UIButton * forwardButton;

/** 后退按钮 */
@property (nonatomic,retain) UIButton * backButton;

/** 相册id */
@property (nonatomic,retain) NSString * albumId;

@property (nonatomic,copy) clickPhotoBlock block;


@end
