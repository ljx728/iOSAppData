//
//  DetailViewController.m
//  data
//
//  Created by 李佳轩 on 15/12/19.
//  Copyright © 2015年 Li Jiaxuan. All rights reserved.
//

#import "DetailViewController.h"
#import "RouteView.h"
#import "PolylineManager.h"
#import "ColorManager.h"

@interface DetailViewController ()

@property (strong, nonatomic) UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSMutableArray *routeLineArray;
@property (strong, nonatomic) NSArray *routeColorArray;
@property (strong, nonatomic) MKPolylineRenderer *routeLineRenderer;

@property (strong, nonatomic) UIImageView *circleImageView;
@property (strong, nonatomic) UIScrollView *routeScrollView;
@property (weak, nonatomic) NSMutableArray *routeViewArray;

@property (nonatomic) CGPoint beginPoint;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initNavigation];
    
    [self initMapView];
    NSArray *locationArray = [self getLocationArrayFrom:_routeArray routeNumber:_routeNumber];
    _routeColorArray = [self getColorArrayFrom:_routeArray routeNumber:_routeNumber];
    [self drawLineWithLocationArray:locationArray];
    [self setRegionWithLocationArray:locationArray];
    
    [self initRouteScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialization

- (void)initNavigation {
    // Create PageControl.
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width / 2, 40)];
    _pageControl.numberOfPages = [_routeArray count];
    [_pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _pageControl;
    _pageControl.currentPage = _routeNumber;
}

- (void)initMapView {
    // Set up mapView.
    _mapView.delegate = self;
    _mapView.mapType = MKMapTypeStandard;
}

- (void)initRouteScrollView {
    _routeScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 194, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_routeScrollView];
    
    // Set properties of routeScrollView.
    [_routeScrollView setBackgroundColor:[UIColor whiteColor]];
    [_routeScrollView setPagingEnabled:YES];
    _routeScrollView.alwaysBounceHorizontal = YES;
    _routeScrollView.showsHorizontalScrollIndicator = NO;
    _routeScrollView.showsVerticalScrollIndicator = NO;
    [_routeScrollView setContentSize:CGSizeMake([_routeArray count] * self.view.frame.size.width, self.view.frame.size.height)];
    _routeScrollView.delegate = self;
 
    // Init route views into scroll view.
    for (NSInteger i = 0; i < [_routeArray count]; i++) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"RouteView" owner:self options:nil];
        RouteView *routeView = [topLevelObjects objectAtIndex:0];
        [routeView setFrame:CGRectMake(i * _routeScrollView.frame.size.width, 0, _routeScrollView.frame.size.width, _routeScrollView.frame.size.height)];
        [routeView setRouteContent:[_routeArray objectAtIndex:i]];
        routeView.delegate = self;
        [_routeViewArray addObject:routeView];
        [_routeScrollView addSubview:routeView];
    }
    
    // Set to selected route.
    [_routeScrollView scrollRectToVisible:CGRectMake(_routeScrollView.frame.size.width * _routeNumber, 0, _routeScrollView.frame.size.width, _routeScrollView.frame.size.height) animated:YES];
    
    // Add a circle image in the up-right place.
    _circleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 80, self.view.frame.size.height - 224, 60, 60)];
    UIImage *circleImage = [UIImage imageNamed:@"image_Route.png"];
    [_circleImageView setImage:circleImage];
    [self.view addSubview:_circleImageView];
}

#pragma mark - MapView

/*
 Parse route array to get the location array.
 */
- (NSArray *)getLocationArrayFrom:(NSArray *)routeArray routeNumber:(NSInteger)number {
    NSDictionary *routeDic = [routeArray objectAtIndex:number];
    NSArray *segmentArray = [routeDic objectForKey:@"segments"];
    
    NSMutableArray *locationArray = [[NSMutableArray alloc] init];
    for (NSDictionary *segmentDic in segmentArray) {
        // If polyline exists, then extract latitude and longitude from encoded polyline.
        NSString *encodedPolyline = [segmentDic objectForKey:@"polyline"];
        if (encodedPolyline != nil && ![encodedPolyline isKindOfClass:[NSNull class]]) {
            NSArray *subLocationArray = [PolylineManager decodePolyLine:encodedPolyline];
            [locationArray addObject:subLocationArray];
        }
        
        // If polyline is null, then extract latitude and longitude from stops.
        else {
            NSMutableArray *subLocationArray = [[NSMutableArray alloc] init];
            NSArray *stopArray = [segmentDic objectForKey:@"stops"];
            for (NSDictionary *stopDic in stopArray) {
                CLLocationDegrees latitude = [[stopDic objectForKey:@"lat"] doubleValue];
                CLLocationDegrees longitude = [[stopDic objectForKey:@"lng"] doubleValue];
                CLLocation *locationCoordinate = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
                [subLocationArray addObject:locationCoordinate];
            }
            [locationArray addObject:[subLocationArray copy]];
        }
    }
    
    return [locationArray copy];
}

