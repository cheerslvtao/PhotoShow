//
//  FileManagerTool.m
//  PhotoShow
//
//  Created by SFC-a on 2017/7/28.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "FileManagerTool.h"

@implementation FileManagerTool


+(NSArray *)getFileFromDevice{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //在这里获取应用程序Documents文件夹里的文件及文件夹列表
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    NSError *error = nil;
    NSArray *fileList = [[NSArray alloc] init];
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    fileList = [fileManager contentsOfDirectoryAtPath:documentDir error:&error];
    NSLog(@"%@",fileList);
    NSMutableArray * dirArray = [[NSMutableArray alloc] init];
    for (NSString *file in fileList)
    {
        FileModel * model = [[FileModel alloc]init];
        model.fileName = [file lastPathComponent];
        model.filePath = [NSString stringWithFormat:@"%@/%@",documentDir,[file lastPathComponent]];
        [dirArray addObject:model];
        NSLog(@"%@",file);
        NSLog(@"%@",[file lastPathComponent]); //文件名
        NSLog(@"%@",[file pathExtension]);//后缀名
    }
    
    return dirArray;
}

@end

@implementation FileModel

@end
