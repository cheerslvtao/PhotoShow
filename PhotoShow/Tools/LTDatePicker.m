//
//  LTDatePicker.m
//  PickViewDemo
//
//  Created by 吕涛 on 16/8/5.
//  Copyright © 2016年 吕涛. All rights reserved.
//

#import "LTDatePicker.h"


@implementation LTDatePicker

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
        self.backgroundColor = [UIColor colorWithRed:244/255.0 green:245/255.0 blue:247/255.0 alpha:1];
    }
    return self;
}

-(void)createUI{
    for (int i=0; i < 2; i++){
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i==0) {
            btn.frame = CGRectMake(10, 0, 60, 40);
            [btn setTitle:@"取消" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(cancelSelect) forControlEvents:UIControlEventTouchUpInside];
        }else{
            btn.frame = CGRectMake(self.bounds.size.width - 70, 0, 60, 40);
            [btn setTitle:@"确定" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(sureSelect) forControlEvents:UIControlEventTouchUpInside];
        }
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:btn];
    }
    
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 40, self.bounds.size.width, self.bounds.size.height - 40)];
    self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    
    [self addSubview:self.datePicker];
}

-(void)cancelSelect{
    self.returnBlock(@"");
}

-(void)sureSelect{
    NSLog(@"%@",self.datePicker.date);

    self.returnBlock([self stringFromDate:self.datePicker.date]);
}


+(NSDate*) convertDateFromString:(NSString*)uiDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}



//输入的日期字符串形如：@"1992-05-21 13:08:08"

- (NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
    
}



- (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
    
}

@end
