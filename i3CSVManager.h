//
//  i3CSVManager.h
//  i3CSVFrameworks
//
//  Created by i3 on 2017/4/28.
//  Copyright © 2017年 i3. All rights reserved.
//

#import <Foundation/Foundation.h>

@class i3CSVModel;

@interface i3CSVManager : NSObject

//存储CSV文件的路径。默认路径为/Document/CSVFiles，可以自行设置路径
@property (nonatomic, strong) NSString *pathForCSVFiles;

//获得单例对象
+ (instancetype)shareManager;

#pragma mark - 创建模型

- (i3CSVModel *)creatCSVModel;

#pragma mark - 获得模型的方法
/**
 获得于默认路径下该名字的csv模型对象。默认路径为Document文件夹下的/CSVFiles文件夹

 @param name 字符串格式的csv表格名字
 @return 模型对象
 */
- (i3CSVModel *)getCSVModelInDefaultPathWithName:(NSString *)name;


/**
 根据传入的路径和csv文件的名字获得转换后的模型对象。路径例子:
 [NSString stringWithFormat:@"%@/file",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]];

 @param path csv文件所在路径
 @param name csv文件名字
 @return 转换后的对象
 */
- (i3CSVModel *)getCSVModelInPath:(NSString *)path withName:(NSString *)name;



#pragma mark - 保存模型为csv文件
/**
 把模型以csv文件保存到默认路径。存在相同名字的情况下会直接覆盖掉同名的csv文件。

 @param model 需要保存的模型
 @param name csv文件的名字
 */
- (void)saveCSVFile:(i3CSVModel *)model inDefaultPathWithName:(NSString *)name;


/**
 把模型以csv文件保存到特定路径。存在相同名字的情况下会直接覆盖掉同名的csv文件。

 @param model 需要保存的模型
 @param path 指定路径
 @param name csv文件的名字
 */
- (void)saveCSVFile:(i3CSVModel *)model withPath:(NSString *)path andName:(NSString *)name;



#pragma mark - 清除缓存

/**
 清除默认路径下所有的csv文件
 */
- (void)removeAllCSVFileInDefaultPath;


/**
 清除默认路径下的某个csv文件

 @param name 需要清除的csv文件名
 */
- (void)removeCSVFileWithName:(NSString *)name;

@end
