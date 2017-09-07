//
//  i3CSVModel.m
//  i3CSVFrameworks
//
//  Created by i3 on 2017/5/3.
//  Copyright © 2017年 i3. All rights reserved.
//

#import "i3CSVModel.h"

typedef NS_ENUM(NSInteger,modelReadWriteType){
    CSVMODEL_READ,
    CSVMODEL_WRITE,
};

@interface i3CSVModel()

@property (nonatomic, strong)NSMutableString *csvData;
//@property (nonatomic, strong)NSArray *allRow;

@property (nonatomic, strong)NSString *writtenData;
@property (nonatomic, assign)modelReadWriteType type;

@property (nonatomic, strong)NSMutableArray *allDataArray;

@end

@implementation i3CSVModel

@synthesize numberOfColumn = _numberOfColumn;

- (instancetype)initWithPath:(NSString *)path{
    if (!self) {
        self = [super init];
    }
    self.csvData = [[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil] mutableCopy];
    return self;
}

- (instancetype)initWithData:(NSData *)data{
    if (!self) {
        self = [super init];
    }
    self.csvData = [[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] mutableCopy];
    return self;
}

- (NSMutableArray *)allDataArray{
    if (!_allDataArray) {
        _allDataArray = [NSMutableArray array];
        _allDataArray = [[self.csvData componentsSeparatedByString:@"\n"] mutableCopy];
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            dispatch_apply(_allDataArray.count, dispatch_get_global_queue(0, 0), ^(size_t index) {
                NSArray *arr = [[_allDataArray[index] componentsSeparatedByString:@","] mutableCopy];
                if (!arr) {
                    arr = [@[] mutableCopy];
                }
                
                [_allDataArray replaceObjectAtIndex:index withObject:arr];
            });
//        });
    }
//    NSLog(@"alldata array is %@",_allDataArray);
    return _allDataArray;
}

//- (NSArray *)allRow{
//    return [self.csvData componentsSeparatedByString:@"\n"];
//}

- (NSMutableString *)csvData{
    if (!_csvData) {
        _csvData = [@"" mutableCopy];
    }
    return _csvData;
}

- (NSUInteger)numberOfColumn{
    if (!_numberOfColumn) {
        __block NSUInteger max = 0;
        //    for (NSString *str in self.allRow) {
        //        NSArray *arr = [str componentsSeparatedByString:@","];
        //        if (arr.count > max) {
        //            max = arr.count;
        //        }
        //    }
        
        dispatch_apply(self.numberOfRow, dispatch_get_global_queue(0, 0), ^(size_t index) {
            if ([self.allDataArray[index] count] > max) {
                max = [self.allDataArray[index] count];
            }
        });
        _numberOfColumn = max;
    }
    
    return _numberOfColumn;
}

- (NSUInteger)numberOfRow{
//    return self.allRow.count;
    return self.allDataArray.count;
}

- (void)writeData:(NSString *)data atPosition:(CSVPosition)position{
    [self writeData:data withX:position.x andY:position.y];
}

- (void)writeData:(NSString *)data withX:(NSUInteger)x andY:(NSUInteger)y{
    
//    NSMutableArray<NSString *> *dataArr = [self.allRow mutableCopy];
//    
//    while (dataArr.count < y+1) {
//        [dataArr addObject:@""];
//    }
    
    while (self.allDataArray.count < y+1) {
        [self.allDataArray addObject:[@[] mutableCopy]];
    }
    
//    NSMutableArray<NSString*>*rowArr = [[dataArr[y] componentsSeparatedByString:@","] mutableCopy];
    
//    while (rowArr.count < x+1) {
//        [rowArr addObject:@""];
//    }
    while ([self.allDataArray[y] count] < x+1) {
        [self.allDataArray[y] addObject:@""];
    }
    _numberOfColumn = x > _numberOfColumn ? x : _numberOfColumn;
    
    
//    [rowArr replaceObjectAtIndex:x withObject:data];
    [self.allDataArray[y] replaceObjectAtIndex:x withObject:data];
    
    
//    for (NSUInteger i = 0; i < rowArr.count; i++) {
//        [tmpStr appendString:rowArr[i]];
//        if (i != rowArr.count-1) {
//            [tmpStr appendString:@","];
//        }
//    }
//    
//    [dataArr replaceObjectAtIndex:y withObject:tmpStr];
//    
//    
//    NSMutableString *result = [@"" mutableCopy];
//    for (NSUInteger i = 0; i < dataArr.count; i++) {
//        [result appendString:dataArr[i]];
//        if (i != dataArr.count-1) {
//            [result appendString:@"\n"];
//        }
//    }
//    
//    self.csvData = result;
}

- (void)saveModel{
    NSMutableString *tmpStr = [@"" mutableCopy];
    for (int i = 0; i < self.allDataArray.count; i++) {
        for (int j = 0; j < [self.allDataArray[i] count]; j++) {
            [tmpStr appendString:self.allDataArray[i][j]];
            if (j != [self.allDataArray[i] count]-1) {
                [tmpStr appendString:@","];
            }
        }
        
        if (i != self.allDataArray.count-1) {
            [tmpStr appendString:@"\n"];
        }
    }
    
    self.csvData = tmpStr;
}


- (NSArray<NSString*> *)getRowAtIndex:(NSUInteger)index{
//    NSMutableArray *result = [[self.allRow[index] componentsSeparatedByString:@","] mutableCopy];
//    while (result.count < self.numberOfColumn) {
//        [result addObject:@""];
//    }
//    return [result copy];
//    NSLog(@"alllllll is %@",self.allDataArray);
    return self.allDataArray[index];
}


- (NSArray<NSString*> *)getColumnAtIndex:(NSUInteger)index{
//    NSMutableArray *result = [NSMutableArray array];
//    for (NSUInteger i = 0; i < self.allRow.count; i++) {
//        NSArray *tempArr = [self getRowAtIndex:i];
//        [result addObject:tempArr[index]];
//    }
//    return [result copy];
    
    NSMutableArray *result = [NSMutableArray array];
    for (NSArray *arr in self.allDataArray) {
            [result addObject:arr[index]];
    }
//    NSLog(@"dataarrrrrrr i s %@",self.allDataArray);

    return result;
}


- (NSString *)getDataAtCSVPostion:(CSVPosition)position{
    return [self getRowAtIndex:position.y][position.x];
}


#pragma mark - 链式调用
- (i3CSVModel *(^)(NSString *str))writeData{
    return ^(NSString *data){
        self.type = CSVMODEL_WRITE;
        self.writtenData = data;
        return self;
    };
}

- (i3CSVModel *)readData{
    self.type = CSVMODEL_READ;
    return self;
}

- (i3CSVModel *)at{
    return self;
}

- (id (^)(CSVPosition p))position{
    return ^(CSVPosition point){
        NSString *re = nil;
        switch (self.type) {
            case CSVMODEL_READ:
                re = [self getDataAtCSVPostion:point];
                break;
            case CSVMODEL_WRITE:
                [self writeData:self.writtenData atPosition:point];
                break;
            default:
                break;
        }
        return re;
    };
}


@end
