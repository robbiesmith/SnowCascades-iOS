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
        UIScrollView *itemView = [[UIScrollView alloc] initWithFrame:[self frame]];
    
        for( NSDictionary *item in self.data) {
            if([item objectForKey:@"icon"]){
                AsyncImageView *lImageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(20.0, yOffset, 55.0, 58.0)];
                lImageView.contentMode = UIViewContentModeScaleToFill;
                lImageView.clipsToBounds = YES;
                lImageView.tag = 1;
                
                [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:lImageView];
                lImageView.imageURL =[NSURL URLWithString:[item objectForKey:@"icon"]];
                [itemView addSubview:lImageView];
                
                yOffset = yOffset + 60.0;
            }
            if ([item objectForKey:@"header"]) {

                UILabel *trafficView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, yOffset, 200.0, 20.0)];
                [trafficView setFont:[UIFont boldSystemFontOfSize:trafficView.font.pointSize]];
                trafficView.lineBreakMode = NSLineBreakByWordWrapping;
                [trafficView setNumberOfLines:0];
                trafficView.text = [item objectForKey:@"header"];
                [trafficView sizeToFit];

                yOffset = yOffset + trafficView.frame.size.height;
                [itemView addSubview:trafficView];
            }
            if ([item objectForKey:@"text"]) {
                UILabel *trafficView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, yOffset, 200.0, 20.0)];
                trafficView.lineBreakMode = NSLineBreakByWordWrapping;
                [trafficView setNumberOfLines:0];
                trafficView.text = [item objectForKey:@"text"];
                [trafficView sizeToFit];

                yOffset = yOffset + trafficView.frame.size.height;
                [itemView addSubview:trafficView];
            }
        }
        
        [self addSubview:itemView];
    
    }
@end