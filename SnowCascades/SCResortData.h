//
//  SCResortData.h
//  SnowCascades
//
//  Created by Rob Smith on 11/8/13.
//  Copyright (c) 2013 SnowCascades. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCResortData : NSObject

@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSDictionary *data;

@property (strong, nonatomic) NSString *snowTitle;
@property (strong, nonatomic) NSString *snowBody;

@property (strong, nonatomic) NSString *trafficTitle;
@property (strong, nonatomic) NSString *trafficBody;

@property (strong, nonatomic) NSString *weatherTitle;
@property (strong, nonatomic) NSString *weatherBody;

- (id)initWithName:(NSString *)name;

- (id)initWithData:(NSDictionary *)data;

- (id)getSnowView;
- (id)getTrafficView;
- (id)getWeatherView;

@end
