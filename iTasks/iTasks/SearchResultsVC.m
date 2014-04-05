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
@property (strong,nonatomic) NSMutableArray *selectedPlaces;

@end

@implementation SearchResultsVC

- (NSMutableArray *) selectedPlaces {
    if (!_selectedPlaces)
        _selectedPlaces = [[NSMutableArray alloc] init];
    return _selectedPlaces;
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

-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"%i, deselected", indexPath.row);
    MKMapItem *tempMapItem = [self.searchResults objectAtIndex:indexPath.row];
    [self.selectedPlaces removeObject:tempMapItem];
}

// Gets called when a row is selected
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MKMapItem *tempMapItem = [self.searchResults objectAtIndex:indexPath.row];
    [self.selectedPlaces addObject:tempMapItem];
}

-(IBAction)cancelPressed:(id)sender {
    [self.delegate SearchResultsControllerDidCancel:self];
}

// User selects which elements he wants to choose,
// they can choose, 0, 1, or none.

- (IBAction)donePressed:(id)sender {
    if (self.selectedPlaces.count > 0)
        [self.delegate SearchResultsViewController:self didChoosePlace:self.selectedPlaces];
    // If nothing is selected, pretend its a cancel
    else
        [self.delegate SearchResultsControllerDidCancel:self];
}


@end
