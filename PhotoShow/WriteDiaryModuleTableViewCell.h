//
//  WriteDiaryModuleTableViewCell.h
//  PhotoShow
//
//  Created by SFC-a on 2017/8/31.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WriteDiaryModuleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *textTop;
@property (weak, nonatomic) IBOutlet UIButton *textDown;


@property (nonatomic,retain) UIImageView * selectedImageView ;
@end
