//
//  SCResortData.m
//  SnowCascades
//
//  Created by Rob Smith on 11/8/13.
//  Copyright (c) 2013 SnowCascades. All rights reserved.
//

#import "SCResortData.h"

@implementation SCResortData

- (id)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        _name = name;
    }
    return self;
}


- (id)initWithData:(NSDictionary *)data {
    self = [super init];
    if (self) {
        _data = data;

        _name = [data objectForKey:@"name"];
        _imageBase = [data objectForKey:@"imageBase"];
        _activeWeatherDay = 0;
    }
    return self;
}


@end
