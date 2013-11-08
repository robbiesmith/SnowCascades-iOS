//
//  SCMasterViewController.h
//  SnowCascades
//
//  Created by Rob Smith on 11/8/13.
//  Copyright (c) 2013 SnowCascades. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCDetailViewController;

@interface SCMasterViewController : UITableViewController

@property (strong, nonatomic) SCDetailViewController *detailViewController;

@end
