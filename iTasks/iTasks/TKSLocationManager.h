//
//  TKSLocationManager.h
//  iTasks
//
//  Created by Cale Bierman on 4/25/14.
//  Copyright (c) 2014 Dylan Thiemann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface TKSLocationManager : NSObject

@property(strong,nonatomic) CLLocationManager *manager;

@end
