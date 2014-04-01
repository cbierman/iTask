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

@class AddNewTaskVC;

@protocol AddNewTaskVCDelegate <NSObject>
- (void)AddNewTaskViewControllerDidCancel:(AddNewTaskVC *)controller;
- (void)AddNewTaskViewController:(AddNewTaskVC *)controller didAddTask:(Task *)newTask;
@end

@interface AddNewTaskVC : UIViewController

@property (nonatomic, weak) id<AddNewTaskVCDelegate> delegate;

- (IBAction)sender:(id)sender;

@end
