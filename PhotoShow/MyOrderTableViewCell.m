//
//  MyOrderTableViewCell.m
//  PhotoShow
//
//  Created by SFC-a on 2017/7/21.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "MyOrderTableViewCell.h"

@implementation MyOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



-(void)setOrderModel:(OrderListModel *)orderModel{
    _orderModel = orderModel;
    self.orderCode.text = [NSString stringWithFormat:@"订单号:%@",orderModel.orderNo];
//    订单状态 先不做
//    self.orderStatus.text = [NSString stringWithFormat:@"%@"];
    self.AlbumName.text = orderModel.goodsName;
    
    self.albumType.text = [NSString stringWithFormat:@"相册类型：%@",[CommonTool getAlbumType:orderModel.goodsType]];
    self.albumNumber.text = [NSString stringWithFormat:@"制作数量：%@",orderModel.quantity];
    self.createTime.text = [CommonTool dateStringFromData:[orderModel.addTime longLongValue]];
    self.orderPrice.text = [NSString stringWithFormat:@"￥%@",orderModel.price];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
