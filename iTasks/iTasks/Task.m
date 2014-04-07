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

- (void) setTitle:(NSString *)title {
    self.title = title;
}

- (void) setDescription:(NSString *)description {
    self.description = description;
}

- (NSMutableArray *) otherLocations {
    if (!_otherLocations) {
        _otherLocations = [[NSMutableArray alloc] init];
    }
    return _otherLocations;
}

- (void) addLocationToList:(CLLocationCoordinate2D *)location {
    [self.otherLocations addObject:(__bridge id)(location)];
}

- (void) removeLocationFromList:(CLLocationCoordinate2D *)location {
    [self.otherLocations removeObject:(__bridge id)(location)];
}

-(NSMutableDictionary *) convertTaskToDictionary {
    NSMutableDictionary *taskDict = [[NSMutableDictionary alloc] init];
    NSMutableArray *locations = [[NSMutableArray alloc] initWithArray:[self convertLocationsToValues:self.otherLocations]];
    [taskDict setObject:self.title forKey:@"Title"];
    [taskDict setObject:self.description forKey:@"Description"];
    [taskDict setObject:locations forKey:@"Locations"];
    return taskDict;
}

-(NSMutableArray *) convertLocationsToValues: (NSMutableArray *) locations {
    NSMutableArray *values = [[NSMutableArray alloc] init];
    for (int i = 0; i < locations.count; i++) {
        CLLocationCoordinate2D *currentLocation = (__bridge CLLocationCoordinate2D *)(locations[i]);
        [values addObject:[NSValue valueWithMKCoordinate:*currentLocation]];
    }
    return values;
}

@end
