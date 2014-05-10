//
//  FFSampleExpandableTableViewController.m
//  FFTableView Sample
//
//  Created by Florian Friedrich on 9.1.14.
//  Copyright (c) 2014 Florian Friedrich. All rights reserved.
//

#import "FFSampleExpandableTableViewController.h"
#import "FFCityCell.h"

@interface FFSampleExpandableTableViewController () <FFNSFetchedResultsControllerDelegate, FFTableViewDataSourceDelegate>

@property (nonatomic, strong) FFCityCell *prototypeCell;

@end


static NSString *const FFExpandableCityCellIdentifier = @"FFExpandableCityCellIdentifier";

@implementation FFSampleExpandableTableViewController
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)initialize
{
    [super initialize];
    self.title = @"Expandable";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.tableView registerClass:[FFCityCell class] forCellReuseIdentifier:FFExpandableCityCellIdentifier];
    UIEdgeInsets contentInsets = self.tableView.contentInset;
    self.tableView.contentInset = UIEdgeInsetsMake(20.0f, contentInsets.left, contentInsets.bottom, contentInsets.right);
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
               
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"state.name" cacheName:@"FFSampleExpandableTableViewController"];
        
        __autoreleasing NSError *error = nil;
        if (![_fetchedResultsController performFetch:&error]) {
            NSLog(@"Unresolved error in FFSampleExpandableTableViewController %@, %@", error, [error userInfo]);
            //abort();
        }
    }
    
    return _fetchedResultsController;
}

#pragma mark - FFTableViewDataSourceDelegate
- (NSString *)tableView:(UITableView *)tableView cellIdentifierForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // You could return different identifiers for different indexpaths here if needed
    return FFExpandableCityCellIdentifier;
}

- (void)tableView:(UITableView *)tableView configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath withObject:(id)object
{
    FFCityCell *cityCell = (FFCityCell *)cell; // Cell is a FFCityCell as registered in viewDidLoad
    BOOL expanded = [self isIndexPathExpanded:indexPath]; // isIndexPathExpanded returns YES if the indexPath is expanded
    [cityCell configureWithObject:object expanded:expanded]; // Configure the cell
}

#pragma mark - FFNSFetchedResultsControllerDelegate
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [self tableView:tableView cellIdentifierForRowAtIndexPath:indexPath];
    if (!self.prototypeCell || ![self.prototypeCell.reuseIdentifier isEqualToString:identifier]) {
        self.prototypeCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    [self tableView:tableView
      configureCell:self.prototypeCell
  forRowAtIndexPath:indexPath
         withObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    
    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

// It seems like this methods causes the tableview to scroll anywhere randomly
// If you have a huge amount of cells you should implement this and return appropriate values.
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // You should definitively do some better calculations here!
//    CGFloat height = 130.0f;
//    return ([self isIndexPathExpanded:indexPath]) ? height * 2.0f : height;
//}

@end
