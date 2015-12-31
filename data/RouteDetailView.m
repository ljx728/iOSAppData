//
//  RouteDetailView.m
//  data
//
//  Created by 李佳轩 on 15/12/31.
//  Copyright © 2015年 Li Jiaxuan. All rights reserved.
//

#import "RouteDetailView.h"
#import "ColorManager.h"

@implementation RouteDetailView

- (void)setRouteDetailContent:(NSDictionary *)routeDic {
    [self setBackgroundColor:[UIColor whiteColor]];
    NSArray *segmentArray = [routeDic objectForKey:@"segments"];
    
    for (NSInteger i = 0; i < [segmentArray count]; ++i) {
        NSDictionary *segmentDic = [segmentArray objectAtIndex:i];
        NSString *travelMode = [segmentDic objectForKey:@"travel_mode"];
        NSString *color = [segmentDic objectForKey:@"color"];

        // Parse stops and draw them into view.
        NSArray *stopArray = [segmentDic objectForKey:@"stops"];
        if ([stopArray count] > 0) {
            NSDictionary *startStopDic = [stopArray firstObject];
            NSDictionary *endStopDic = [stopArray lastObject];
            
            // Parse time.
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:sszzz"];
            NSString *startTimeString = [startStopDic objectForKey:@"datetime"];
            NSString *endTimeString = [endStopDic objectForKey:@"datetime"];
            NSDate *startTime = [dateFormatter dateFromString:startTimeString];
            NSDate *endTime = [dateFormatter dateFromString:endTimeString];

            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"HH:mm"];
            NSString *startTimeStringShort = [dateFormatter stringFromDate:startTime];
            NSString *endTimeStringShort = [dateFormatter stringFromDate:endTime];
            
            // Code block - Start
            {
                // Set start time label.
                UILabel *startTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, i * 100 + 20, 50, 40)];
                [startTimeLabel setBackgroundColor:[UIColor whiteColor]];
                startTimeLabel.textAlignment = NSTextAlignmentCenter;
                startTimeLabel.textColor = [UIColor blackColor];
                startTimeLabel.font = [UIFont systemFontOfSize:15];
                startTimeLabel.text = startTimeStringShort;
                [self addSubview:startTimeLabel];
                
                // Set start location label.
                UILabel *startLocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, i * 100 + 20, [UIScreen mainScreen].bounds.size.width - 115, 40)];
                startLocationLabel.numberOfLines = 0;
                [startLocationLabel setBackgroundColor:[UIColor whiteColor]];
                startLocationLabel.textAlignment = NSTextAlignmentLeft;
                startLocationLabel.textColor = [ColorManager colorFromHexString:color];
                startLocationLabel.font = [UIFont systemFontOfSize:15];
                NSString *startLocation = [startStopDic objectForKey:@"name"];
                if (startLocation != nil && ![startLocation isKindOfClass:[NSNull class]]) {
                    startLocationLabel.text = startLocation;
                } else {
                    startLocationLabel.text = @"Current Location";
                }
                [self addSubview:startLocationLabel];
                
                // Draw start circle.
                UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(75, i * 100 + 32.5, 15, 15)];
                circleView.layer.cornerRadius = 7.5f;
                [circleView setBackgroundColor:[ColorManager colorFromHexString:color]];
                [self addSubview:circleView];
                
                // deal with special views.
                if ([travelMode isEqualToString:@"walking"] || [travelMode isEqualToString:@"change"]) {
                    [self sendSubviewToBack:startTimeLabel];
                    [self sendSubviewToBack:startLocationLabel];
                    [self sendSubviewToBack:circleView];
                }
            }
            
            // Code block - End
            {
                // Set end time label.
                UILabel *endTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, (i + 1) * 100 + 20, 50, 40)];
                [endTimeLabel setBackgroundColor:[UIColor whiteColor]];
                endTimeLabel.textAlignment = NSTextAlignmentCenter;
                endTimeLabel.textColor = [UIColor blackColor];
                endTimeLabel.font = [UIFont systemFontOfSize:15];
                endTimeLabel.text = endTimeStringShort;
                [self addSubview:endTimeLabel];
                
                // Set end location label.
                UILabel *endLocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, (i + 1) * 100 + 20, [UIScreen mainScreen].bounds.size.width - 115, 40)];
                endLocationLabel.numberOfLines = 0;
                [endLocationLabel setBackgroundColor:[UIColor whiteColor]];
                endLocationLabel.textAlignment = NSTextAlignmentLeft;
                endLocationLabel.textColor = [ColorManager colorFromHexString:color];
                endLocationLabel.font = [UIFont systemFontOfSize:15];
                NSString *endLocation = [endStopDic objectForKey:@"name"];
                if (endLocation != nil && ![endLocation isKindOfClass:[NSNull class]]) {
                    endLocationLabel.text = endLocation;
                } else {
                    endLocationLabel.text = @"Destination";
                }
                [self addSubview:endLocationLabel];
                
                // Draw end circle.
                UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(75, (i + 1) * 100 + 32.5, 15, 15)];
                circleView.layer.cornerRadius = 7.5f;
                [circleView setBackgroundColor:[ColorManager colorFromHexString:color]];
                [self addSubview:circleView];
                
                // Draw connection Line.
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(77.5, i * 100 + 40, 10, 100)];
                [lineView setBackgroundColor:[ColorManager colorFromHexString:color]];
                [self addSubview:lineView];
                
                if ([travelMode isEqualToString:@"walking"] || [travelMode isEqualToString:@"change"]) {
                    [self sendSubviewToBack:endTimeLabel];
                    [self sendSubviewToBack:endLocationLabel];
                    [self sendSubviewToBack:circleView];
                    [self sendSubviewToBack:lineView];
                }
            }
            
            // Code block - Information
            {
                // Set travel mode label.
                NSString *name = [segmentDic objectForKey:@"name"];
                if (name != nil && ![name isKindOfClass:[NSNull class]]) {
                    travelMode = [NSString stringWithFormat:@"%@ %@", travelMode, name];
                }
                NSInteger stopNum = [[segmentDic objectForKey:@"num_stops"] integerValue];
                if (stopNum > 0) {
                    travelMode = [NSString stringWithFormat:@"%@, stops:%ld", travelMode, stopNum];
                }
                
                UILabel *travelModeLabel = [[UILabel alloc] initWithFrame:CGRectMake(115, i * 100 + 70, [UIScreen mainScreen].bounds.size.width - 115, 20)];
                [travelModeLabel setBackgroundColor:[UIColor whiteColor]];
                travelModeLabel.textAlignment = NSTextAlignmentLeft;
                travelModeLabel.textColor = [ColorManager colorFromHexString:color];
                travelModeLabel.font = [UIFont boldSystemFontOfSize:15];
                travelModeLabel.text = travelMode;
                [self addSubview:travelModeLabel];
                
                // Set Duration label.
                NSTimeInterval startTimeInterval = [startTime timeIntervalSince1970];
                NSTimeInterval endTimeInterval = [endTime timeIntervalSince1970];
                NSTimeInterval duration = endTimeInterval - startTimeInterval;
                int hour = (int) duration / 60 / 60;
                int minute = (int) duration / 60 - hour * 60;
                
                UILabel *durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(115, i * 100 + 90, [UIScreen mainScreen].bounds.size.width - 115, 15)];
                [durationLabel setBackgroundColor:[UIColor whiteColor]];
                durationLabel.textAlignment = NSTextAlignmentLeft;
                durationLabel.textColor = [ColorManager colorFromHexString:color];
                durationLabel.font = [UIFont boldSystemFontOfSize:12];
                if (hour > 0) {
                    durationLabel.text = [NSString stringWithFormat:@"Duration: %dH %dm", hour, minute];
                } else {
                    durationLabel.text = [NSString stringWithFormat:@"Duration: %dm", minute];
                }
                [self addSubview:durationLabel];
            }
        }
    }
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.delegate theTouchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.delegate theTouchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.delegate theTouchesEnded:touches withEvent:event];
}


@end
