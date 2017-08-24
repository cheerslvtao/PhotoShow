//
//  PhotoShowListViewController.h
//  PhotoShow
//
//  Created by SFC-a on 2017/7/22.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSUInteger {
    Fee,
    LifeAlbum,
    travelAlbum,
    growupAlbum,
    documentAlbum
} albumType;

@interface PhotoShowListViewController : BaseViewController

/** 相册类型 */
@property (nonatomic) albumType albumtype;

@end
