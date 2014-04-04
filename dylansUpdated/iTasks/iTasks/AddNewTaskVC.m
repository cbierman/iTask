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
@property (strong,nonatomic) Task *completeTask;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *completingSearchIndicator;

@end

@implementation AddNewTaskVC

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

-(void)performSearch {
    // activate search inidicator
    [self.completingSearchIndicator startAnimating];
    self.completingSearchIndicator.hidesWhenStopped = YES;
    self.doneButton.enabled = NO;
    self.cancelButton.enabled = NO;
    
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
         NSLog(@"%lu",(unsigned long)placemarks.count);
         
         // save results in an instance variable
         self.searchResults = placemarks;
         
         // reactivate everything!
         [self.completingSearchIndicator stopAnimating];
         self.doneButton.enabled = YES;
         self.cancelButton.enabled = YES;
     }];
    
    
}
/*
- (IBAction)method1Pressed:(UIButton *)sender {
    DetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier: @"childVC"];
    detailVC.delegate = self;
    detailVC.labelTextToDisplay = @"Method 1 pressed";
    [self presentViewController:detailVC animated:YES completion:Nil];
}
*/

- (void) showSearchResults {
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// If user hits "Cance", just go back to home screen
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
    // we remove all current annotations on map
    [self.mapHandle removeAnnotations:[self.mapHandle annotations]];
    // and if we have search items, pertaining to our search, we update map annotations
    if (self.mapHandle.annotations.count > 0)
        [self.mapHandle addAnnotations:self.searchResults];
    
    // Then mimic a cancel because we have yet to add an item
    [self.delegate AddNewTaskViewControllerDidCancel:self];
}
@end
