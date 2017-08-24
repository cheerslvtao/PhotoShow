//
//  EditingTableViewCell.h
//  PhotoShow
//
//  Created by SFC-a on 2017/7/26.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *leftlogoImgView;
@property (weak, nonatomic) IBOutlet UIImageView *rightlogoImgView;

@property (weak, nonatomic) IBOutlet UITextField *editingcontent;
@end
