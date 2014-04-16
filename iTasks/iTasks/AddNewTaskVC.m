//
//  AddNewTaskVC.m
//  iTasks
//
//  Created by Dylan Thiemann on 3/31/14.
//  Copyright (c) 2014 Dylan Thiemann. All rights reserved.
//

#import "AddNewTaskVC.h"
#import "SearchResultsVC.h"
#import <CoreLocation/CoreLocation.h>

@interface AddNewTaskVC () <searchVCDelegate>


@property (weak, nonatomic) IBOutlet UITextField *taskName;
@property (strong,nonatomic) NSMutableArray *searchResults;
@property (strong,nonatomic) Task *completeTask;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *completingSearchIndicator;
@property (strong,nonatomic) NSMutableArray *selectedPlaces;
//@property (strong,nonatomic) NSMutableArray *selectedPlacemarks;
@property (weak, nonatomic) IBOutlet UITextField *taskDescription;
@property (weak, nonatomic) IBOutlet UITextField *monthField;
@property (weak, nonatomic) IBOutlet UITextField *dayField;
@property (weak, nonatomic) IBOutlet UITextField *yearField;
@end

@implementation AddNewTaskVC

//- (NSMutableArray *) selectedPlacemarks {
//    if (!_selectedPlacemarks)
//        _selectedPlacemarks = [[NSMutableArray alloc] init];
//    return _selectedPlacemarks;
//}

- (NSArray *) selectedPlaces {
    if (!_selectedPlaces)
        _selectedPlaces = [[NSMutableArray alloc] init];
    return _selectedPlaces;
}

- (NSMutableArray *)searchResults {
    if (!_searchResults) {
        _searchResults = [[NSMutableArray alloc] init];
    }
    return _searchResults;
}

-(UIActivityIndicatorView *)completingSearchIndicator {
    if (!_completingSearchIndicator) {
        _completingSearchIndicator = [[UIActivityIndicatorView alloc] init];
    }
    return _completingSearchIndicator;
}

// Delegate method 1 for returning back to previous view
-(void)SearchResultsControllerDidCancel:(SearchResultsVC *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}
// Delegate mthod 2 for returning back to previous view
- (void) SearchResultsViewController:(SearchResultsVC *)controller didChoosePlace:(NSMutableArray *)selectionList {
    self.selectedPlaces = selectionList;
    [self dismissViewControllerAnimated:YES completion:nil];

}

//Performs the search
-(void)performSearch {
    // activate search inidicator
    [self.completingSearchIndicator startAnimating];
    self.completingSearchIndicator.hidesWhenStopped = YES;
    self.doneButton.enabled = NO;
    self.cancelButton.enabled = NO;
    self.searchButton.enabled = NO;
    
    // Create a search request
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = self.searchText.text;
    
    // adjust the region of search so it is about 5000m x 5000m
    // about 2.5x bigger than viewing region
    // we should allow users to adjust this ****
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.mapHandle.userLocation.location.coordinate, 5000, 5000);;
    request.region = region;
    
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^ (MKLocalSearchResponse *response, NSError *error)
     {  // a block which loads each item into an array for us to use
        // an array of MKMapItem objects
         NSMutableArray *placemarks = [NSMutableArray array];
         for (MKMapItem *item in response.mapItems) {
             [placemarks addObject:item.placemark];
         }
         // just a quick check to see how many returns we are getting
         //NSLog(@"%lu",(unsigned long)placemarks.count);
         
         // save results in an instance variable
         self.searchResults = placemarks;
         
         // reactivate everything!
         [self.completingSearchIndicator stopAnimating];
         self.doneButton.enabled = YES;
         self.cancelButton.enabled = YES;
         self.searchButton.enabled = YES;
     }];
}

-(NSDate *) createDateFromTexFieldWithDay: (NSString *)day withMonth: (NSString *)month withYear:(NSString *)year  {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:[day integerValue]];
    [components setMonth:[month integerValue]];
    [components setYear:[year integerValue]];
    NSDate *date = [components date];
    return date;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"searchModal"]){
        UINavigationController *navigationController = segue.destinationViewController;
        SearchResultsVC *searchVC = [navigationController viewControllers][0];
        searchVC.delegate = self;
        searchVC.searchResults = self.searchResults;
    }
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
    self.completingSearchIndicator.hidesWhenStopped = YES;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// If user hits "Cancel", just go back to home screen
- (IBAction)cancel:(id)sender {
    [self.delegate AddNewTaskViewControllerDidCancel:self];
}

//When user hits "Return" on keyboard, it performs search function
- (IBAction)textFieldReturn:(id)sender {
    [sender resignFirstResponder];
    [self performSearch];
    
}

// When user hits done...
- (IBAction)done:(id)sender {
    
    Task *newTask = [[Task alloc] init];
    newTask.title = self.taskName.text;
    newTask.description = self.taskDescription.text;
    newTask.otherLocations = self.selectedPlaces;
    [self.delegateTasksList addObject:newTask];
    
    // we remove all current annotations on map
    [self.mapHandle removeAnnotations:[self.mapHandle annotations]];

    NSMutableArray *placemarks = [NSMutableArray array];
    for (MKMapItem *item in (NSArray *)self.selectedPlaces) {
        //NSLog(@"%@",item.name);
        [placemarks addObject:item];
    }

    
    // and if we have search items, pertaining to our search, we update map annotations
    //if (placemarks.count > 0)
    //    [self.mapHandle addAnnotations:placemarks];
    
    // Then mimic a cancel because we have yet to add an item
    [self.delegate AddNewTaskViewControllerDidCancel:self];
}
@end
