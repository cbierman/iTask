//
//  Task.h
//  iTasks
//
//  Created by Dylan Thiemann on 3/31/14.
//  Copyright (c) 2014 Dylan Thiemann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface Task : NSObject

@property (strong,nonatomic) NSString *title;
@property (strong, nonatomic) UILocalNotification *taskNotification;
@property (strong,nonatomic) NSString *description;
@property (nonatomic, strong) NSMutableArray *otherLocations;
@property (nonatomic, strong) NSDate *taskExpirationDate;
-(void) addLocationToList:(MKMapItem *)location;
-(NSMutableDictionary *) convertTaskToDictionary;

@end
