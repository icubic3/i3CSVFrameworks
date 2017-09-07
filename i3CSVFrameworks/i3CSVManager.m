//
//  i3CSVManager.m
//  i3CSVFrameworks
//
//  Created by i3 on 2017/4/28.
//  Copyright © 2017年 i3. All rights reserved.
//

#import "i3CSVManager.h"
#import "i3CSVModel.h"
#import <objc/message.h>

@interface i3CSVManager()

@property (nonatomic, strong) NSFileManager *fileManager;

@end

@implementation i3CSVManager

static i3CSVManager * _instance = nil;

- (NSFileManager *)fileManager{
    if (!_fileManager) {
        _fileManager = [NSFileManager defaultManager];
    }
    return _fileManager;
}

- (NSString *)pathForCSVFiles{
    if (!_pathForCSVFiles) {
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        _pathForCSVFiles = [NSString stringWithFormat:@"%@/CSVFiles",docPath];
        if (![self.fileManager fileExistsAtPath:_pathForCSVFiles]) {
            [self.fileManager createDirectoryAtPath:_pathForCSVFiles withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    return _pathForCSVFiles;
}

+ (instancetype)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[[self class] alloc] init];
    });
    return _instance;
}

#pragma mark - 获得csv文件
- (i3CSVModel *)creatCSVModel{
    return [[i3CSVModel alloc]initWithPath:nil];
}

- (i3CSVModel *)getCSVModelInDefaultPathWithName:(NSString *)name{
    return [self getCSVModelInPath:self.pathForCSVFiles withName:name];
}

- (i3CSVModel *)getCSVModelInPath:(NSString *)path withName:(NSString *)name{
    if (![self CSVFileExistInPath:path withName:name]) {
        NSLog(@"CSV文件不存在！");
        return nil;
    }
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.csv",path,name];
    
    i3CSVModel *model = [[i3CSVModel alloc]initWithPath:filePath];
    return model;
}

- (BOOL)CSVFileExistInPath:(NSString *)path withName:(NSString *)name{
    NSString *tmpPath = [NSString stringWithFormat:@"%@/%@.csv",path,name];
    return [self.fileManager fileExistsAtPath:tmpPath];
}

#pragma mark - 保存csv文件
- (void)saveCSVFile:(i3CSVModel *)model inDefaultPathWithName:(NSString *)name{
    [self saveCSVFile:model withPath:self.pathForCSVFiles andName:name];
}


- (void)saveCSVFile:(i3CSVModel *)model
           withPath:(NSString *)path
            andName:(NSString *)name{
    [model saveModel];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.csv",path,name];
    [self.fileManager removeItemAtPath:filePath error:nil];
    NSOutputStream *output = [[NSOutputStream alloc] initToFileAtPath:filePath append:YES];
    [output open];
    
    if (![output hasSpaceAvailable]) {
        NSLog(@"没有足够可用空间");
    } else {
        const uint8_t *data = (const uint8_t *)[objc_msgSend(model,sel_registerName("csvData")) cStringUsingEncoding:NSUTF8StringEncoding];
        NSUInteger dataLengh = [objc_msgSend(model,sel_registerName("csvData")) lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        if ([output write:data maxLength:dataLengh] <= 0) {
            NSLog(@"写入失败！");
        }
    }
        
    [output close];
}

#pragma mark - 删除
- (void)removeAllCSVFileInDefaultPath{
    [self.fileManager removeItemAtPath:self.pathForCSVFiles error:nil];
}

- (void)removeCSVFileWithName:(NSString *)name{
    [self.fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@.csv",self.pathForCSVFiles,name] error:nil];
}


@end
