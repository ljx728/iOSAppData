//
//  ColorManager.h
//  data
//
//  Created by 李佳轩 on 15/12/20.
//  Copyright © 2015年 Li Jiaxuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ColorManager : NSObject

+ (UIColor *)colorFromHexString:(NSString *)hexString;

@end
