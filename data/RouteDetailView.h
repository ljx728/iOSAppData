//
//  RouteDetailView.h
//  data
//
//  Created by 李佳轩 on 15/12/31.
//  Copyright © 2015年 Li Jiaxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTouchesDelegate.h"

@interface RouteDetailView : UIView

@property (nonatomic, weak) id <BaseTouchesViewDelegate> delegate;

- (NSInteger)setRouteDetailContent:(NSDictionary *)routeDic;

@end
