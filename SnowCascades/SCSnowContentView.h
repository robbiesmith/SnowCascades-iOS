//
//  SCSnowContentView.h
//  SnowCascades
//
//  Created by Rob Smith on 11/12/13.
//  Copyright (c) 2013 SnowCascades. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCSnowContentView : UIView

@property(weak,nonatomic) NSArray *data;

-(void) setViewData:(NSArray *) data;
- (id)initWithFrame:(CGRect)frame;
-(void)createViewContents;

@end