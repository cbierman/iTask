//
//  AddNewTaskVC.h
//  iTasks
//
//  Created by Dylan Thiemann on 3/31/14.
//  Copyright (c) 2014 Dylan Thiemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Task.h"
#import "SearchResultsVC.h"

@class AddNewTaskVC;

@protocol AddNewTaskVCDelegate <NSObject>
- (void)AddNewTaskViewControllerDidCancel:(AddNewTaskVC *)controller;
- (void)AddNewTaskViewController:(AddNewTaskVC *)controller didAddTask:(Task *)newTask;

@end

@interface AddNewTaskVC : UIViewController <searchVCDelegate>

@property (strong, nonatomic) IBOutlet UITextField *searchText;

// A handle on our map view... passed by delegate
@property (strong,nonatomic) MKMapView *mapHandle;
@property (strong,nonatomic) NSMutableArray *delegateTasksList;

@property (nonatomic, weak) id<AddNewTaskVCDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;

- (IBAction)cancel:(id)sender;
- (IBAction)textFieldReturn:(id)sender;
- (IBAction)done:(id)sender;


@end
