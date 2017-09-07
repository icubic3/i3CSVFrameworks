//
//  NSData+i3CSVModelConverter.h
//  i3CSVFrameworks
//
//  Created by i3 on 2017/5/4.
//  Copyright © 2017年 i3. All rights reserved.
//

#import <Foundation/Foundation.h>
@class i3CSVModel;

@interface NSData (i3CSVModelConverter)


/**
 把模型转换成NSData

 @param model csv模型
 @return 转换后的NSData
 */
+ (nonnull NSData *)dataWithi3CSVModel:(nonnull i3CSVModel *)model;

@end
