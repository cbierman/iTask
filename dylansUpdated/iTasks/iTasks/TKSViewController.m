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

@interface TKSViewController () <UITableViewDataSource, UITableViewDelegate, AddNewTaskVCDelegate>

@property (strong, nonatomic) IBOutlet UITableView *mapItems;
@property (strong,nonatomic) NSMutableArray *tasksList;

@end

@implementation TKSViewController

- (NSMutableArray *)tasksList {
    if (!_tasksList) {
        _tasksList = [[NSMutableArray alloc] init];
    }
    return _tasksList;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mapItem"];
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addNewTask"]) {
        NSLog(@"Adding new task! Hopefully");
        UINavigationController *navigationController = segue.destinationViewController;
        AddNewTaskVC *addNewTaskVC = [navigationController viewControllers][0];
        addNewTaskVC.delegate = self;
    }
}

-(void)AddNewTaskViewControllerDidCancel:(AddNewTaskVC *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) AddNewTaskViewController:(AddNewTaskVC *)controller didAddTask:(Task *)newTask {
    
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    _mapView.centerCoordinate = userLocation.location.coordinate;
}

@end
