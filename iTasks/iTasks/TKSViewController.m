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

@interface TKSViewController () <UITableViewDataSource, UITableViewDelegate, AddNewTaskVCDelegate>

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

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mapItem"];
    Task *task = [self.tasksList objectAtIndex:indexPath.row];
    cell.textLabel.text = task.title;
    cell.detailTextLabel.text = task.description;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //int index = indexPath.row;
    
}
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addNewTask"]) {
        //NSLog(@"Adding new task! Hopefully");
        UINavigationController *navigationController = segue.destinationViewController;
        AddNewTaskVC *addNewTaskVC = [navigationController viewControllers][0];
        addNewTaskVC.mapHandle = _mapView;
        addNewTaskVC.delegateTasksList = self.tasksList;
        addNewTaskVC.delegate = self;
    }
    
    //if ([segue.identifier isEqualToString:@"seeTaskProperties"]) {
    //    UINavigationController *navController = segue.destinationViewController;
    //    TKSTaskPropertiesViewController *taskProperties = [navController viewControllers][0];
    //}
}

-(void)AddNewTaskViewControllerDidCancel:(AddNewTaskVC *)controller {
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) displayTasksInMap {
    for (Task *task in self.tasksList) {
        [self.mapView addAnnotations:task.otherLocations];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    [self displayTasksInMap];
    //if (self.tasksList.count != 0) {
    //    NSLog(@"%i, asdfasdfaasdfadsfa", self.tasksList.count);
    //    Task *temp = [self.tasksList objectAtIndex:0];
    //    NSLog(@"%@, task name", temp.title );
    //}
}

@end
