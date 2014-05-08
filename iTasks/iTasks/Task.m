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




- (NSMutableArray *) others {
    if (!_otherLocations) {
        _otherLocations = [[NSMutableArray alloc] init];
    }
    return _otherLocations;
}

- (void) addLocationToList:(MKMapItem *) location {
    
    [self.otherLocations addObject: location];
    NSLog(@"the other locations count, %d", self.otherLocations.count);

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
        NSString *currentName = [tempMapItem name];
        // Get the placemark
        MKPlacemark *tempPlaceMark = tempMapItem.placemark;
        // Extract Latitude and Longitude from the placemark's coordinate
        CLLocationCoordinate2D tempCoordinates = tempPlaceMark.coordinate;
        NSString *latitude = [NSString stringWithFormat:@"%f", tempCoordinates.latitude];
        NSString *longitude = [NSString stringWithFormat:@"%f", tempCoordinates.longitude];
        // Store them in a dictionary
        

        
        NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
        [tempDictionary setObject:latitude forKey:@"Latitude"];
        [tempDictionary setObject:longitude forKey:@"Longitude"];
        [tempDictionary setObject:currentName forKey:@"Name"];
        // Make the mutable dictionary immutable so it plays nice with NSUserDefaults
        NSDictionary *finalDictionary = [NSDictionary dictionaryWithDictionary:tempDictionary];
        // Add the finalized dictionary to our list of values
        [values addObject:finalDictionary];
        
    }
    
    return values;
}

@end
