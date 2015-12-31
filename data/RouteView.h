//
//  RouteView.h
//  data
//
//  Created by 李佳轩 on 15/12/16.
//  Copyright © 2015年 Li Jiaxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTouchesDelegate.h"

@interface RouteView : UIView <BaseTouchesViewDelegate>

@property (nonatomic, weak) id <BaseTouchesViewDelegate> delegate;

- (void)setRouteContent:(NSDictionary *)routeDic;

@end
