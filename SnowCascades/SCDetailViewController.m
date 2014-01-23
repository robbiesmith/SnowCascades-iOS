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

#import "AsyncImageView.h"

#define kDetailDisplayWidth 240.0
#define kButtonOffset 80.0

@interface SCDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (strong, nonatomic) UIView *myView;
@property (strong, nonatomic) AsyncImageView *lImageView;
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

        SCResortData *resortData = self.detailItem;
        bool showTab = NO;
        self.lImageView = [[AsyncImageView alloc] init];
        
        if ( [resortData.data objectForKey:@"logo"] != nil ) {
            self.lImageView.contentMode = UIViewContentModeScaleAspectFit;
            self.lImageView.clipsToBounds = YES;
            self.lImageView.tag = 1;
            
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:self.lImageView];
            self.lImageView.imageURL =[NSURL URLWithString:[resortData.data objectForKey:@"logo"]];
            self.lImageView.translatesAutoresizingMaskIntoConstraints = NO;

            [[self view] addSubview:self.lImageView];

            [[self view] addConstraint:[NSLayoutConstraint
                                        constraintWithItem:self.lImageView attribute:NSLayoutAttributeTop relatedBy:0 toItem:[self view] attribute:NSLayoutAttributeTop multiplier:1 constant:60.0]];
            
            [[self view] addConstraint:[NSLayoutConstraint
                                        constraintWithItem:self.lImageView attribute:NSLayoutAttributeCenterX relatedBy:0 toItem:[self view] attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
            
            [[self lImageView] addConstraint:[NSLayoutConstraint
                                              constraintWithItem:self.lImageView attribute:NSLayoutAttributeWidth relatedBy:0 toItem:nil attribute:0 multiplier:1 constant:90.0]];
            
            [[self lImageView] addConstraint:[NSLayoutConstraint
                                              constraintWithItem:self.lImageView attribute:NSLayoutAttributeHeight relatedBy:0 toItem:nil attribute:0 multiplier:1 constant:60.0]];
        }
        
        if ( [resortData.data objectForKey:@"conditions"] != nil ) {
            UIButton *snowButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [snowButton addTarget:self
                           action:@selector(showSnow)
                 forControlEvents:UIControlEventTouchDown];
            [snowButton setTitle:[[resortData.data objectForKey:@"conditions"] objectForKey:@"title"] forState:UIControlStateNormal];
            //snowButton.frame = CGRectMake(xOffset, 80.0, 60.0, 40.0);
            [[self view] addSubview:snowButton];

            snowButton.translatesAutoresizingMaskIntoConstraints = NO;
            
            [[self view] addConstraint:[NSLayoutConstraint
                                        constraintWithItem:snowButton attribute:NSLayoutAttributeTop relatedBy:0 toItem:self.lImageView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];

            [[self view] addConstraint:[NSLayoutConstraint
                                        constraintWithItem:snowButton attribute:NSLayoutAttributeCenterX relatedBy:0 toItem:[self view] attribute:NSLayoutAttributeCenterX multiplier:1 constant:-kButtonOffset]];
            
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

            [[self view] addSubview:weatherButton];

            weatherButton.translatesAutoresizingMaskIntoConstraints = NO;
            
            [[self view] addConstraint:[NSLayoutConstraint
                                        constraintWithItem:weatherButton attribute:NSLayoutAttributeTop relatedBy:0 toItem:self.lImageView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
            
            [[self view] addConstraint:[NSLayoutConstraint
                                        constraintWithItem:weatherButton attribute:NSLayoutAttributeCenterX relatedBy:0 toItem:[self view] attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];

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

            [[self view] addSubview:trafficButton];
            
            trafficButton.translatesAutoresizingMaskIntoConstraints = NO;
            
            [[self view] addConstraint:[NSLayoutConstraint
                                        constraintWithItem:trafficButton attribute:NSLayoutAttributeTop relatedBy:0 toItem:self.lImageView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
            
            [[self view] addConstraint:[NSLayoutConstraint
                                        constraintWithItem:trafficButton attribute:NSLayoutAttributeCenterX relatedBy:0 toItem:[self view] attribute:NSLayoutAttributeCenterX multiplier:1 constant:kButtonOffset]];

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

    UIScrollView *overallView = [UIScrollView new];
    SCSnowContentView *thisView = [[SCSnowContentView alloc] initWithFrame:CGRectMake(0.0, 0.0, kDetailDisplayWidth, 800.0)];
    SCResortData *resortData = self.detailItem;
    NSDictionary *trafficData = [resortData.data objectForKey:@"traffic"];
    [thisView setViewData:[trafficData objectForKey:@"body"]];
    [thisView createViewContents];
    [overallView addSubview:thisView];
    overallView.showsHorizontalScrollIndicator = YES;
    overallView.scrollEnabled = YES;
    overallView.userInteractionEnabled = YES;
    overallView.translatesAutoresizingMaskIntoConstraints = NO;
    _myView = overallView;
    [[self view] addSubview:_myView];
    
    [[self view] addConstraint:[NSLayoutConstraint
                                constraintWithItem:_myView attribute:NSLayoutAttributeBottom relatedBy:0 toItem:[self view] attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];

    [[self view] addConstraint:[NSLayoutConstraint
                                constraintWithItem:_myView attribute:NSLayoutAttributeTop relatedBy:0 toItem:[self lImageView] attribute:NSLayoutAttributeBottom multiplier:1 constant:30]];
    
    [[self view] addConstraint:[NSLayoutConstraint
                                constraintWithItem:_myView attribute:NSLayoutAttributeCenterX relatedBy:0 toItem:[self view] attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];

    [overallView addConstraint:[NSLayoutConstraint
                                constraintWithItem:_myView attribute:NSLayoutAttributeWidth relatedBy:0 toItem:nil attribute:0 multiplier:1 constant:kDetailDisplayWidth]];

    overallView.contentSize = thisView.frame.size;
}

-(void)showWeather {
    [_myView removeFromSuperview];
    UIScrollView *overallView = [UIScrollView new];

    SCSnowContentView *thisView = [[SCSnowContentView alloc] initWithFrame:CGRectMake(0.0, 0.0, kDetailDisplayWidth, 400.0)];
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
        [thisView addSubview:nextButton];
        nextButton.translatesAutoresizingMaskIntoConstraints = NO;
        [thisView addConstraint:[NSLayoutConstraint
                                    constraintWithItem:thisView attribute:NSLayoutAttributeTop relatedBy:0 toItem:nextButton attribute:NSLayoutAttributeTop multiplier:1 constant:0]];

        [thisView addConstraint:[NSLayoutConstraint
                                    constraintWithItem:thisView attribute:NSLayoutAttributeRight relatedBy:0 toItem:nextButton attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    }

    if( resortData.activeWeatherDay > 0 ) {
        UIButton *prevButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [prevButton addTarget:self
                       action:@selector(prevWeather)
             forControlEvents:UIControlEventTouchDown];
        [prevButton setTitle:@"<" forState:UIControlStateNormal];
        [prevButton.titleLabel setFont:[UIFont boldSystemFontOfSize:24.f]];
        [thisView addSubview:prevButton];
        prevButton.translatesAutoresizingMaskIntoConstraints = NO;
        [thisView addConstraint:[NSLayoutConstraint
                                    constraintWithItem:thisView attribute:NSLayoutAttributeTop relatedBy:0 toItem:prevButton attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        
        [thisView addConstraint:[NSLayoutConstraint
                                    constraintWithItem:thisView attribute:NSLayoutAttributeLeft relatedBy:0 toItem:prevButton attribute:NSLayoutAttributeLeft multiplier:1 constant:0.0]];
    }

    overallView.showsHorizontalScrollIndicator = YES;
    overallView.scrollEnabled = YES;
    overallView.userInteractionEnabled = YES;
    overallView.translatesAutoresizingMaskIntoConstraints = NO;

    _myView = overallView;

    [[self view] addSubview:_myView];

    [[self view] addConstraint:[NSLayoutConstraint
                                constraintWithItem:_myView attribute:NSLayoutAttributeBottom relatedBy:0 toItem:[self view] attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint
                                constraintWithItem:_myView attribute:NSLayoutAttributeTop relatedBy:0 toItem:[self lImageView] attribute:NSLayoutAttributeBottom multiplier:1 constant:30]];
    
    [[self view] addConstraint:[NSLayoutConstraint
                                constraintWithItem:_myView attribute:NSLayoutAttributeCenterX relatedBy:0 toItem:[self view] attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [overallView addConstraint:[NSLayoutConstraint
                                constraintWithItem:_myView attribute:NSLayoutAttributeWidth relatedBy:0 toItem:nil attribute:0 multiplier:1 constant:kDetailDisplayWidth]];

    overallView.contentSize = thisView.frame.size;

}

-(void)showSnow {
    [_myView removeFromSuperview];
    UIScrollView *overallView = [UIScrollView new];

    SCSnowContentView *thisView = [[SCSnowContentView alloc] initWithFrame:CGRectMake(0.0, 0.0, kDetailDisplayWidth, 400.0)];
    SCResortData *resortData = self.detailItem;
    NSDictionary *trafficData = [resortData.data objectForKey:@"conditions"];
    [thisView setViewData:[trafficData objectForKey:@"body"]];
    [thisView createViewContents];
    [overallView addSubview:thisView];

    overallView.showsHorizontalScrollIndicator = YES;
    overallView.scrollEnabled = YES;
    overallView.userInteractionEnabled = YES;
    overallView.translatesAutoresizingMaskIntoConstraints = NO;

    _myView = overallView;
    [[self view] addSubview:_myView];

    [[self view] addConstraint:[NSLayoutConstraint
                                constraintWithItem:_myView attribute:NSLayoutAttributeBottom relatedBy:0 toItem:[self view] attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    [[self view] addConstraint:[NSLayoutConstraint
                                constraintWithItem:_myView attribute:NSLayoutAttributeTop relatedBy:0 toItem:[self lImageView] attribute:NSLayoutAttributeBottom multiplier:1 constant:30]];
    
    [[self view] addConstraint:[NSLayoutConstraint
                                constraintWithItem:_myView attribute:NSLayoutAttributeCenterX relatedBy:0 toItem:[self view] attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [overallView addConstraint:[NSLayoutConstraint
                                constraintWithItem:_myView attribute:NSLayoutAttributeWidth relatedBy:0 toItem:nil attribute:0 multiplier:1 constant:kDetailDisplayWidth]];
    overallView.contentSize = thisView.frame.size;

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
