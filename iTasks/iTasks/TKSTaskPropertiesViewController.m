//
//  TKSTaskPropertiesViewController.m
//  iTasks
//
//  Created by Cale Bierman on 4/7/14.
//  Copyright (c) 2014 Dylan Thiemann. All rights reserved.
//

#import "TKSTaskPropertiesViewController.h"

@interface TKSTaskPropertiesViewController ()

@end

@implementation TKSTaskPropertiesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(IBAction)userHitDone:(id)sender {
    
}




- (void)viewDidLoad
{
    //Do NSUserDefault stuff here
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = self.titleText;
    self.descriptionLabel.text = self.descriptionText;
    
    // Formats the expiration date as month-day-year
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yyyy"];
    self.dateLabel.text = [formatter stringFromDate:self.date];
}




@end
