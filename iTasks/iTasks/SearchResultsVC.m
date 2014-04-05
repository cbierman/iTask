//
//  SearchResultsVC.m
//  iTasks
//
//  Created by Dylan Thiemann on 4/3/14.
//  Copyright (c) 2014 Dylan Thiemann. All rights reserved.
//

#import "SearchResultsVC.h"

@interface SearchResultsVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SearchResultsVC

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResults.count;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger cellNum = indexPath.row;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchItem"];
    MKMapItem *item = [self.searchResults objectAtIndex:cellNum];
    cell.textLabel.text = item.name;
    return cell;
}

-(IBAction)cancelPressed:(id)sender {
    //NSLog(@"Clsing things");
    [self.delegate SearchResultsControllerDidCancel:self];
}


@end
