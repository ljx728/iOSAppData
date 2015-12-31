//
//  thumbView.m
//  data
//
//  Created by 李佳轩 on 15/12/14.
//  Copyright © 2015年 Li Jiaxuan. All rights reserved.
//

#import "ThumbView.h"
#import "Constants.h"
#import "ColorManager.h"

@interface ThumbView ()

@property (strong, nonatomic) UIImageView *thumbImageView;
@property (strong, nonatomic) UILabel *thumbLabel;

@end

@implementation ThumbView

/*
 Init a thumb view with a frame.
 */
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.layer.cornerRadius = 5.0f;
    
    // Init thumb image view
    _thumbImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, frame.size.width - 20, frame.size.width - 15)];
    [self addSubview:_thumbImageView];
    
    // Init thumb text
    _thumbLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.width, frame.size.width, 15)];
    _thumbLabel.textAlignment = NSTextAlignmentCenter;
    _thumbLabel.textColor = [UIColor blackColor];
    _thumbLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_thumbLabel];
    
    return self;
}

/*
 Set content for thumb view including color, image and text.
 */
- (void)setContentWithType:(NSString *)type travelMode:(NSString *)travelMode iconUrl:(NSString *)icon_url name:(NSString *)name backgroundColor:(NSString *)color {
    // set background color
    [self setBackgroundColor:[ColorManager colorFromHexString:color]];
    
    // set image
    // !!! The icon_url is empty !!!
//    _thumbImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:icon_url]]];
    
    // Instead I use my own pictures.
    if ([travelMode isEqualToString:@"walking"]) {
        _thumbImageView.image = [UIImage imageNamed:@"walking.png"];
    } else if ([travelMode isEqualToString:@"bus"]) {
        _thumbImageView.image = [UIImage imageNamed:@"bus.png"];
    }  else if ([travelMode isEqualToString:@"subway"]) {
        _thumbImageView.image = [UIImage imageNamed:@"subway.png"];
    } else if ([travelMode isEqualToString:@"driving"]) {
        if ([type isEqualToString:@"car_sharing"]) {
            _thumbImageView.image = [UIImage imageNamed:@"carSharing.png"];
        } else if ([type isEqualToString:@"taxi"]) {
            _thumbImageView.image = [UIImage imageNamed:@"taxi.png"];
        }
    } else if ([travelMode isEqualToString:@"cycling"]) {
        if ([type isEqualToString:@"private_bike"]) {
            _thumbImageView.image = [UIImage imageNamed:@"privateBike.png"];
        } else if ([type isEqualToString:@"bike_sharing"]) {
            _thumbImageView.image = [UIImage imageNamed:@"bikeSharing.png"];
        }
    }
    
    // set text content
    if (name != nil && ![name isKindOfClass:[NSNull class]]) {
        _thumbLabel.text = name;
    } else {
        _thumbLabel.text = @"";
    }
}

@end
