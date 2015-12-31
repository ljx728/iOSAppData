//
//  DetailViewController.h
//  data
//
//  Created by 李佳轩 on 15/12/19.
//  Copyright © 2015年 Li Jiaxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "RouteView.h"

@interface DetailViewController : UIViewController <MKMapViewDelegate, UIScrollViewDelegate, BaseTouchesViewDelegate>

@property (strong, nonatomic) NSArray *routeArray;
@property (nonatomic) NSInteger routeNumber;

@end
