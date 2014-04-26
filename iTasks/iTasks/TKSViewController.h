//
//  TKSViewController.h
//  iTasks
//
//  Created by Dylan Thiemann on 3/27/14.
//  Copyright (c) 2014 Dylan Thiemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TKSTaskPropertiesViewController.h"
#import "TKSAppSettingsViewController.h"
@interface TKSViewController : UIViewController <MKMapViewDelegate, TaskPropertiesViewControllerDelagate, AppSettingsViewControllerDelegate, CLLocationManagerDelegate>

-(void) AppSettingsViewControllerDidCancel:(TKSAppSettingsViewController *)controller;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong,nonatomic) NSMutableArray *tasksList;
@property (strong,nonatomic) CLLocationManager *manager;

@end
