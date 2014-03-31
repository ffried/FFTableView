//
//  FFTableViewController
//
//  Created by Florian Friedrich on 14.12.13.
//  Copyright (c) 2013 Florian Friedrich. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Ability to turn off Core Data Support. However, this doesn't make sense since Core Data is one reason for this library to exist.
// It might only make sense if you want to use the expandable table view but without Core Data...
#ifndef FFTableViewUseCoreData
#define FFTableViewUseCoreData 1
#endif

// Only define the fix var if iOS 7 is included between min and max OS
#ifdef __IPHONE_7_0
#ifndef FFTableViewShouldFixIOS7InteractiveDeselectBug
#define FFTableViewShouldFixIOS7InteractiveDeselectBug 1
#endif
#endif

#if FFTableViewUseCoreData
#import <CoreData/CoreData.h>
#import "FFNSFetchedResultsControllerDelegate.h"
#import "FFTableViewDataSource.h"
#endif

/**
 *  A UITableViewController subclass with some useful properties and methods for use with CoreData.
 */
@interface FFTableViewController : UITableViewController <UITableViewDelegate>

#if FFTableViewUseCoreData
/**
 *  The managed object context of the table view controller.
 */
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
/**
 *  The fetched results controller of the table view controller.
 */
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

/**
 *  The table view data source object of the table view controller.
 */
@property (nonatomic, strong) FFTableViewDataSource *tableViewDataSource;
/**
 *  The fetched results controller object of the table view controller.
 */
@property (nonatomic, strong) FFNSFetchedResultsControllerDelegate *fetchedResultsControllerDelegate;

/**
 *  Sets up the tableViewDataSource and fetchedResultsControllerDelegate property.
 *  @param fetchedResultsController The NSFetchedResultsController to use.
 *  @param tableView                The UITableView to use.
 *  @param frcdelegate              The FFNSFetchedResultsControllerDelegate's delegate.
 *  @param tvdsdelegate             The FFTableViewDataSource's delegate.
 */
- (void)setupWithFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
                                tableView:(UITableView *)tableView
         fetchedResultsControllerDelegate:(id<FFNSFetchedResultsControllerDelegate>)frcdelegate
              tableViewDataSourceDelegate:(id<FFTableViewDataSourceDelegate>)tvdsdelegate;
#endif

/**
 *  Set up the table view controller.
 *  Called whether XIBs are used or not.
 */
- (void)initialize;

@end