/*
 Parse route array to get the color array.
 */
- (NSArray *)getColorArrayFrom:(NSArray *)routeArray routeNumber:(NSInteger)number {
    NSDictionary *routeDic = [routeArray objectAtIndex:number];
    NSArray *segmentArray = [routeDic objectForKey:@"segments"];
    
    NSMutableArray *colorArray = [[NSMutableArray alloc] init];
    for (NSDictionary *segmentDic in segmentArray) {
        NSString *colorString = [segmentDic objectForKey:@"color"];
        UIColor *color = [ColorManager colorFromHexString:colorString];
        [colorArray addObject:color];
    }
    
    return [colorArray copy];
}

/*
 Draw lines with location array.
 */
- (void)drawLineWithLocationArray:(NSArray *)locationArray {
    if ([_mapView.overlays count] > 0) {
        [_mapView removeOverlays:_mapView.overlays];
    }
    _routeLineArray = [[NSMutableArray alloc] init];
    
    for (NSArray *subLocationArray in locationArray) {
        NSInteger pointCount = [subLocationArray count];
        CLLocationCoordinate2D *coordinateArray = (CLLocationCoordinate2D *)malloc(pointCount * sizeof(CLLocationCoordinate2D));
        
        // Transfer CLLocation Array to CLLocationCoordinate2D Array.
        for (NSInteger i = 0; i < pointCount; ++i) {
            CLLocation *location = [subLocationArray objectAtIndex:i];
            coordinateArray[i] = [location coordinate];
        }
        
        MKPolyline *routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:pointCount];
        [_routeLineArray addObject:routeLine];
        [_mapView addOverlay:routeLine];
        
        free(coordinateArray);
        coordinateArray = nil;
    }
}

/*
 Set location and span of MapView.
 */
- (void)setRegionWithLocationArray:(NSArray *)locationArray {
    // Calculate central location coordinate.
    double sumLatitude = 0.0;
    double sumLongitude = 0.0;
    NSInteger pointCount = 0;
    for (NSArray *subLocationArray in locationArray) {
        for (CLLocation *location in subLocationArray) {
            pointCount++;
            sumLatitude += location.coordinate.latitude;
            sumLongitude += location.coordinate.longitude;
        }
    }
    double averageLatitude = sumLatitude / pointCount;
    double averageLongitude = sumLongitude / pointCount;
    CLLocationCoordinate2D centralLocation = CLLocationCoordinate2DMake(averageLatitude, averageLongitude);
    
    // Calculate region span.
    double maxLatitude = 0.0;
    double maxLongitude = 0.0;
    double minLatitude = 0.0;
    double minLongitude = 0.0;
    if (pointCount > 0) {
        CLLocation *location = [[locationArray firstObject] firstObject];
        maxLatitude = location.coordinate.latitude;
        minLatitude = location.coordinate.latitude;
        maxLongitude = location.coordinate.longitude;
        minLongitude = location.coordinate.longitude;
        for (NSArray *subLocationArray in locationArray) {
            for (CLLocation *location in subLocationArray) {
                if (maxLatitude < location.coordinate.latitude) {
                    maxLatitude = location.coordinate.latitude;
                }
                if (minLatitude > location.coordinate.latitude) {
                    minLatitude = location.coordinate.latitude;
                }
                if (maxLongitude < location.coordinate.longitude) {
                    maxLongitude = location.coordinate.longitude;
                }
                if (minLongitude > location.coordinate.longitude) {
                    minLongitude = location.coordinate.longitude;
                }
            }
        }
    }
    double latitudeDelta = maxLatitude - minLatitude;
    double longitudeDelta = maxLongitude - minLongitude;
    MKCoordinateSpan span = MKCoordinateSpanMake(latitudeDelta * 2, longitudeDelta * 2);

    // Set MapView region.
    MKCoordinateRegion region = MKCoordinateRegionMake(centralLocation, span);
    [_mapView setRegion:region animated:true];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    for (NSInteger i = 0; i < [_routeLineArray count]; ++i) {
        MKPolyline *routeLine = [_routeLineArray objectAtIndex:i];
        if (overlay == routeLine) {
            _routeLineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:routeLine];
            _routeLineRenderer.fillColor = [_routeColorArray objectAtIndex:i];
            _routeLineRenderer.strokeColor = [_routeColorArray objectAtIndex:i];
            _routeLineRenderer.lineWidth = 5;
            return _routeLineRenderer;
        }
    }
    return nil;
}

