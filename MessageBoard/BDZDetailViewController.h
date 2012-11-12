//
//  BDZDetailViewController.h
//  MessageBoard
//
//  Created by Dan Zhang on 11/11/12.
//  Copyright (c) 2012 Dan Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDZDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *updatedField;

@property (weak, nonatomic) IBOutlet UILabel *createdField;
@property (weak, nonatomic) IBOutlet UITextView *textField;
@property (weak, nonatomic) IBOutlet UITextField *detailDescriptionLabel;
@end
