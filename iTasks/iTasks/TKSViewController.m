//
//  TKSViewController.m
//  iTasks
//
//  Created by Dylan Thiemann on 3/27/14.
//  Copyright (c) 2014 Dylan Thiemann. All rights reserved.
//

#import "TKSViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "AddNewTaskVC.h"
#import "Task.h"
#import "TKSTaskPropertiesViewController.h"
#import <MapKit/MapKit.h>
#import "TKSAppSettingsViewController.h"

@interface TKSViewController () <UITableViewDataSource, UITableViewDelegate, AddNewTaskVCDelegate, TaskPropertiesViewControllerDelagate>

//@property (strong, nonatomic) NSMutableArray *notificationArray;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *regionsList;
@end

@implementation TKSViewController

- (NSMutableArray *)tasksList {
    if (!_tasksList) {
        _tasksList = [[NSMutableArray alloc] init];
    }
    return _tasksList;
}

-(NSMutableArray *)regionsList {
    if (!_regionsList) {
        _regionsList = [[NSMutableArray alloc] init];
    }
    
    return _regionsList;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tasksList.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteTaskAtIndex:indexPath.row];
    }
    [self.tableView reloadData];
    
}

- (void) initializeManager {
    if (![CLLocationManager locationServicesEnabled]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"This app requires location services to be enabled to function" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
    
    _manager = [[CLLocationManager alloc] init];
    _manager.delegate = self;
    [self initializeRegionMonitoring: self.regionsList];
}

- (UIImage *)burnTextIntoImage:(NSString *)text :(UIImage *)img {
    
    UIGraphicsBeginImageContext(img.size);
    
    CGRect aRectangle = CGRectMake(0,0, img.size.width/2, img.size.height/2);
    [img drawInRect:aRectangle];
    
    [[UIColor blackColor] set];           // set text color
    NSInteger fontSize = 12;
    if ( [text length] > 200 ) {
        fontSize = 10;
    }
    UIFont *font = [UIFont boldSystemFontOfSize: fontSize]; // set text font
    
    /// Make a copy of the default paragraph style
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    /// Set line break mode
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    /// Set text alignment
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName : font, NSParagraphStyleAttributeName : paragraphStyle};
    [text drawInRect:aRectangle withAttributes:attributes];
    
    UIImage *theImage=UIGraphicsGetImageFromCurrentImageContext();   // extract the image
    UIGraphicsEndImageContext();     // clean  up the context.
    return theImage;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    NSUInteger index = -1;
    CLLocationCoordinate2D coords = [annotation coordinate];
    for (Task *task in self.tasksList) {
        for (MKMapItem *mapItem in task.otherLocations) {
            CLLocationCoordinate2D myCoords = mapItem.placemark.coordinate;
            if ((coords.latitude == myCoords.latitude) && (coords.longitude == myCoords.longitude)) {
                index = [self.tasksList indexOfObject:task];
                break;
            }
        }
        if (index != -1) {
            break;
        }
    }
    if (index != -1) {
        // this part is boilerplate code used to create or reuse a pin annotation
        static NSString *viewId = @"MKPinAnnotationView";
        MKPinAnnotationView *annotationView = (MKPinAnnotationView*)
        [self.mapView dequeueReusableAnnotationViewWithIdentifier:viewId];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc]
                              initWithAnnotation:annotation reuseIdentifier:viewId];
        }
        
        // set your custom image
        UIImage *tempImage = [UIImage imageNamed:@"thumb-orange-circle.png"];
        UIImage *newImage = [self burnTextIntoImage:[NSString stringWithFormat:@"%u",index+1] :tempImage];
        annotationView.image = newImage;
        return annotationView;
    } else {
        return nil;
    }
    //return annotationView;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mapItem"];
    Task *task = [self.tasksList objectAtIndex:indexPath.row];
    cell.textLabel.text = task.title;
    cell.detailTextLabel.text = task.description;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"seeTaskProperties" sender: indexPath];
}
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addNewTask"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        AddNewTaskVC *addNewTaskVC = [navigationController viewControllers][0];
        addNewTaskVC.mapHandle = _mapView;
        addNewTaskVC.delegateTasksList = self.tasksList;
        addNewTaskVC.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:@"seeTaskProperties"]) {
        UINavigationController *navController = segue.destinationViewController;
        // Get the VC of where we're going
        TKSTaskPropertiesViewController *taskProperties = [navController viewControllers][0];
        // Get the index path so we can figure out which task was selected
        NSIndexPath *indexPath = (NSIndexPath *) sender;
        NSInteger selectedCellNumber = indexPath.row;
        
        Task *selectedTask = [self.tasksList objectAtIndex:selectedCellNumber];
        // Set all the properties for use by the Settings VC
        taskProperties.titleText = selectedTask.title;
        taskProperties.descriptionText = selectedTask.description;
        taskProperties.date = selectedTask.taskExpirationDate;
        taskProperties.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:@"appSettingsSegue"]) {
        UINavigationController *navController = segue.destinationViewController;
        TKSAppSettingsViewController *appSettings = [navController viewControllers][0];
        appSettings.delegate = self;
    }
}

- (IBAction)unwindFromViewController:(UIStoryboardSegue *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)AddNewTaskViewControllerDidCancel:(AddNewTaskVC *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)TaskPropertiesViewControllerDidCancel:(id)controller {
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void) AddNewTaskViewController:(AddNewTaskVC *)controller didAddTask:(Task *)newTask {
    NSDictionary *taskDictionary = [newTask convertTaskToDictionary];
    [self mapDictionaryToRegion:taskDictionary];
    
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    _mapView.centerCoordinate = userLocation.location.coordinate;
}

