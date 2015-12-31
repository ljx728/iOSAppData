//
//  Constants.h
//  data
//
//  Created by 李佳轩 on 15/12/14.
//  Copyright © 2015年 Li Jiaxuan. All rights reserved.
//

/*
 This class is to define all contants.
 */
#import <Foundation/Foundation.h>

@interface Constants : NSObject

// File Name
extern NSString *const FileName;

// segments
extern NSString *const Routes;
extern NSString *const Properties;

// TT = travel type
extern NSString *const TT_publicTransport;
extern NSString *const TT_carSharing;
extern NSString *const TT_privateBike;
extern NSString *const TT_bikeSharing;
extern NSString *const TT_taxi;

// TM = travel mode
extern NSString *const TM_walking;
extern NSString *const TM_subway;
extern NSString *const TM_bus;
extern NSString *const TM_change;
extern NSString *const TM_setup;
extern NSString *const TM_driving;
extern NSString *const TM_parking;
extern NSString *const TM_cycling;

@end
