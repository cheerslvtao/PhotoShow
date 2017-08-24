//
//  DocumentModel.m
//  PhotoShow
//
//  Created by SFC-a on 2017/8/7.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "DocumentModel.h"

@implementation DocumentModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if([key isEqualToString:@"id"]){
        self.fileId = value;
    }
}
@end
