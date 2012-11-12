//
//  BDZDetailViewController.m
//  MessageBoard
//
//  Created by Dan Zhang on 11/11/12.
//  Copyright (c) 2012 Dan Zhang. All rights reserved.
//

#import "BDZDetailViewController.h"

@interface BDZDetailViewController ()
- (void)configureView;
@end

@implementation BDZDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (IBAction)poster:(UIBarButtonItem *)sender {
    //Post button updates the values in the detail view
    //Also posts to the server
    if(self.detailItem) {

        NSString *url = @"http://cis195-messages.herokuapp.com/messages";
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        
        [request setHTTPMethod:@"POST"];
        
        NSString *data = [NSString stringWithFormat:@"message[title]=%@&message[body]=%@", self.detailDescriptionLabel.text, self.textField.text];
        [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [connection start];
        
        [self.detailItem setObject:self.textField.text forKey:@"body"];
        [self.detailItem setObject:self.detailDescriptionLabel.text forKey:@"title"];
        [self.detailDescriptionLabel resignFirstResponder];
        [self.textField resignFirstResponder];
    }
    

}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        NSString *title = [[self.detailItem objectForKey:@"title"] description];
        if(title != nil && ![title isKindOfClass:[NSNull class]]) {
            self.detailDescriptionLabel.text = title;
        }
        else {
            self.detailDescriptionLabel.text = @"";
        }
        NSString *body = [self.detailItem objectForKey:@"body"];
        if( body != nil && ![body isKindOfClass:[NSNull class]]) {
            self.textField.text = body;
        }
        else {
            self.textField.text = @"";
        }
        NSString *create = @"Created: ";
        NSString *createdDate = [self.detailItem objectForKey:@"created_at"];
        if(createdDate != nil) {
            if([createdDate length] >= 10) {
                createdDate = [createdDate substringToIndex:10];
                self.createdField.text = [create stringByAppendingString:createdDate];
            }
        }
        else {
            self.createdField.text = create;
        }
        NSString *update = @"Updated :";
        NSString *updateTime = [self.detailItem objectForKey:@"updated_at"];
        if(updateTime != nil){
            if([updateTime length] >= 10) {
                updateTime = [updateTime substringToIndex:10];
            }
            self.updatedField.text = [update stringByAppendingString:updateTime];        }
        else {
            self.createdField.text = update;
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
