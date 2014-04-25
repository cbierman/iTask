//
//  TKSAppSettingsViewController.h
//  iTasks
//
//  Created by Asmaa Elkeurti on 4/25/14.
//  Copyright (c) 2014 Dylan Thiemann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKSAppSettingsViewController : UITableViewController {
   
    
}
@property BOOL isDriving;
@property NSTimeInterval checkInFrequency;
@property NSInteger *walkingRadius;
@property NSInteger *drivingRadius;

+ (id)sharedManager;



@end
