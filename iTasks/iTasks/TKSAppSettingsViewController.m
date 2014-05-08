//
//  TKSAppSettingsViewController.m
//  iTasks
//
//  Created by Asmaa Elkeurti on 4/25/14.
//  Copyright (c) 2014 Dylan Thiemann. All rights reserved.
//

#import "TKSAppSettingsViewController.h"

@interface TKSAppSettingsViewController ()
@property (strong, nonatomic) IBOutlet UISegmentedControl *isWalking;
@property (strong, nonatomic) IBOutlet UITextField *drivingRadius;
@property (strong, nonatomic) IBOutlet UITextField *walkingRadius;
@property (strong, nonatomic) IBOutlet UITextField *checkInFrequency;
@property (nonatomic) CGRect originalCenter;

@end

static TKSAppSettingsViewController *sharedMyManager = nil;

@implementation TKSAppSettingsViewController



- (IBAction)walkingRadiusEditingEnded:(id)sender {
    [sender resignFirstResponder];
}


- (IBAction)maxDrivingRadiusEditingEnded:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)checkInFrequencyBeginEditing:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    self.view.frame = CGRectMake(0,-90,320,400);
    [UIView commitAnimations];
    
}

- (IBAction)checkInFrequency:(id)sender {
    [sender resignFirstResponder];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    self.view.frame = self.originalCenter;
    [UIView commitAnimations];
}

- (IBAction)donePressed:(id)sender {
    NSMutableDictionary *userSettings = [[[NSUserDefaults standardUserDefaults] objectForKey:@"iTasks Settings" ] mutableCopy];
    NSNumber *walkingRad = [NSNumber numberWithInt:[self.walkingRadius.text intValue]];
    NSNumber *drivingRadius = [NSNumber numberWithInt:[self.drivingRadius.text intValue]];
    
    NSNumber *checkInFrequency = [NSNumber numberWithLong:[self.checkInFrequency.text integerValue]*3600];
    [userSettings setObject:walkingRad forKey:@"walkingRadius"];
    [userSettings setObject:drivingRadius forKey:@"drivingRadius"];
    [userSettings setObject:checkInFrequency forKey:@"checkInFrequency"];
    [[NSUserDefaults standardUserDefaults] setObject:userSettings forKey:@"iTasks Settings"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.delegate AppSettingsViewControllerDidFinish:self];
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.originalCenter = self.view.frame;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(IBAction)cancelPressed:(id)sender {
    [self.delegate AppSettingsViewControllerDidCancel:self];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
