//
//  FFTableViewController
//
//  Created by Florian Friedrich on 14.12.13.
//  Copyright (c) 2013 Florian Friedrich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Ability to turn off Core Data Support. However, this doesn't make sense since Core Data is one reason for this library to exist.
// It might only make sense if you want to use the expandable table view but without Core Data...
#define FFTableViewUseCoreData 1

// Only define the fix var if iOS 7 is included between min and max OS
#ifdef __IPHONE_7_0
#define FFTableViewShouldFixIOS7InteractiveDeselectBug 1
#endif

#if FFTableViewUseCoreData
#import <CoreData/CoreData.h>
#import "FFNSFetchedResultsControllerDelegate.h"
#import "FFTableViewDataSource.h"
#endif

@interface FFTableViewController : UITableViewController <UITableViewDelegate>

#if FFTableViewUseCoreData
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong) FFTableViewDataSource *tableViewDataSource;
@property (nonatomic, strong) FFNSFetchedResultsControllerDelegate *fetchedResultsControllerDelegate;

- (void)setupWithFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
                                tableView:(UITableView *)tableView
         fetchedResultsControllerDelegate:(id<FFNSFetchedResultsControllerDelegate>)frcdelegate
              tableViewDataSourceDelegate:(id<FFTableViewDataSourceDelegate>)tvdsdelegate;
#endif

// Use to set up things. It get's called no matter if you use XIBs or code
- (void)initialize;

@end
