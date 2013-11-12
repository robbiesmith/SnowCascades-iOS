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

- (id)getSnowView {
    NSMutableString *contents = [[NSMutableString alloc] init];
    
    NSArray *snowItems = [[_data objectForKey:@"conditions"] objectForKey:@"body"];
    for( NSDictionary *item in snowItems) {
        [contents appendString:[item objectForKey:@"header"]];
        [contents appendString:[item objectForKey:@"text"]];
    }
    UILabel *snowView = [[UILabel alloc] init];
    snowView.text = contents;
    snowView.frame = CGRectMake(100.0, 120.0, 200.0, 400.0);
    
    return snowView;
}

- (id)getWeatherView {
    NSMutableString *contents = [[NSMutableString alloc] init];
    
    NSArray *weatherDays = [[_data objectForKey:@"weather"] objectForKey:@"tabs"];
    for( NSArray *weatherDay in weatherDays) {
        for ( NSDictionary *item in weatherDay) {
            if([item objectForKey:@"icon"]){
                continue;
            }
            [contents appendString:[item objectForKey:@"header"]];
            [contents appendString:[item objectForKey:@"text"]];
            break;
        }
    }
    UILabel *weatherView = [[UILabel alloc] init];
    weatherView.text = contents;
    weatherView.frame = CGRectMake(100.0, 120.0, 200.0, 400.0);
    
    return weatherView;
}

- (id)getTrafficView {
    NSMutableString *contents = [[NSMutableString alloc] init];
    
    NSArray *trafficItems = [[_data objectForKey:@"traffic"] objectForKey:@"body"];
    for( NSDictionary *item in trafficItems) {
        [contents appendString:[item objectForKey:@"header"]];
        [contents appendString:[item objectForKey:@"text"]];
    }
    UILabel *trafficView = [[UILabel alloc] init];
    trafficView.text = contents;
    trafficView.frame = CGRectMake(100.0, 120.0, 200.0, 400.0);
    
    return trafficView;
}


@end
