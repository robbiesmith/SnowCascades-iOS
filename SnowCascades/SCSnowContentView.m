//
//  SCSnowContentView.m
//  SnowCascades
//
//  Created by Rob Smith on 11/12/13.
//  Copyright (c) 2013 SnowCascades. All rights reserved.
//

#import "SCSnowContentView.h"

@implementation SCSnowContentView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setViewData:(NSArray *)newData
{
    self.data = newData;
}

-(void)createViewContents
{
    float yOffset = 0.0;
    UIScrollView *itemView = [[UIScrollView alloc] initWithFrame:CGRectMake(20.0, 80.0, 200.0, 400.0)];
    
    for( NSDictionary *item in self.data) {
        if([item objectForKey:@"icon"]){
            continue;
        } else if ([item objectForKey:@"header"]) {
            UILabel *trafficView = [[UILabel alloc] init];
            NSAttributedString *contents =[item objectForKey:@"header"];
            trafficView.attributedText = contents;
            trafficView.frame = CGRectMake(0.0, yOffset, 200.0, 400.0);
            yOffset = yOffset + 20.0;
            [itemView addSubview:trafficView];
        } else if ([item objectForKey:@"text"]) {
            UILabel *trafficView = [[UILabel alloc] init];
            trafficView.text = [item objectForKey:@"header"];
            trafficView.frame = CGRectMake(0.0, yOffset, 200.0, 400.0);
            yOffset = yOffset + 20.0;
            [itemView addSubview:trafficView];
        }
    }
    
    [self addSubview:itemView];

}
@end
