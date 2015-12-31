//
//  RouteView.m
//  data
//
//  Created by 李佳轩 on 15/12/16.
//  Copyright © 2015年 Li Jiaxuan. All rights reserved.
//

#import "RouteView.h"
#import "DataTableViewCell.h"
#import "RouteDetailView.h"

@interface RouteView ()

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIScrollView *routeDetailScrollView;

@property (nonatomic) CGPoint beginPoint;

@end

@implementation RouteView

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void)setRouteContent:(NSDictionary *)routeDic {
    [self initHeaderView:routeDic];
    [self initRouteDetailScrollView:routeDic];
}

#pragma mark - Initialization

- (void)initHeaderView:(NSDictionary *)routeDic {
    // Get view from .xib.
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DataTableViewCell" owner:self options:nil];
    DataTableViewCell *cell = [topLevelObjects firstObject];
    [cell setFrame:CGRectMake(0, 0, self.frame.size.width, 130)];
    [cell setCellContent:routeDic];
    [_headerView addSubview:cell];
    
    // Add a view for touch detection.
    UIView *touchView = [[UIView alloc] initWithFrame:cell.frame];
    [_headerView addSubview:touchView];
}

- (void)initRouteDetailScrollView:(NSDictionary *)routeDic {
    NSArray *segmentArray = [routeDic objectForKey:@"segments"];
    RouteDetailView *routeDetailView = [[RouteDetailView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, ([segmentArray count] + 1) * 100 + 80)];
    [routeDetailView setRouteDetailContent:routeDic];
    [_routeDetailScrollView addSubview:routeDetailView];
    [_routeDetailScrollView setContentSize:routeDetailView.frame.size];
    routeDetailView.delegate = self;
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

#pragma mark - BaseTouchesViewDelegate

- (void)theTouchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    _beginPoint = [touch locationInView:_routeDetailScrollView];
    [self.delegate theTouchesBegan:touches withEvent:event];
}

- (void)theTouchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:_routeDetailScrollView];
    
    if (_routeDetailScrollView.contentOffset.y <= 0) {
        CGFloat offsetY = currentPoint.y - _beginPoint.y;
        if (offsetY > 0) {
            [_routeDetailScrollView setScrollEnabled:NO];
            [self.delegate theTouchesMoved:touches withEvent:event];
        }
    }
}

- (void)theTouchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_routeDetailScrollView setScrollEnabled:YES];
    [self.delegate theTouchesEnded:touches withEvent:event];
}

@end