- (void)zoomOnUserLocation {
    MKUserLocation *userLocation = _mapView.userLocation;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 2000, 2000);
    [_mapView setRegion:region animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    [self zoomOnUserLocation];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    NSMutableArray *defaultTasksList = [[[NSUserDefaults standardUserDefaults] objectForKey:@"allTasks"] mutableCopy];
    NSMutableArray *tasksToDelete = [NSMutableArray array];
    // Make sure we have tasks to dispaly before we do anything
    if (defaultTasksList.count > 0) {
        for (NSDictionary *currentTask in defaultTasksList) {
            NSDate *currentExpDate = [currentTask objectForKey:@"Expiration Date"];
            NSDate *todaysDate = [NSDate date];
            NSComparisonResult result = [currentExpDate compare: todaysDate];
            
            if (result == -1) {
                [tasksToDelete addObject:currentTask];
            
            } else {
            
                // Create a new task, setting it's properties from each item in the
                // defaults array
                Task *newTask = [[Task alloc] init];
                newTask.title = [currentTask objectForKey:@"Title"];
                newTask.description = [currentTask objectForKey:@"Description"];
                // Get the list of locations from the current task
                NSArray *currentLocations = [currentTask objectForKey:@"Locations"];
                // Turn each location item into an MKMapItem for use on the map
                for (NSDictionary *locationsDict in currentLocations) {
                    double latitude = [[locationsDict objectForKey:@"Latitude"] doubleValue];
                    double longitude = [[locationsDict objectForKey:@"Longitude"] doubleValue];
                    CLLocationCoordinate2D currentCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
                    MKPlacemark *currentPlacemark = [[MKPlacemark alloc] initWithCoordinate:currentCoordinate addressDictionary:nil];
                    MKMapItem *currentMapItem = [[MKMapItem alloc] initWithPlacemark:currentPlacemark];
                    [newTask.otherLocations addObject:currentMapItem];
                }
                // Add the expiration date to the new Task
                newTask.taskExpirationDate = [currentTask objectForKey:@"Expiration Date"];
                [self.tasksList addObject:newTask];
            }
        }
        if ([tasksToDelete count] > 0) {
            for (NSDictionary *taskToBeDeleted in tasksToDelete) {
                [defaultTasksList removeObject:taskToBeDeleted];
            }
        }
    }
    
}
-(void)deleteTaskAtIndex:(NSInteger) index {
    [self.tasksList removeObjectAtIndex:index];
    NSArray *annotations = [[NSArray alloc] initWithArray:[self.mapView annotations]];
    [self.mapView removeAnnotations:annotations];
    [self displayTasksInMap];
    
    NSMutableArray *defaultTasksList = [[[NSUserDefaults standardUserDefaults] objectForKey:@"allTasks"] mutableCopy];
    [defaultTasksList removeObjectAtIndex:index];
    [[NSUserDefaults standardUserDefaults] setObject:defaultTasksList forKey:@"allTasks"];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) displayTasksInMap {
    for (Task *task in self.tasksList) {
        //[self.mapView addAnnotations:task.otherLocations];
        for (MKMapItem *mapItem in task.otherLocations)
            [self.mapView addAnnotation: mapItem.placemark];
    }
}

- (void) AppSettingsViewControllerDidCancel:(TKSAppSettingsViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) mapDictionaryToRegion:(NSDictionary *)inputDict {
    NSString *taskTitle = [inputDict objectForKey:@"Title"];
    NSArray *locationsArray = [inputDict objectForKey:@"Locations"];
    for (NSDictionary *location in locationsArray) {
        CLLocationDegrees latitude = [[location objectForKey:@"Latitude"] doubleValue];
        CLLocationDegrees longitude = [[location objectForKey:@"Longitude"] doubleValue];
        NSString *identifier = [NSString stringWithFormat:@"%@ %f %f", taskTitle, latitude, longitude];
        
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake(latitude, longitude);
        
        BOOL driving = [[TKSAppSettingsViewController sharedManager] isDriving];
        
        if (driving) {
            CLLocationDistance radius =  (double)[[TKSAppSettingsViewController sharedManager] drivingRadius];
            CLCircularRegion *drivingRegion = [[CLCircularRegion alloc] initWithCenter:center radius:radius identifier:identifier];
            [self.regionsList addObject:drivingRegion];

        } else {
            CLLocationDistance radius = (double)[[TKSAppSettingsViewController sharedManager] walkingRadius];
            CLCircularRegion *walkingRegion = [[CLCircularRegion alloc] initWithCenter:center radius:radius identifier:identifier];
            [self.regionsList addObject:walkingRegion];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.tableView reloadData];
    [self displayTasksInMap];
    [self initializeManager];
}

- (void) initializeRegionMonitoring:(NSArray *)fences {
    if (![CLLocationManager isMonitoringAvailableForClass:[CLRegion class]]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Regions" message:@"This app requires region monitoring to work" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    for (CLRegion *geofence in fences) {
        [self.manager startMonitoringForRegion:geofence];
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location update" message:@"You've entered a task region" delegate:nil cancelButtonTitle:@"Yay!" otherButtonTitles:nil];
    [alert show];
}

// fired when user exits geo fence
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{

}

@end
