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
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *completingSearchIndicator;
@property (strong,nonatomic) NSMutableArray *selectedPlaces;
//@property (strong,nonatomic) NSMutableArray *selectedPlacemarks;
@property (weak, nonatomic) IBOutlet UITextField *taskDescription;
@property (weak, nonatomic) IBOutlet UITextField *monthField;
@property (weak, nonatomic) IBOutlet UITextField *dayField;
@property (weak, nonatomic) IBOutlet UITextField *yearField;
@property (nonatomic) CGRect originalCenter;
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
             [placemarks addObject:item];
         }
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
    self.originalCenter = self.view.frame;
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
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    self.view.frame = self.originalCenter;
    [UIView commitAnimations];
    [self performSearch];
}
- (IBAction)textFieldDidReturn:(id)sender {
    [sender resignFirstResponder];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    self.view.frame = self.originalCenter;
    [UIView commitAnimations];
}
- (IBAction)taskNameDone:(id)sender {
    [sender resignFirstResponder];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    self.view.frame = self.originalCenter;
    [UIView commitAnimations];
}
- (IBAction)desciptionFieldDidBeginEditing:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    self.view.frame = CGRectMake(0,-50,320,400);
    [UIView commitAnimations];
}

// Text fields for the date to control view shifting :-)
- (IBAction)datesEditingDidBegin:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    self.view.frame = CGRectMake(0,-90,320,400);
    [UIView commitAnimations];
}
- (IBAction)datesReturnPressed:(id)sender {
    [sender resignFirstResponder];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    self.view.frame = self.originalCenter;
    [UIView commitAnimations];
}

// When user hits done...
- (IBAction)done:(id)sender {
    // Create a new task, adding the info from the text fields
    Task *newTask = [[Task alloc] init];
    newTask.title = self.taskName.text;
    newTask.description = self.taskDescription.text;
    newTask.otherLocations = [self.selectedPlaces mutableCopy];
   //
    [self.delegateTasksList addObject:newTask];
    
    // Convert the task to a dictionary
    NSDictionary *taskDict = [NSDictionary dictionaryWithDictionary:[newTask convertTaskToDictionary]];
    
    // Load NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // Get our array of task dictionaries from NSUserDefaults
    NSMutableArray *allTasks = [[defaults objectForKey:@"allTasks"] mutableCopy];
    // Add the newly added task to all the tasks
    [allTasks addObject:taskDict];
    // Put all the tasks back into NSUserDefaults
    [defaults setObject:[NSArray arrayWithArray:allTasks] forKey:@"allTasks"];
    // Synchronize
    [defaults synchronize];
    NSLog(@"sycnronized defaults");
    
    // we remove all current annotations on map
    [self.mapHandle removeAnnotations:[self.mapHandle annotations]];

    NSMutableArray *placemarks = [NSMutableArray array];
    
    // Prints the latitude of the object we saved
    for (MKMapItem *item in (NSArray *)self.selectedPlaces) {
        MKPlacemark *thing = item.placemark;
        CLLocationCoordinate2D coords = thing.coordinate;
        NSString *coordinateString = [NSString stringWithFormat:@"%f", coords.latitude];
        [placemarks addObject:item];
    }
    // Then mimic a cancel because we have yet to add an item
    [self.delegate AddNewTaskViewControllerDidCancel:self];
    
    
    //Send a notification when the user is in specified radius
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:60];
    localNotification.alertBody = self.taskName.text;
    localNotification.alertAction = @"See Task";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    localNotification.timeZone = [NSTimeZone localTimeZone];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    // Request to reload table view data
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
    
}

- (void)setMinimumBackgroundFetchInterval:(NSTimeInterval)minimumBackgroundFetchInterval {
    
}


@end
