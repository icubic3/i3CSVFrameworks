//
//  i3CSVModel.h
//  i3CSVFrameworks
//
//  Created by i3 on 2017/5/3.
//  Copyright © 2017年 i3. All rights reserved.
//

#import <Foundation/Foundation.h>

//CSVPosition结构体
struct CSVPosition {
    NSUInteger x;
    NSUInteger y;
};
typedef struct CSVPosition CSVPosition;

//制作CSVPosition的C函数
static inline CSVPosition
CSVPositionMake(NSUInteger x, NSUInteger y)
{
    CSVPosition p; p.x = x; p.y = y; return p;
}


@interface i3CSVModel : NSObject

//行数
@property (nonatomic, readonly, assign)NSUInteger numberOfRow;
//列数
@property (nonatomic, readonly, assign)NSUInteger numberOfColumn;


/**
 把某个csv文件转换为模型

 @param path 文件路径
 @return 模型对象
 */
- (instancetype)initWithPath:(NSString *)path;


/**
 把NSData转换成模型

 @param data 需要转换的NSData
 @return 模型对象
 */
- (instancetype)initWithData:(NSData *)data;


/**
 把字符串写入某个位置

 @param data 写入的内容
 @param position 写入的位置（参考CSVPosition结构体）
 */
- (void)writeData:(NSString *)data atPosition:(CSVPosition)position;


//获得第index行的数据,返回字符串数组
- (NSArray<NSString*> *)getRowAtIndex:(NSUInteger)index;

//获得index列的数据，返回字符串数组
- (NSArray<NSString*> *)getColumnAtIndex:(NSUInteger)index;

//获得某个位置的数据，返回字符串
- (NSString *)getDataAtCSVPostion:(CSVPosition)position;


/**
 保存模型的改动
 */
- (void)saveModel;


/**
 支持以链式调用的形式来对某个位置进行读写
 例：
    model.writeData(@"hello").at.position;
    model.readData.at.position;
 */
- (i3CSVModel *(^)(NSString *str))writeData;
- (i3CSVModel *)readData;
- (i3CSVModel *)at;
- (id (^)(CSVPosition p))position;

@end