#pragma mark - PageControl

-(void)pageChanged:(UIPageControl *)sender {
    [_routeScrollView scrollRectToVisible:CGRectMake(sender.currentPage * _routeScrollView.frame.size.width, 0, _routeScrollView.frame.size.width, _routeScrollView.frame.size.height) animated:YES];
    NSArray *locationArray = [self getLocationArrayFrom:_routeArray routeNumber:sender.currentPage];
    _routeColorArray = [self getColorArrayFrom:_routeArray routeNumber:sender.currentPage];
    [self drawLineWithLocationArray:locationArray];
    [self setRegionWithLocationArray:locationArray];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _pageControl.currentPage = floorf(_routeScrollView.contentOffset.x / _routeScrollView.frame.size.width);
    NSArray *locationArray = [self getLocationArrayFrom:_routeArray routeNumber:_pageControl.currentPage];
    _routeColorArray = [self getColorArrayFrom:_routeArray routeNumber:_pageControl.currentPage];
    [self drawLineWithLocationArray:locationArray];
    [self setRegionWithLocationArray:locationArray];
}

/*
 When scroll horizontally while drag the scrollView up/down, the scrollView, imageView and mapView will not decelerate to the final positions.
 Here should decelerate to the final position again.
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGRect scrollFrame = _routeScrollView.frame;
    CGRect imageFrame = _circleImageView.frame;
    CGRect mapFrame = _mapView.frame;
    if (scrollFrame.origin.y < self.view.frame.size.height - 300) {
        scrollFrame.origin.y = 60;
        imageFrame.origin.y = 30;
        mapFrame.origin.y = 30 - mapFrame.size.height / 2;
    } else {
        scrollFrame.origin.y = self.view.frame.size.height - 130;
        imageFrame.origin.y = self.view.frame.size.height - 160;
        mapFrame.origin.y = 0;
    }
    [self moveAnimationWithView:_routeScrollView finalFrame:scrollFrame];
    [self moveAnimationWithView:_circleImageView finalFrame:imageFrame];
    [self moveAnimationWithView:_mapView finalFrame:mapFrame];
}

#pragma mark - BaseTouchesViewDelegate

- (void)theTouchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    _beginPoint = [touch locationInView:_routeScrollView];
}

- (void)theTouchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:_routeScrollView];
    
    // Set new position for scrollView and imageView.
    CGRect scrollFrame = _routeScrollView.frame;
    scrollFrame.origin.y += currentPoint.y - _beginPoint.y;
    if (scrollFrame.origin.y < 60) {
        scrollFrame.origin.y = 60;
    } else if (scrollFrame.origin.y > self.view.frame.size.height - 130) {
        scrollFrame.origin.y = self.view.frame.size.height - 130;
    }
    [_routeScrollView setFrame:scrollFrame];
 
    CGRect imageFrame = _circleImageView.frame;
    imageFrame.origin.y += currentPoint.y - _beginPoint.y;
    if (imageFrame.origin.y < 30) {
        imageFrame.origin.y = 30;
    } else if (imageFrame.origin.y > self.view.frame.size.height - 160) {
        imageFrame.origin.y = self.view.frame.size.height - 160;
    }
    [_circleImageView setFrame:imageFrame];
    
    // Set new position for mapView.
    _mapView.center = CGPointMake(_mapView.center.x, _routeScrollView.frame.origin.y / 2);
    
}

- (void)theTouchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // Detect current positions of scrollView, imageView and mapView and decelerate to the final positions.
    CGRect scrollFrame = _routeScrollView.frame;
    CGRect imageFrame = _circleImageView.frame;
    CGRect mapFrame = _mapView.frame;
    if (scrollFrame.origin.y < self.view.frame.size.height - 300) {
        scrollFrame.origin.y = 60;
        imageFrame.origin.y = 30;
        mapFrame.origin.y = 30 - mapFrame.size.height / 2;
    } else {
        scrollFrame.origin.y = self.view.frame.size.height - 130;
        imageFrame.origin.y = self.view.frame.size.height - 160;
        mapFrame.origin.y = 0;
    }
    [self moveAnimationWithView:_routeScrollView finalFrame:scrollFrame];
    [self moveAnimationWithView:_circleImageView finalFrame:imageFrame];
    [self moveAnimationWithView:_mapView finalFrame:mapFrame];
}

#pragma mark - Animation

- (void)moveAnimationWithView:(UIView *)view finalFrame:(CGRect)frame {
    [UIView beginAnimations:@"MoveAnimation" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    view.frame = frame;
    [UIView commitAnimations];
}

@end
