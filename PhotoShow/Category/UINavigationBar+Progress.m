//
//  UINavigationBar+Progress.m
//  SFCProduct
//
//  Created by SFC-赵灿 on 2017/6/1.
//  Copyright © 2017年 SFC. All rights reserved.
//

#import "UINavigationBar+Progress.h"
#import <objc/runtime.h>

@implementation UINavigationBar (Progress)

- (void)setProgressView:(UIProgressView *)progressView {
    return objc_setAssociatedObject(self, @selector(progressView), progressView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIProgressView *)progressView {
    return objc_getAssociatedObject(self, _cmd);
}


- (void)showProgess {
    
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 42, SCREEN_WIDTH, 2)];
    self.progressView.progressTintColor = [UIColor whiteColor];
    self.progressView.trackTintColor = [UIColor clearColor];
    
    [self addSubview:self.progressView];
}

@end
