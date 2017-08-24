//
//  PhotoCollectionView.m
//  PhotoShow
//
//  Created by SFC-a on 2017/7/26.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "PhotoCollectionView.h"
#import "PhotosModel.h"
#import "PhotosCollectionViewCell.h"

@implementation PhotoCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createUI:frame];
    }
    return self;
}

-(void)createUI:(CGRect)frame{
    UICollectionViewFlowLayout * flow = [[UICollectionViewFlowLayout alloc]init];
    flow.itemSize = CGSizeMake(60, 60);
    flow.minimumLineSpacing = 3; //横向间距
    flow.minimumInteritemSpacing = 0;//纵向间距
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.photoCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flow];
    self.photoCollectionView.delegate = self;
    self.photoCollectionView.dataSource =self;
    self.photoCollectionView.showsHorizontalScrollIndicator = NO;
    [self.photoCollectionView registerNib:[UINib nibWithNibName:@"PhotosCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"photoCollectionViewCell"];
    self.photoCollectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.photoCollectionView];
    
    [self.photoCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(40);
        make.right.offset(-40);
        make.top.offset(20);
        make.bottom.offset(-10);
    }];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setImage:[UIImage imageNamed:@"left_arrow"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backPhoto) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.backButton];
    
    self.forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.forwardButton setImage:[UIImage imageNamed:@"right_arrow"] forState:UIControlStateNormal];
    [self.forwardButton addTarget:self action:@selector(forwardPhoto) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.forwardButton];

    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
        make.centerY.equalTo(self.mas_centerY).offset(5);
    }];
    [self.forwardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
        make.centerY.equalTo(self.mas_centerY).offset(5);
    }];
    
    UIView * lineView = [[UIView alloc]init];
    lineView.backgroundColor = THEMEBGCOLOR;
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(10);
    }];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photoArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotosCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCollectionViewCell" forIndexPath:indexPath];
    if (self.photoArray.count > 0) {
        NSDictionary * dic = self.photoArray[indexPath.row];
        [cell.photoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseAPI,dic[@"photoUrl"]]] placeholderImage:[UIImage imageNamed:image_placeholder]];


    }
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",self.photoArray[indexPath.item]);
    self.block(self.photoArray[indexPath.item]);
}

-(void)backPhoto{
    NSLog(@"后退");
    if (self.photoCollectionView.contentOffset.x > 0) {
        if (self.photoCollectionView.contentOffset.x < SCREEN_WIDTH) {
            //如果偏移量小于一个屏幕了  直接回0
//                self.photoCollectionView.contentOffset = CGPointMake(0, 0);
            [self.photoCollectionView setContentOffset:CGPointMake(0, 0) animated:YES];
        }else{
            [self.photoCollectionView setContentOffset:CGPointMake(self.photoCollectionView.contentOffset.x - 100, 0) animated:YES];
        }
    }
}

-(void)forwardPhoto{
    NSLog(@"前景");
    if (self.photoCollectionView.contentOffset.x < self.photoCollectionView.contentSize.width - SCREEN_WIDTH) {
        if (self.photoCollectionView.contentOffset.x - SCREEN_WIDTH > self.photoCollectionView.contentSize.width ) {
            [self.photoCollectionView setContentOffset: CGPointMake(self.photoCollectionView.contentSize.width - SCREEN_WIDTH, 0) animated:YES];
            
        }else{
            [self.photoCollectionView setContentOffset:CGPointMake(self.photoCollectionView.contentOffset.x + 100, 0) animated:YES];
        }
    }
}

#pragma mark - 设置相册id的时候 请求照片列表
-(void)setAlbumId:(NSString *)albumId{
    _albumId = albumId;
    
    [HTTPTool postWithPath:url_getPhonesByAlbums params:@{@"albums_id":albumId} success:^(id json) {
        if ([json[@"code"] integerValue] == 200 && [json[@"success"] integerValue] == 1) {
            int i = 0;
            for (NSDictionary * dic in json[@"data"][@"albumList"]) {
                [self.photoArray addObject:dic];
                if (i == 0) {
                    self.block(dic);
                }
                i++;
            }
            [self.photoCollectionView reloadData];

        }
    } failure:^(NSError *error) {
        
    }];
}

-(NSMutableArray *)photoArray{
    if (!_photoArray) {
        _photoArray = [[NSMutableArray alloc]init];
    }
    return _photoArray;
}

@end
