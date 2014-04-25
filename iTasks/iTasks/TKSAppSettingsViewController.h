//
//  TKSAppSettingsViewController.h
//  iTasks
//
//  Created by Asmaa Elkeurti on 4/25/14.
//  Copyright (c) 2014 Dylan Thiemann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKSAppSettingsViewController : UITableViewController {
    NSInteger *walkingRadius;
    NSInteger *drivingRadius;
    
}
@property BOOL isDriving;

+(id)sharedManager;



@end
