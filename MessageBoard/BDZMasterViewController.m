//
//  BDZMasterViewController.m
//  MessageBoard
//
//  Created by Dan Zhang on 11/11/12.
//  Copyright (c) 2012 Dan Zhang. All rights reserved.
//

#import "BDZMasterViewController.h"

#import "BDZDetailViewController.h"

@interface BDZMasterViewController () {
    NSMutableArray *_objects;
    NSMutableData *_data;
}
@end

@implementation BDZMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //Implements a pulldown refresh bar
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshRequestCall) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;

	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    [self refreshRequestCall];
        	
}


//Sets up the method call
-(void)refreshRequestCall {
    //Sets up heroku connection
    NSString *url = @"http://cis195-messages.herokuapp.com/messages";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];

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
    //Creates a new empty object;
    NSMutableDictionary *newPost = [[NSMutableDictionary alloc] init];
    NSDate *currDate = [[NSDate alloc] init];
    [newPost setObject:@"Click to modify" forKey:@"title"];
    [newPost setObject:[currDate description] forKey:@"created_at"];
    [newPost setObject:[currDate description] forKey:@"updated_at"];
    [_objects insertObject:newPost atIndex:0];
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

    NSDictionary *location = _objects[indexPath.row];
    NSString *title = [location objectForKey:@"title"];
    if(title != nil && ![title isKindOfClass:[NSNull class]]) cell.textLabel.text = title;
    NSString *body = [location objectForKey:@"body"];
    if(body != nil && ![body isKindOfClass:[NSNull class]]) cell.detailTextLabel.text = body;
        
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
    

}

#pragma mark - NSURLConnectionDataDelegate methods

/**
 * Here are the NSURLConnectionDataDelegate methods that handle the callbacks.
 * This is mostly primarily and three step process, assuming you get no errors.
 *
 * 1. You receive a response.
 * 2. You receive any number of pieces of data.
 * 3. The connection finishes loading. That is, you are ready to use the combined pieces of data.
 */

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _data = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // Please do something sensible here, like log the error.
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSMutableArray *dictResp = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects addObjectsFromArray:dictResp];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
    NSLog(@"%@", dictResp); // If you want to see what the 4SQ response looks like.
}


@end
