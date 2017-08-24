//
//  AddressTableViewCell.m
//  PhotoShow
//
//  Created by SFC-a on 2017/7/21.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "AddressTableViewCell.h"

@implementation AddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.fixedButton.layer.borderColor = RGBA(192, 225, 198, 1).CGColor;
    self.fixedButton.layer.borderWidth = 1;
    self.fixedButton.layer.cornerRadius = 5;
    self.deleteButton.layer.borderColor = RGBA(192, 225, 198, 1).CGColor;
    self.deleteButton.layer.borderWidth = 1;
    self.deleteButton.layer.cornerRadius = 5;
}
- (IBAction)defaultAddress:(UIButton *)sender {
    NSInteger idx = sender.tag - 74526;
    NSLog(@"%@",self.modelArr);
    [HTTPTool postWithPath:url_updateIsidefaultAddress params:@{@"is_default":sender.selected?@"0":@"1",@"id":[self.modelArr[idx] addressId]} success:^(id json) {
        if ([json[@"code"] integerValue] == 200 && [json[@"success"] integerValue] == 1) {
            sender.selected = !sender.selected;
            if (_delegate && [_delegate respondsToSelector:@selector(tableviewReloadData)]) {
                [_delegate tableviewReloadData];
            }

        }
    } failure:^(NSError *error) {
        
    } alertMsg:@"修改中..." successMsg:@"修改成功..." failMsg:@"修改失败" showView:[self superview]];
}

- (IBAction)fixedAddress:(id)sender {
    UIButton * btn = sender;
    AddressModel * model = self.modelArr[btn.tag - 5448];
    if (_delegate && [_delegate respondsToSelector:@selector(fixedAddress:)]) {
        [_delegate fixedAddressInfo:model];
    }
}

- (IBAction)deleteAddress:(id)sender {
    UIButton * btn = sender;
    AddressModel * model = self.modelArr[btn.tag - 675843];
    if (_delegate && [_delegate respondsToSelector:@selector(deleteAddress:)]) {
        [_delegate deleteAddress:model.addressId];
    }

}

-(void)setModel:(AddressModel *)model{
    _model = model;
    self.userNameAndPhoneNum.text = [NSString stringWithFormat:@"%@    %@",model.name,model.phone];
    self.userAddressInfo.text = model.address;
    if([model.isDefault intValue] == 1){
        self.defaultAddress.selected = YES;
    }else{
        self.defaultAddress.selected = NO;
    }
    
}


-(NSArray *)modelArr{
    if (!_modelArr) {
        _modelArr = [[NSArray alloc]init];
    }
    return _modelArr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
