//
//  TKSAppSettingsViewController.m
//  iTasks
//
//  Created by Asmaa Elkeurti on 4/25/14.
//  Copyright (c) 2014 Dylan Thiemann. All rights reserved.
//

#import "TKSAppSettingsViewController.h"

@interface TKSAppSettingsViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *isWalking;
@property (weak, nonatomic) IBOutlet UITextField *drivingRadius;
@property (weak, nonatomic) IBOutlet UITextField *walkingRadius;
@property (weak, nonatomic) IBOutlet UITextField *checkInFrequency;
@property (nonatomic) CGRect originalCenter;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *completingSearchIndicator;




@end

static TKSAppSettingsViewController *sharedMyManager = nil;

@implementation TKSAppSettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


+(NSUInteger) walkingRadius {
    NSUInteger walkingRad = [sharedMyManager.walkingRadius.text integerValue];
    return walkingRad;
}

+(NSUInteger) drivingRadius {
    NSUInteger drivingRadius = [sharedMyManager.drivingRadius.text integerValue];
    return drivingRadius;
}

+(BOOL) isDriving {
    if(sharedMyManager.isWalking.selectedSegmentIndex == 1){
        return TRUE;
    }else {
        return FALSE;
    }
}

+(NSTimeInterval) checkInFrequency {
    return [sharedMyManager.checkInFrequency.text integerValue]*3600;
}

+ (id)sharedManager {
    @synchronized(self) {
        if(sharedMyManager == nil)
            sharedMyManager = [[super allocWithZone:NULL] init];
    }
    return sharedMyManager;
}

-(UIActivityIndicatorView *)completingSearchIndicator {
    if (!_completingSearchIndicator) {
        _completingSearchIndicator = [[UIActivityIndicatorView alloc] init];
    }
    return _completingSearchIndicator;
}

- (IBAction)maxDrivingRadiusEditingEnded:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)checkInFrequencyBeginEditing:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    self.view.frame = CGRectMake(0,-50,320,400);
    [UIView commitAnimations];
    
}

- (IBAction)checkInFrequency:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    self.view.frame = CGRectMake(0,-90,320,400);
    [UIView commitAnimations];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.originalCenter = self.view.frame;
    self.completingSearchIndicator.hidesWhenStopped = YES;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
