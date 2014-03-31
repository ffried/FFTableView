//
//  FFTableViewDataSource.h
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
#import <CoreData/CoreData.h>

/**
 *  The delegate protocol for FFTableViewDataSource.
 *  Allows to provide needed information as well as take control of data source methods not handled by the FFTableViewDataSource.
 */
@protocol FFTableViewDataSourceDelegate <NSObject>
@required
/**
 *  Asks for a reuse identifier for a cell at a given indexPath.
 *  @param tableView The UITableView for which a cell reuse identifier is needed.
 *  @param indexPath The NSIndexPath for which to provide a reuse identifier.
 *  @return A reuse identifier which is used to dequeue a cell for the given indexPath.
 */
- (NSString *)tableView:(UITableView *)tableView cellIdentifierForRowAtIndexPath:(NSIndexPath *)indexPath;
/**
 *  Asks the delegate to configure a cell.
 *  @param tableView The UITableView in which the cell is contained.
 *  @param cell      The UITableViewCell to configure.
 *  @param indexPath The NSIndexPath of the cell.
 *  @param object    The object from the NSFetchedResultsController. Normally a NSManagedObject subclass.
 */
- (void)tableView:(UITableView *)tableView configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath withObject:(id)object;

@optional
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section;

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index;
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView;

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;
@end

/**
 *  Handles the data source of a UITableView with a NSFetchedResultsController.
 */
@interface FFTableViewDataSource : NSObject <UITableViewDataSource>

/**
 *  The UITableView to update.
 */
@property (nonatomic, weak) UITableView *tableView;
/**
 *  The NSFetchedResultsController from which to take the objects.
 */
@property (nonatomic, weak) NSFetchedResultsController *fetchedResultsController;
/**
 *  The delegate which to ask for the needed information.
 */
@property (nonatomic, assign) id<FFTableViewDataSourceDelegate> delegate;

/**
 *  Creates a new instance of FFTableViewDataSource.
 *  @param fetchedResultsController The NSFetchedResultsController to use for getting the objects.
 *  @param tableView                The UITableView to update.
 *  @param delegate                 The delegate to ask for information.
 *  @return A new FFTableViewDataSource instance.
 */
- (instancetype)initWithFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
                                               tableView:(UITableView *)tableView
                                                delegate:(id<FFTableViewDataSourceDelegate>)delegate;

@end
