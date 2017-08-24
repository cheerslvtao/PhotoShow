//
//  HeaderImageUpload.h
//  SFCProduct
//
//  Created by SFC-赵灿 on 2017/5/31.
//  Copyright © 2017年 SFC. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, ImageType) {
    ImageTypeUnknow = 0,
    ImageTypeJPEG,
    ImageTypeJPEG2000,
    ImageTypeTIFF,
    ImageTypeBMP,
    ImageTypeICO,
    ImageTypeICNS,
    ImageTypeGIF,
    ImageTypePNG,
    ImageTypeWebP,
    ImageTypeOther,
};

CG_EXTERN ImageType ImageDetectType(CFDataRef data);

@interface ImageManager : NSObject

@property (nonatomic, retain) UIViewController *aViewController;

- (void)selectedImage:(UIViewController *)viewController;

- (void)getImgWithIndex:(NSInteger)index;

@property (nonatomic, copy) void (^ruternImage)(UIImage *);

@end
