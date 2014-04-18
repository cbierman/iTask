//
//  Task.m
//  iTasks
//
//  Created by Dylan Thiemann on 3/31/14.
//  Copyright (c) 2014 Dylan Thiemann. All rights reserved.
//

#import "Task.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@implementation Task


- (void) setExpirationDate:(NSDate *)taskExpirationDate {
    self.taskExpirationDate = taskExpirationDate;
}

- (NSMutableArray *) otherLocations {
    if (!_otherLocations) {
        _otherLocations = [[NSMutableArray alloc] init];
    }
    return _otherLocations;
}

- (void) addLocationToList:(MKMapItem *) location {
    
    [self.otherLocations addObject: location];

}


// Returns a dictionary of Task properties
-(NSMutableDictionary *) convertTaskToDictionary {
    NSMutableDictionary *taskDict = [[NSMutableDictionary alloc] init];
    // Convert all locations to lat/longs
    NSMutableArray *locations = [[NSMutableArray alloc] initWithArray:[self convertLocationsToValues:self.otherLocations]];

    [taskDict setObject:self.title forKey:@"Title"];
    [taskDict setObject:self.description forKey:@"Description"];
    [taskDict setObject:locations forKey:@"Locations"];
    [taskDict setObject:self.taskExpirationDate forKey:@"Expiration Date"];
    return taskDict;
}

// Turns all locations into their latitude and longitude values.
-(NSMutableArray *) convertLocationsToValues: (NSMutableArray *) locations {
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < locations.count; i++) {
        MKMapItem *tempMapItem = [locations objectAtIndex:i];
        // Get the placemark
        NSLog(@"Map Item: %@", tempMapItem);

//        MKPlacemark *tempPlaceMark = tempMapItem.placemark;
//        NSLog(@"Placemark: %@", tempPlaceMark);
        // Extract Latitude and Longitude from the placemark's address dictionary
        //NSString *latitude = [[tempPlaceMark addressDictionary] objectForKey:@"latitude"];
        //NSString *longitude = [[tempPlaceMark addressDictionary] objectForKey:@"longitude"];
        
//        NSLog(@"Latitude is : %@", latitude);
//        NSLog(@"Longitude is : %@", longitude);
//        // Store them in an array
//        NSArray *tempArray = [[NSArray alloc] initWithObjects:latitude, longitude, nil];
//        
//        [values addObject:tempArray];
        
    }
    return values;
}

@end
