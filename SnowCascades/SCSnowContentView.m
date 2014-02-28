//
//  SCSnowContentView.m
//  SnowCascades
//
//  Created by Rob Smith on 11/12/13.
//  Copyright (c) 2013 SnowCascades. All rights reserved.
//

#import "SCSnowContentView.h"

#import "AsyncImageView.h"

@implementation SCSnowContentView {
    NSMutableArray *links;
}


- (id)initWithFrame:(CGRect)frame
{
        self = [super initWithFrame:frame];
        if (self) {
            // Initialization code
        }
        return self;
    }

- (void)setViewData:(NSArray *)newData
{
    self.data = newData;
    links = [[NSMutableArray alloc] init];
}

-(void)createViewContents
{
        float yOffset = 0.0;
        UIScrollView *itemView = [[UIScrollView alloc] initWithFrame:[self frame]];
    
        for( NSDictionary *item in self.data) {
            if([item objectForKey:@"icon"]){
                AsyncImageView *lImageView = [[AsyncImageView alloc] initWithFrame:CGRectMake( (itemView.frame.size.width - 55.0 ) / 2, yOffset, 55.0, 58.0)];
                lImageView.contentMode = UIViewContentModeScaleToFill;
                lImageView.clipsToBounds = YES;
                lImageView.tag = 1;
                
                [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:lImageView];
                lImageView.imageURL =[NSURL URLWithString:[item objectForKey:@"icon"]];
                [itemView addSubview:lImageView];
                
                yOffset = yOffset + 60.0;
            }
            if ([item objectForKey:@"header"]) {

                if ( yOffset > 0 ) {
                    yOffset = yOffset + 10.0;
                }
                UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, yOffset, 200.0, 20.0)];
                [headerLabel setFont:[UIFont boldSystemFontOfSize:headerLabel.font.pointSize]];
                headerLabel.lineBreakMode = NSLineBreakByWordWrapping;
                [headerLabel setNumberOfLines:0];
                headerLabel.text = [item objectForKey:@"header"];
                [headerLabel sizeToFit];

                yOffset = yOffset + headerLabel.frame.size.height;
                [itemView addSubview:headerLabel];
            }
            if ([item objectForKey:@"text"]) {
                UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, yOffset, 200.0, 20.0)];
                textLabel.lineBreakMode = NSLineBreakByWordWrapping;
                [textLabel setNumberOfLines:0];
                textLabel.text = [item objectForKey:@"text"];
                [textLabel sizeToFit];
                
                yOffset = yOffset + textLabel.frame.size.height;
                [itemView addSubview:textLabel];
            }
            if ([item objectForKey:@"linktext"] && [item objectForKey:@"link"] ) {
                UILabel *linkLabel = [[UILabel alloc] init];
                linkLabel.lineBreakMode = NSLineBreakByWordWrapping;
                [linkLabel setNumberOfLines:0];
                linkLabel.text = [item objectForKey:@"linktext"];
                [linkLabel sizeToFit];
                UIButton *linkButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, yOffset, 200.0, 20.0)];
                [linkButton addSubview:linkLabel];
                [linkButton addTarget:self action:@selector(openLink:) forControlEvents:UIControlEventTouchUpInside];
                [linkLabel setTextColor:[UIColor darkGrayColor]];
                [linkButton setTag:[links count]];
                [links addObject:[item objectForKey:@"link"]];
                
                
                yOffset = yOffset + linkLabel.frame.size.height;
                [itemView addSubview:linkButton];
            }
        }
        [self addSubview:itemView];
        [self setFrame:CGRectMake( self.frame.origin.x, self.frame.origin.y, self.frame.size.width, yOffset )];
}

-(void)openLink:(UIButton*)sender {
    int index = sender.tag;
    NSString *chosenLink = [links objectAtIndex:index];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: chosenLink]];
}
@end