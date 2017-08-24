//
//  AddNewAlbumViewModel.m
//  PhotoShow
//
//  Created by SFC-a on 2017/8/7.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "AddNewAlbumViewModel.h"

@implementation AddNewAlbumViewModel

+(void)getTemplateListWithType:(NSString *)type temlateContainer:(UIScrollView *)container Block:(void (^)(NSArray<TemplateModel *> *))block{
    [HTTPTool postWithPath:url_findTemplate params:@{@"type":type} success:^(id json) {
        if ([json[@"code"] integerValue] == 200 && [json[@"success"] integerValue] == 1) {
            NSMutableArray * modelArr = [[NSMutableArray alloc]init];
            for (UIView * subview in container.subviews) {
                [subview removeFromSuperview];
            }
            container.contentSize = CGSizeMake([json[@"data"][@"list"] count] * ((SCREEN_WIDTH-60)/2+15), 111);
            int i = 0;
            UIImageView * firstImgV = [[UIImageView alloc]init];
            for (NSDictionary * dic in json[@"data"][@"list"]) {
                TemplateModel * model = [[TemplateModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                
                UIImageView * imageview = [[UIImageView alloc]initWithFrame:CGRectMake(20+i*(SCREEN_WIDTH-60+40)/2, 0, (SCREEN_WIDTH-60)/2, 111)];
                imageview.userInteractionEnabled = YES;
                if(i==0){
                    imageview.layer.borderColor = RGBA(123, 197, 36, 1).CGColor;
                    imageview.layer.borderWidth = 3;
                    UIImageView * selectedImageView = [[UIImageView alloc]init];
                    selectedImageView.image = [UIImage imageNamed:@"photo_selected"];
                    [imageview addSubview:selectedImageView];
                    [selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.bottom.offset(-2);
                        make.width.mas_equalTo(30);
                        make.height.mas_equalTo(30);
                    }];
                    firstImgV = imageview;
                }
                model.selectedImageView = imageview;
                [modelArr addObject:model];
                i++;
                [imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseAPI,dic[@"imgUrl"]]] placeholderImage:[UIImage imageNamed:image_placeholder]];
                UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectTemplate:)];
                [imageview addGestureRecognizer:tap];
                [container addSubview:imageview];
            }
            block(modelArr);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"templateChanged" object:firstImgV];

        }else{
            
        }
    } failure:^(NSError *error) {
        
    }];
}

+(void)getUserAllPhotosWithParameters:(NSDictionary *)params block:(void (^)(NSArray<PhotosModel *> *))block failure:(void (^)(NSError *))faile{
    [HTTPTool postWithPath:url_getPhotos params:params success:^(id json) {
        if ([json[@"code"] integerValue] == 200 && [json[@"success"] integerValue] == 1) {
            NSMutableArray * modelArr = [[NSMutableArray alloc]init];
            for (NSDictionary * dic in json[@"data"][@"photoList"]) {
                PhotosModel * model = [[PhotosModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                model.isSelected = NO;
                [modelArr addObject:model];
            }
            block(modelArr);
        }else{
            block(@[]);
        }
    } failure:^(NSError *error) {
        faile(error);
    }];
}

+(void)selectTemplate:(UITapGestureRecognizer *)tap{
    NSLog(@"%@",tap);
    NSArray * superViews = tap.view.superview.subviews;
    UIImageView *  selectedImageView = nil;
    for (UIView * subview in superViews) {
        if (subview.subviews.count > 0) {
            selectedImageView = subview.subviews[0] ;
            subview.layer.borderWidth = 0;
            break;
        }
    }
    tap.view.layer.borderColor = RGBA(123, 197, 36, 1).CGColor;
    tap.view.layer.borderWidth = 3;
    [tap.view addSubview:selectedImageView];
    [selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.offset(-2);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"templateChanged" object:tap.view];
}

@end
