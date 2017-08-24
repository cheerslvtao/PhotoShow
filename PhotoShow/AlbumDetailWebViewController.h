//
//  AlbumDetailWebViewController.h
//  PhotoShow
//
//  Created by SFC-a on 2017/7/22.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>
#import "FileManagerTool.h"
#import "AlbumModel.h"

@interface AlbumDetailWebViewController : BaseViewController

@property (nonatomic) BOOL isShare;

@property (nonatomic,retain) NSString * filePath;

@property (nonatomic,retain) FileModel * model;

@property (nonatomic,retain) AlbumModel * albumModel;

@end
