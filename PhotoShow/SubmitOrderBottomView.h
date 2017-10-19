//
//  SubmitOrderBottomView.h
//  PhotoShow
//
//  Created by SFC-a on 2017/7/25.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SubmitOrderDelegate <NSObject>

-(void)submitOrder;

@end

@interface SubmitOrderBottomView : UIView

@property (nonatomic,retain) UILabel * orderPriceLabel;

@property (nonatomic,retain) UIButton * submitButton;

@property (nonatomic,weak) id<SubmitOrderDelegate> delegate;

/** 是否只显示一个按钮  
 YES显示一个按钮
 NO显示一个Label 一个按钮 
*/
@property (nonatomic) BOOL isOneView;

@end
