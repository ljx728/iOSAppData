//
//  ColorManager.m
//  data
//
//  Created by 李佳轩 on 15/12/20.
//  Copyright © 2015年 Li Jiaxuan. All rights reserved.
//

#import "ColorManager.h"

@implementation ColorManager

/*
 Convert a hex string with format "#FFFFFF" to UIColor.
 */
+ (UIColor *)colorFromHexString:(NSString *)hexString {
    hexString = [hexString uppercaseString];
    NSString *rString = [hexString substringWithRange:NSMakeRange(1, 2)];
    NSString *gString = [hexString substringWithRange:NSMakeRange(3, 2)];
    NSString *bString = [hexString substringWithRange:NSMakeRange(5, 2)];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:1.0f];
}

@end
