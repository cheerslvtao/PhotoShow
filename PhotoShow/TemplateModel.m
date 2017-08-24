//
//  TemplateModel.m
//  PhotoShow
//
//  Created by SFC-a on 2017/8/7.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "TemplateModel.h"

@implementation TemplateModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if([key isEqualToString:@"id"]){
        self.templateid = value;
    }
}
@end
