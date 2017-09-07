//
//  NSData+i3CSVModelConverter.m
//  i3CSVFrameworks
//
//  Created by i3 on 2017/5/4.
//  Copyright © 2017年 i3. All rights reserved.
//

#import "NSData+i3CSVModelConverter.h"
#import <objc/message.h>
#import "i3CSVModel.h"

@implementation NSData (i3CSVModelConverter)

+ (NSData *)dataWithi3CSVModel:(nonnull i3CSVModel *)model{
    NSString *tmp = objc_msgSend(model, sel_registerName("csvData"));
    return [tmp dataUsingEncoding:NSUTF8StringEncoding];
}

@end
