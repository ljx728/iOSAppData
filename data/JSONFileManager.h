//
//  JSONFileManager.h
//  data
//
//  Created by 李佳轩 on 15/12/16.
//  Copyright © 2015年 Li Jiaxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONFileManager : NSObject

+ (NSDictionary *)getDictionaryFromJSONFile:(NSString *)fileName;

@end
