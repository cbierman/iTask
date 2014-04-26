//
//  TKSAppSettingsViewController.h
//  iTasks
//
//  Created by Asmaa Elkeurti on 4/25/14.
//  Copyright (c) 2014 Dylan Thiemann. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TKSAppSettingsViewController;
@protocol AppSettingsViewControllerDelegate <NSObject>

- (void) AppSettingsViewControllerDidCancel: (TKSAppSettingsViewController *)controller;

@end


@interface TKSAppSettingsViewController : UIViewController

@property (weak, nonatomic) id<AppSettingsViewControllerDelegate> delegate;

+(BOOL) isDriving;
+(NSTimeInterval) checkInFrequency;
+(NSUInteger) walkingRadius;
+(NSUInteger) drivingRadius;

+ (id)sharedManager;



@end
