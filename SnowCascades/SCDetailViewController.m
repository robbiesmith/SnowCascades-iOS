//
//  SCDetailViewController.m
//  SnowCascades
//
//  Created by Rob Smith on 11/8/13.
//  Copyright (c) 2013 SnowCascades. All rights reserved.
//

#import "SCDetailViewController.h"

#import "SCSnowContentView.h"

@interface SCDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (strong, nonatomic) UIView *myView;
- (void)configureView;
@end

@implementation SCDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(SCResortData *)newDetailItem
{
//    if (self.detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
//    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        // by default show the snow view
        //self.detailDescriptionLabel.text = [[self.detailItem getSnowView] text];
        
        UIButton *snowButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [snowButton addTarget:self
                       action:@selector(showSnow)
             forControlEvents:UIControlEventTouchDown];
        [snowButton setTitle:@"Snow" forState:UIControlStateNormal];
        snowButton.frame = CGRectMake(20.0, 80.0, 60.0, 40.0);
        [[self view] addSubview:snowButton];

        UIButton *weatherButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [weatherButton addTarget:self
                          action:@selector(showWeather)
                forControlEvents:UIControlEventTouchDown];
        [weatherButton setTitle:@"Weather" forState:UIControlStateNormal];
        weatherButton.frame = CGRectMake(100.0, 80.0, 60.0, 40.0);
        [[self view] addSubview:weatherButton];

        UIButton *trafficButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [trafficButton addTarget:self
                          action:@selector(showTraffic)
                forControlEvents:UIControlEventTouchDown];
        [trafficButton setTitle:@"Traffic" forState:UIControlStateNormal];
        trafficButton.frame = CGRectMake(180.0, 80.0, 60.0, 40.0);
        [[self view] addSubview:trafficButton];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    [self showSnow];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Resorts", @"Resorts");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

-(void)showTraffic {
//    [self.view addSubview:[self.detailItem getTrafficView]];
    [_myView removeFromSuperview];
    SCSnowContentView *thisView = [[SCSnowContentView alloc] initWithFrame:CGRectMake(100.0, 120.0, 200.0, 400.0)];
    NSDictionary *trafficData = [self.detailItem.data objectForKey:@"traffic"];
    [thisView setViewData:[trafficData objectForKey:@"body"]];
    [thisView createViewContents];
    _myView = thisView;
    [[self view] addSubview:_myView];
    
}

-(void)showWeather {
//    [self.view addSubview:[self.detailItem getWeatherView]];
    [_myView removeFromSuperview];
    SCSnowContentView *thisView = [[SCSnowContentView alloc] initWithFrame:CGRectMake(100.0, 120.0, 200.0, 400.0)];
    NSArray *weatherDays = [[self.detailItem.data objectForKey:@"weather"] objectForKey:@"tabs"];
    NSArray *trafficData = [weatherDays objectAtIndex:0];

    [thisView setViewData:trafficData];
    [thisView createViewContents];
    _myView = thisView;
//    _myView = [self.detailItem getWeatherView];
    [[self view] addSubview:_myView];
    
}

-(void)showSnow {
//    [self.view addSubview:[self.detailItem getSnowView]];
    if(_myView) {
        [_myView removeFromSuperview];
    }
    SCSnowContentView *thisView = [[SCSnowContentView alloc] initWithFrame:CGRectMake(100.0, 120.0, 200.0, 400.0)];
    NSDictionary *trafficData = [self.detailItem.data objectForKey:@"conditions"];
    [thisView setViewData:[trafficData objectForKey:@"body"]];
    [thisView createViewContents];
    _myView = thisView;
    [[self view] addSubview:_myView];
    
}

@end
