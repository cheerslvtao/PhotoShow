//
//  NumberPickerView.h
//  PhotoShow
//
//  Created by SFC-a on 2017/7/25.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NumberPickerView : UIView <UITextFieldDelegate>

@property (nonatomic,retain) UITextField * numberTextField;

@property (nonatomic,copy) void (^numberChanged)(NSString * number);

@end
