//
//  JSONFileManager.m
//  data
//
//  Created by 李佳轩 on 15/12/16.
//  Copyright © 2015年 Li Jiaxuan. All rights reserved.
//

#import "JSONFileManager.h"

@implementation JSONFileManager

/*
 Read data from JSON file and stored as NSDictionary.
 */
+ (NSDictionary *)getDictionaryFromJSONFile:(NSString *)fileName {
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    return dic;
}

@end
