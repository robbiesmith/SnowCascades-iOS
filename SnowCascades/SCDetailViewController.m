//
//  SCDetailViewController.m
//  SnowCascades
//
//  Created by Rob Smith on 11/8/13.
//  Copyright (c) 2013 SnowCascades. All rights reserved.
//

#import "SCDetailViewController.h"

#import "SCResortData.h"

#import "SCSnowContentView.h"

#define kDetailDisplayWidth 240.0

@interface SCDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (strong, nonatomic) UIView *myView;
- (void)configureView;
@end

@implementation SCDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        for (UIView *view in [self.view subviews]) {
            [view removeFromSuperview];
        }
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{

    if (self.detailItem) {
        /*
         NSDictionary *viewsDictionary =
         NSDictionaryOfVariableBindings(self.button1, self.button2);
         NSArray *constraints =
         [NSLayoutConstraint constraintsWithVisualFormat:@"[button1]-[button2]"
         options:0 metrics:nil views:viewsDictionary];
         */

        SCResortData *resortData = self.detailItem;
        CGFloat xOffset = (self.view.frame.size.width - kDetailDisplayWidth + 20.0) / 2;
        bool showTab = NO;
        
        if ( [resortData.data objectForKey:@"conditions"] != nil ) {
            UIButton *snowButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [snowButton addTarget:self
                           action:@selector(showSnow)
                 forControlEvents:UIControlEventTouchDown];
            [snowButton setTitle:[[resortData.data objectForKey:@"conditions"] objectForKey:@"title"] forState:UIControlStateNormal];
            snowButton.frame = CGRectMake(xOffset, 80.0, 60.0, 40.0);
            [[self view] addSubview:snowButton];
            xOffset = xOffset + 80.0;
            if ( !showTab ) {
                [self showSnow];
                showTab = YES;
            }
        }

        if ( [resortData.data objectForKey:@"weather"] != nil ) {
            UIButton *weatherButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [weatherButton addTarget:self
                              action:@selector(showWeather)
                    forControlEvents:UIControlEventTouchDown];
            [weatherButton setTitle:[[resortData.data objectForKey:@"weather"] objectForKey:@"title"] forState:UIControlStateNormal];
            weatherButton.frame = CGRectMake(xOffset, 80.0, 60.0, 40.0);
            [[self view] addSubview:weatherButton];
            xOffset = xOffset + 80.0;
            if ( !showTab ) {
                [self showWeather];
                showTab = YES;
            }
        }

        if ( [resortData.data objectForKey:@"traffic"] != nil ) {
            UIButton *trafficButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [trafficButton addTarget:self
                              action:@selector(showTraffic)
                    forControlEvents:UIControlEventTouchDown];
            [trafficButton setTitle:[[resortData.data objectForKey:@"traffic"] objectForKey:@"title"] forState:UIControlStateNormal];
            trafficButton.frame = CGRectMake(xOffset, 80.0, 60.0, 40.0);
            [[self view] addSubview:trafficButton];
            xOffset = xOffset + 80.0;
            if ( !showTab ) {
                [self showTraffic];
                showTab = YES;
            }
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Areas", @"Areas");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

- (BOOL)splitViewController:(UISplitViewController *)splitController shouldHideViewController:(UIViewController *)viewController inOrientation:(UIInterfaceOrientation)orientation
{
    return NO;
}

# pragma mark - show various tabs

-(void)showTraffic {
    [_myView removeFromSuperview];

    UIView *overallView = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - kDetailDisplayWidth + 20.0) / 2, 120.0, 200.0, 400.0)];
    SCSnowContentView *thisView = [[SCSnowContentView alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 100.0)];
    SCResortData *resortData = self.detailItem;
    NSDictionary *trafficData = [resortData.data objectForKey:@"traffic"];
    [thisView setViewData:[trafficData objectForKey:@"body"]];
    [thisView createViewContents];
    [overallView addSubview:thisView];
    _myView = overallView;
    [[self view] addSubview:_myView];
    
}

-(void)showWeather {
    [_myView removeFromSuperview];
    UIView *overallView = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - kDetailDisplayWidth + 20.0) / 2, 120.0, 200.0, 400.0)];

    SCSnowContentView *thisView = [[SCSnowContentView alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 100.0)];
    SCResortData *resortData = self.detailItem;
    NSArray *weatherDays = [[resortData.data objectForKey:@"weather"] objectForKey:@"tabs"];
    NSArray *trafficData = [weatherDays objectAtIndex:resortData.activeWeatherDay];
    [thisView setViewData:trafficData];
    [thisView createViewContents];
    [overallView addSubview:thisView];

    if( resortData.activeWeatherDay + 1 < [weatherDays count] ) {
        UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [nextButton addTarget:self
                       action:@selector(nextWeather)
             forControlEvents:UIControlEventTouchDown];
        [nextButton setTitle:@">" forState:UIControlStateNormal];
        [nextButton.titleLabel setFont:[UIFont boldSystemFontOfSize:24.f]];
        nextButton.frame = CGRectMake(overallView.frame.size.width - 60.0, 10.0, 60.0, 40.0);
        [overallView addSubview:nextButton];
    }

    if( resortData.activeWeatherDay > 0 ) {
        UIButton *prevButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [prevButton addTarget:self
                       action:@selector(prevWeather)
             forControlEvents:UIControlEventTouchDown];
        [prevButton setTitle:@"<" forState:UIControlStateNormal];
        [prevButton.titleLabel setFont:[UIFont boldSystemFontOfSize:24.f]];
        prevButton.frame = CGRectMake(0.0, 10.0, 60.0, 40.0);
        [overallView addSubview:prevButton];
    }

    _myView = overallView;

    [[self view] addSubview:_myView];
    
}

-(void)showSnow {
    [_myView removeFromSuperview];
    UIView *overallView = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - kDetailDisplayWidth + 20.0) / 2, 120.0, 200.0, 400.0)];
    SCSnowContentView *thisView = [[SCSnowContentView alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 100.0)];
    SCResortData *resortData = self.detailItem;
    NSDictionary *trafficData = [resortData.data objectForKey:@"conditions"];
    [thisView setViewData:[trafficData objectForKey:@"body"]];
    [thisView createViewContents];
    [overallView addSubview:thisView];
    _myView = overallView;
    [[self view] addSubview:_myView];
}

-(void)nextWeather {
    SCResortData *resortData = self.detailItem;
    resortData.activeWeatherDay++;
    [self showWeather];
}

-(void)prevWeather {
    SCResortData *resortData = self.detailItem;
    resortData.activeWeatherDay--;
    [self showWeather];
}

@end
