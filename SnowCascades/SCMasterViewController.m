//
//  SCMasterViewController.m
//  SnowCascades
//
//  Created by Rob Smith on 11/8/13.
//  Copyright (c) 2013 SnowCascades. All rights reserved.
//

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1
#define kSnowCascadeData [NSURL URLWithString:@"http://snowcascades.com/cascade/data.json"] //2

#import "SCMasterViewController.h"

#import "SCDetailViewController.h"

#import "SCResortData.h"

#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

@interface SCMasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation SCMasterViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dispatch_async(kBgQueue, ^{
        @try {
            NSData* data = [NSData dataWithContentsOfURL:kSnowCascadeData];
            if ( data == nil ) {
                [NSException raise:@"No data from server" format:@""];
            }
            [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES];
            if ( _objects == nil || [_objects count] == 0 ) {
                [NSException raise:@"Bad data from server" format:@""];
            }
        }
        @catch (NSException *e) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"no_data" ofType:@"json"];
            NSData* errorData = [NSData dataWithContentsOfFile:path ];
            [self performSelectorOnMainThread:@selector(fetchedData:)
                                   withObject:errorData waitUntilDone:YES];
        }
    });
	
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker set:kGAIScreenName
           value:@"Master Screen"];
    
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];

    self.detailViewController = (SCDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
    
    NSArray* resorts = [json objectForKey:@"resorts"];
    
    for(NSDictionary *resort in [resorts reverseObjectEnumerator]){
        [self insertNewObject:resort];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    SCResortData *resort = [[SCResortData alloc] initWithData:sender];
    [_objects insertObject:resort atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    SCResortData *object = _objects[indexPath.row];
    cell.textLabel.text = [object name];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //iPad handler
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        SCResortData *object = _objects[indexPath.row];
        self.detailViewController.detailItem = object;
        [self.detailViewController showSnow];

        id tracker = [[GAI sharedInstance] defaultTracker];
        
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
                                                              action:@"button_press"  // Event action (required)
                                                               label:object.name        // Event label
                                                               value:nil] build]];    // Event value
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //iPhone handler
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        SCResortData *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];

        
        id tracker = [[GAI sharedInstance] defaultTracker];
        
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
                                                              action:@"button_press"  // Event action (required)
                                                               label:object.name        // Event label
                                                               value:nil] build]];    // Event value
    }
}

@end
