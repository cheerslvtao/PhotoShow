//
//  PaymentTableViewCell.h
//  PhotoShow
//
//  Created by SFC-a on 2017/7/24.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *payment_icon;
@property (weak, nonatomic) IBOutlet UILabel *payment_title;
@property (weak, nonatomic) IBOutlet UIButton *payment_rightlogo;

@end
