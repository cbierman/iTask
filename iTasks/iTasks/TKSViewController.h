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

@interface TKSViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong,nonatomic) NSMutableArray *tasksList;


@end
