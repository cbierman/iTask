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

@interface TKSViewController () <UITableViewDataSource, UITableViewDelegate, AddNewTaskVCDelegate, TaskPropertiesViewControllerDelagate>

//@property (strong, nonatomic) NSMutableArray *notificationArray;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TKSViewController

- (NSMutableArray *)tasksList {
    if (!_tasksList) {
        _tasksList = [[NSMutableArray alloc] init];
    }
    return _tasksList;
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
    
    // Make sure we have tasks to dispaly before we do anything
    if (defaultTasksList.count > 0) {
        for (NSDictionary *currentTask in defaultTasksList) {
            NSDate *currentExpDate = [currentTask objectForKey:@"Expiration Date"];
            NSDate *todaysDate = [NSDate date];
            NSComparisonResult result = [currentExpDate compare: todaysDate];
            
            if (result == -1) {
                [defaultTasksList removeObject:currentTask];
                
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

- (void)viewWillAppear:(BOOL)animated {
    
    [self.tableView reloadData];
    [self displayTasksInMap];
}

@end
