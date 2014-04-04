//
//  SearchResultsVC.h
//  iTasks
//
//  Created by Dylan Thiemann on 4/3/14.
//  Copyright (c) 2014 Dylan Thiemann. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol searchResultsVCDelegate <NSObject>

-(void) dismissChildVC;

@end

@interface SearchResultsVC : UIViewController

@property (weak, nonatomic) id<searchResultsVCDelegate> delegate;

@end
