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

- (IBAction)unwindFromViewController:(UIStoryboardSegue *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidLoad
{
    //Do NSUserDefault stuff here
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}




@end
