//
//  DataTableViewCell.m
//  data
//
//  Created by 李佳轩 on 15/12/16.
//  Copyright © 2015年 Li Jiaxuan. All rights reserved.
//

#import "DataTableViewCell.h"
#import "ThumbView.h"

@interface DataTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *typeLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation DataTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setCellContent:(NSDictionary *)routeDic {
    // Set type label.
    NSString *type = [routeDic objectForKey:@"type"];
    _typeLabel.text = [type stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    
    // Parse all segments.
    NSArray *segmentArray = [routeDic objectForKey:@"segments"];
    
    NSString *startTimeString;
    NSString *endTimeString;
    NSInteger thumbNum = 0;
    for (NSInteger i = 0; i < [segmentArray count]; i++) {
        NSDictionary *segmentDic = [segmentArray objectAtIndex:i];
        NSString *travelMode = [segmentDic objectForKey:@"travel_mode"];
        
        // Exclude thumb for change, setup and parking.
        if (![travelMode isEqualToString:@"change"] && ![travelMode isEqualToString:@"setup"] && ![travelMode isEqualToString:@"parking"]) {
            NSString *iconURL = [segmentDic objectForKey:@"icon_url"];
            NSString *color = [segmentDic objectForKey:@"color"];
            NSString *name = [segmentDic objectForKey:@"name"];
            
            // Create thumbView.
            ThumbView *thumbView = [[ThumbView alloc] initWithFrame:CGRectMake(thumbNum * 60 + 10, 35, 50, 65)];
            [thumbView setContentWithType:type travelMode:travelMode iconUrl:iconURL name:name backgroundColor:color];
            [self addSubview:thumbView];
            thumbNum++;
        }
        
        // Parse start time and end time.
        if (i == 0) {
            NSArray *stopArray = [segmentDic objectForKey:@"stops"];
            startTimeString = [[stopArray firstObject] objectForKey:@"datetime"];
        }
        if (i == [segmentArray count] - 1) {
            NSArray *stopArray = [segmentDic objectForKey:@"stops"];
            endTimeString = [[stopArray lastObject] objectForKey:@"datetime"];
        }
    }
    
    // Calculate duration.
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:sszzz"];
    NSDate *startTime = [dateFormatter dateFromString:startTimeString];
    NSDate *endTime = [dateFormatter dateFromString:endTimeString];
    NSTimeInterval startTimeInterval = [startTime timeIntervalSince1970];
    NSTimeInterval endTimeInterval = [endTime timeIntervalSince1970];
    NSTimeInterval duration = endTimeInterval - startTimeInterval;
    int hour = (int) duration / 60 / 60;
    int minute = (int) duration / 60 - hour * 60;
    
    // Set time label.
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *startTimeStringShort = [dateFormatter stringFromDate:startTime];
    NSString *endTimeStringShort = [dateFormatter stringFromDate:endTime];
    if (hour > 0) {
        _timeLabel.text = [NSString stringWithFormat:@"%@ - %@    Duration: %dH %dm", startTimeStringShort, endTimeStringShort, hour, minute];
    } else {
        _timeLabel.text = [NSString stringWithFormat:@"%@ - %@    Duration: %dm", startTimeStringShort, endTimeStringShort, minute];
    }
    
    
    // Set price label.
    NSDictionary *priceDic = [routeDic objectForKey:@"price"];
    if (![priceDic isKindOfClass:[NSNull class]]) {
        NSString *currency = [priceDic objectForKey:@"currency"];
        NSString *amount = [priceDic objectForKey:@"amount"];
        _priceLabel.text = [NSString stringWithFormat:@"%@ %@", amount, currency];
    } else {
        _priceLabel.text = @"";
    }
}

@end
