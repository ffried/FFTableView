//
//  FFSampleTableViewController.m
//  FFTableView
//
//  Created by Florian Friedrich on 9.1.14.
//  Copyright (c) 2014 Florian Friedrich. All rights reserved.
//

#import "FFSampleTableViewController.h"
#import "City.h"

@interface FFSampleTableViewController () <FFNSFetchedResultsControllerDelegate, FFTableViewDataSourceDelegate>

@end


static NSString *const FFSampleCellIdentifier = @"FFSampleCellIdentifier";

@implementation FFSampleTableViewController
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)initialize
{
    [super initialize];
    self.title = @"Normal";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:FFSampleCellIdentifier];
    [self setupWithFetchedResultsController:self.fetchedResultsController tableView:self.tableView fetchedResultsControllerDelegate:self tableViewDataSourceDelegate:self];
}

#pragma mark - Properties
- (NSFetchedResultsController *)fetchedResultsController
{
    if (!_fetchedResultsController) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"City"];
        
        NSSortDescriptor *stateNameSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"state.name" ascending:YES];
        NSSortDescriptor *nameSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        fetchRequest.sortDescriptors = @[stateNameSortDescriptor, nameSortDescriptor];
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"state.name" cacheName:@"FFSampleTableViewController"];
        
        __autoreleasing NSError *error = nil;
        if (![_fetchedResultsController performFetch:&error]) {
            NSLog(@"Unresolved error in FFSampleTableViewController %@, %@", error, [error userInfo]);
            //abort();
        }
    }
    
    return _fetchedResultsController;
}

#pragma mark - FFTableViewDataSourceDelegate
- (NSString *)tableView:(UITableView *)tableView cellIdentifierForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // You could return different identifiers for different indexpaths here if needed
    return FFSampleCellIdentifier;
}

- (void)tableView:(UITableView *)tableView configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath withObject:(id)object
{
    City *city = (City *)object; // The object comes from the fetchtedResultsController
    cell.textLabel.text = city.name;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
