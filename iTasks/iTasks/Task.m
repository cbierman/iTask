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

@end
