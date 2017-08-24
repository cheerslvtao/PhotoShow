//
//  FilterOrderView.h
//  PhotoShow
//
//  Created by SFC-a on 2017/8/5.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FilterDelegate <NSObject>

-(void)filterOrderWith:(NSDictionary * )filterParameter;

@end

@interface FilterOrderView : UIView<UITextFieldDelegate>

/** 筛选订单 */

@property (nonatomic,retain) UIImageView * selectedFlagImgV;
@property (nonatomic,retain) UIImageView * selectedFlagImgVType;

@property (nonatomic,retain) UIButton * beforeBtn;

@property (nonatomic,retain) UIButton * typeBeforeBtn;

@property (nonatomic,retain) UITextField * searchtextField;

@property (nonatomic,retain) NSMutableDictionary * filterParameters;

@property (nonatomic,weak) id<FilterDelegate> delegate;

@end
