//
//  SearchResultsVC.h
//  iTasks
//
//  Created by Dylan Thiemann on 4/3/14.
//  Copyright (c) 2014 Dylan Thiemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@class SearchResultsVC;
@protocol searchVCDelegate <NSObject>

- (void)SearchResultsControllerDidCancel:(SearchResultsVC *)controller;
- (void)SearchResultsViewController:(SearchResultsVC *)controller didChoosePlace:(MKMapItem *)mapItem;

@end

@interface SearchResultsVC : UIViewController

@property (weak,nonatomic) id<searchVCDelegate> delegate;
@property (strong,nonatomic) NSArray *searchResults;

- (IBAction)cancelPressed:(id)sender;

@end
