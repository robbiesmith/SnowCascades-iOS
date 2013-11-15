//
//  SCSnowContentView.m
//  SnowCascades
//
//  Created by Rob Smith on 11/12/13.
//  Copyright (c) 2013 SnowCascades. All rights reserved.
//

#import "SCSnowContentView.h"

#import "AsyncImageView.h"

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
                AsyncImageView *lImageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(20.0, yOffset, 200.0, 400.0)];
                lImageView.contentMode = UIViewContentModeScaleToFill;
                lImageView.clipsToBounds = YES;
                lImageView.tag = 1;
                
                [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:lImageView];
                lImageView.imageURL =[NSURL URLWithString:[item objectForKey:@"icon"]];
                [itemView addSubview:lImageView];
            }
            if ([item objectForKey:@"header"]) {
                UILabel *trafficView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, yOffset, 200.0, 400.0)];
                NSString *contents = [item objectForKey:@"header"];
                trafficView.text = contents;
                yOffset = yOffset + 20.0;
                [itemView addSubview:trafficView];
            }
            if ([item objectForKey:@"text"]) {
                UILabel *trafficView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, yOffset, 200.0, 400.0)];
                NSString *contents =[item objectForKey:@"text"];
                trafficView.text = contents;
                yOffset = yOffset + 20.0;
                [itemView addSubview:trafficView];
            }
        }
        
        [self addSubview:itemView];
    
    }
@end