//
//  DocumentTableViewCell.h
//  PhotoShow
//
//  Created by SFC-a on 2017/8/14.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DocumentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *FileTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *FileNameLabel;

@end
