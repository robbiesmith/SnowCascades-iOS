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

@property (strong, nonatomic) NSString *imageBase;

@property (strong, nonatomic) NSDictionary *data;

@property int activeWeatherDay;

- (id)initWithName:(NSString *)name;

- (id)initWithData:(NSDictionary *)data;

@end
