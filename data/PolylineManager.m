//
//  PolylineManager.m
//  data
//
//  Created by 李佳轩 on 16/1/1.
//  Copyright © 2016年 Li Jiaxuan. All rights reserved.
//

#import "PolylineManager.h"
#import <MapKit/MapKit.h>

@implementation PolylineManager

/*
 Decode polyline string using Base64 to get location array.
 */
+ (NSArray *)decodePolyLine:(NSString *)encodedString {
    NSMutableArray *locationArray = [[NSMutableArray alloc] init];
    
    NSInteger index = 0;
    NSInteger latitudeE5 = 0;
    NSInteger longitudeE5 = 0;
    while (index < [encodedString length]) {
        // Decode latitude in E5 using Base64.
        NSInteger base;
        NSInteger shift = 0;
        NSInteger result = 0;
        do {
            base = [encodedString characterAtIndex:index++] - 63;
            result |= (base & 0x1f) << shift;
            shift += 5;
        } while (base >= 0x20);
        NSInteger deltaLatitude = ((result & 1) ? ~(result >> 1) : (result >> 1));
        latitudeE5 += deltaLatitude;
        
        // Decode longitude in E5 using Base64.
        shift = 0;
        result = 0;
        do {
            base = [encodedString characterAtIndex:index++] - 63;
            result |= (base & 0x1f) << shift;
            shift += 5;
        } while (base >= 0x20);
        NSInteger deltaLogitude = ((result & 1) ? ~(result >> 1) : (result >> 1));
        longitudeE5 += deltaLogitude;
        
        // Calculate real latitude and longitude.
        NSNumber *latitude = [[NSNumber alloc] initWithFloat:latitudeE5 * 1e-5];
        NSNumber *longitude = [[NSNumber alloc] initWithFloat:longitudeE5 * 1e-5];
        
        // Create CLLocation and put it into array.
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]] ;
        [locationArray addObject:location];
    }
    return [locationArray copy];
}

@end
