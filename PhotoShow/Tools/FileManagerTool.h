//suffix
//  FileManagerTool.h
//  PhotoShow
//
//  Created by SFC-a on 2017/7/28.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 
    文件格式
        word  ---  .doc .docx
        excle
 */

@interface FileManagerTool : NSObject

+(NSArray *)getFileFromDevice;

@end



@interface FileModel : NSObject

@property (nonatomic,retain) NSString * fileName;
@property (nonatomic,retain) NSString * imgName;
@property (nonatomic,retain) NSString * filePath;
@property (nonatomic,retain) NSString * fileSuffix;

@end

