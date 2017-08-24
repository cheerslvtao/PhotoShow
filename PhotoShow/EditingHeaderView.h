//
//  EditingHeaderView.h
//  PhotoShow
//
//  Created by SFC-a on 2017/7/26.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditingHeaderView : UIView

/** 图片 */
@property (nonatomic,retain) UIImageView * photoview;

/** 重新选择 */
@property (nonatomic,retain) UIButton * selectPhotoAgainBtn;

/** 重新拍照 */
@property (nonatomic,retain) UIButton * cameraAgainBtn;


@end
