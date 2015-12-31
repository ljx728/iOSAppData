//
//  BaseTouchesDelegate.h
//  data
//
//  Created by 李佳轩 on 15/12/31.
//  Copyright © 2015年 Li Jiaxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BaseTouchesViewDelegate <NSObject>

- (void)theTouchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;
- (void)theTouchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;
- (void)theTouchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;

@end
