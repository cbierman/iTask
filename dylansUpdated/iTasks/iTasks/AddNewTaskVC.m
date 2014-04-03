//
//  AddNewTaskVC.m
//  iTasks
//
//  Created by Dylan Thiemann on 3/31/14.
//  Copyright (c) 2014 Dylan Thiemann. All rights reserved.
//

#import "AddNewTaskVC.h"

@interface AddNewTaskVC ()

@property (strong,nonatomic) NSMutableArray *searchResults;

@end

@implementation AddNewTaskVC

- (NSMutableArray *)searchResults {
    if (!_searchResults) {
        _searchResults = [[NSMutableArray alloc] init];
    }
    return _searchResults;
}

-(void)performSearch {
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = self.searchText.text;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.mapHandle.userLocation.location.coordinate, 5000, 5000);;
    request.region = region;
    
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^ (MKLocalSearchResponse *response, NSError *error)
     {
         NSMutableArray *placemarks = [NSMutableArray array];
         for (MKMapItem *item in response.mapItems) {
             [placemarks addObject:item.placemark];
         }
         [self.mapHandle removeAnnotations:[self.mapHandle annotations]];
         [self.mapHandle addAnnotations:placemarks];
     }];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)sender:(id)sender {
    [self.delegate AddNewTaskViewControllerDidCancel:self];
}

- (IBAction)textFieldReturn:(id)sender {
    [sender resignFirstResponder];
    [self performSearch];
}
@end
