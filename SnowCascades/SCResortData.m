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

        _trafficTitle = [[data objectForKey:@"traffic"] objectForKey:@"title"];
        _snowTitle = [[_data objectForKey:@"conditions"] objectForKey:@"title"];
        _weatherTitle = [[_data objectForKey:@"weather"] objectForKey:@"title"];

        NSArray *trafficItems = [[data objectForKey:@"traffic"] objectForKey:@"body"];
        for( NSDictionary *item in trafficItems) {
            _trafficBody = [item objectForKey:@"text"];
        }
    }
    return self;
}


@end
