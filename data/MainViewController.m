//
//  MainViewController.m
//  data
//
//  Created by 李佳轩 on 15/12/14.
//  Copyright © 2015年 Li Jiaxuan. All rights reserved.
//

#import "MainViewController.h"
#import "Constants.h"
#import "JSONFileManager.h"
#import "DataTableViewCell.h"
#import "DetailViewController.h"

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *routeArray;
@property (strong, nonatomic) NSArray *propertyArray;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Get data informacion.
    NSDictionary *dataDic = [JSONFileManager getDictionaryFromJSONFile:FileName];
    _routeArray = [dataDic objectForKey:Routes];
    _propertyArray = [dataDic objectForKey:Properties];
    
    // Set delegate and datasource for tableView.
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_routeArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    DataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DataTableViewCell"];
//    if (!cell) {
//        [_tableView registerNib:[UINib nibWithNibName:@"DataTableViewCell" bundle:nil] forCellReuseIdentifier:@"DataTableViewCell"];
//        cell = [tableView dequeueReusableCellWithIdentifier:@"DataTableViewCell"];
//    }
    
    // Get TableViewCell from .xib.
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DataTableViewCell" owner:self options:nil];
    DataTableViewCell *cell = [topLevelObjects firstObject];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    
    // Set content for each cell.
    [(DataTableViewCell *)cell setCellContent:[_routeArray objectAtIndex:indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    viewController.routeArray = _routeArray;
    viewController.routeNumber = indexPath.row;
    
    // Get frame of selected cell.
    CGRect cellRectInTableView = [tableView rectForRowAtIndexPath:indexPath];
    CGRect cellFrame = [tableView convertRect:cellRectInTableView toView:[tableView superview]];
    
    // Create a new cell the same as original one.
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DataTableViewCell" owner:self options:nil];
    DataTableViewCell *cell = [topLevelObjects objectAtIndex:0];
    [cell setFrame:cellFrame];
    [cell setCellContent:[_routeArray objectAtIndex:indexPath.row]];
    [self.view addSubview:cell];
    
    // Cell animation to new position.
    [UIView beginAnimations:@"MoveAnimation" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    cell.frame = CGRectMake(0, self.view.frame.size.height - 130, self.view.frame.size.width, 130);
    [UIView commitAnimations];
    
    // Start transition animation after delay.
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        CATransition *animation = [CATransition animation];
        [animation setDuration:0.5];
        [animation setType:kCATransitionFade];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
        [self.navigationController pushViewController:viewController animated:NO];
        [self.navigationController.view.layer addAnimation:animation forKey:nil];
        
        [cell removeFromSuperview];
    });
}

@end
