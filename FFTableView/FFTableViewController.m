//
//  FFTableViewController
//
//  Created by Florian Friedrich on 14.12.13.
//  Copyright (c) 2013 Florian Friedrich. All rights reserved.
//

#import "FFTableViewController.h"

@interface FFTableViewController ()

@end


@implementation FFTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithStyle:UITableViewStylePlain];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initialize];
}

#pragma mark - Initialize method
- (void)initialize
{
#if FFTableViewUseCoreData
    if (!self.managedObjectContext) {
        id delegate = [UIApplication sharedApplication].delegate;
        if ([delegate respondsToSelector:@selector(managedObjectContext)]) {
            self.managedObjectContext = [delegate managedObjectContext];
        }
    }
    //self.fetchedResultsTableView = [[FFFetchedResultsTableView alloc] initWithFetchedResultsController:self.fetchedResultsController tableView:self.tableView fetchedResultsControllerDelegate:self tableViewDataSourceDelegate:self];
#endif
    self.tableView.delegate = self;
}

#if FFTableViewUseCoreData
- (void)setupWithFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
                                tableView:(UITableView *)tableView
         fetchedResultsControllerDelegate:(id<FFNSFetchedResultsControllerDelegate>)frcdelegate
              tableViewDataSourceDelegate:(id<FFTableViewDataSourceDelegate>)tvdsdelegate
{
    self.fetchedResultsControllerDelegate = [[FFNSFetchedResultsControllerDelegate alloc] initWithFetchedResultsController:fetchedResultsController
                                                                                                                 tableView:tableView
                                                                                                                  delegate:frcdelegate];
    
    self.tableViewDataSource = [[FFTableViewDataSource alloc] initWithFetchedResultsController:fetchedResultsController
                                                                                             tableView:tableView
                                                                                              delegate:tvdsdelegate];
}
#endif

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
#ifdef __IPHONE_7_0 // iOS 7 is anywhere in between min and max OS
#if FFTableViewShouldFixIOS7InteractiveDeselectBug
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f) {
        if (self.clearsSelectionOnViewWillAppear) {
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            if (indexPath) [self.tableView deselectRowAtIndexPath:indexPath animated:animated];
        }
    }
#endif
#endif
}

@end
