//
//  TKSTaskPropertiesViewController.h
//  iTasks
//
//  Created by Cale Bierman on 4/7/14.
//  Copyright (c) 2014 Dylan Thiemann. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TKSTaskPropertiesViewController;

@protocol TaskPropertiesViewControllerDelagate <NSObject>

-(void) TaskPropertiesViewControllerDidCancel:(TKSTaskPropertiesViewController *) controller;

@end

@interface TKSTaskPropertiesViewController : UIViewController
@property (nonatomic, weak) id<TaskPropertiesViewControllerDelagate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) NSString *titleText;
@property (strong, nonatomic) NSString *descriptionText;
@property (strong, nonatomic) NSDate *date;
@end
