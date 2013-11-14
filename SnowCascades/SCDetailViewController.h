//
//  SCDetailViewController.h
//  SnowCascades
//
//  Created by Rob Smith on 11/8/13.
//  Copyright (c) 2013 SnowCascades. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SCResortData.h"

@interface SCDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (weak, nonatomic) SCResortData *detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
