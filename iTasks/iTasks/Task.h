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
@property (strong,nonatomic) NSString *description;
@property (strong,nonatomic) NSString *address;
@property (nonatomic) CLLocationCoordinate2D location;
@property (nonatomic) CLLocation *testLocal;
@property (nonatomic, strong) NSMutableArray *otherLocations;
@property (nonatomic, strong) NSDate *taskExpirationDate;
@property BOOL isSpecific;
@property BOOL isComplete;

-(void) addLocationToList:(MKMapItem *)location;
-(NSMutableDictionary *) convertTaskToDictionary;

@end
