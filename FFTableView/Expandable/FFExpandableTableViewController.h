//
//  FFExpandableTableViewController.h
//
//  Created by Florian Friedrich on 7.1.14.
//  Copyright (c) 2014 Florian Friedrich. All rights reserved.
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

#import "FFTableViewController.h"

@interface FFExpandableTableViewController : FFTableViewController

/**
 *  Indicates whether multiple expanded cells are allowed or not.
 *  Defaults to NO.
 */
@property (nonatomic, assign) BOOL allowsMultipleExpandedCells;

/**
 *  Checks whether a given indexPath is expanded or not.
 *  @param indexPath The indexPath to check.
 *  @return YES if the indexPath is expanded, NO otherwise.
 */
- (BOOL)isIndexPathExpanded:(NSIndexPath *)indexPath;
/**
 *  Changes the expanded state of a given indexPath.
 *  @param indexPath The indexPath to change the expanded state for.
 *  @param expanded  YES if expanded, NO otherwise.
 */
- (void)setIndexPath:(NSIndexPath *)indexPath expanded:(BOOL)expanded;

/**
 *  This is normally a UITableViewDelegate method, but it's needed to set an indexpath expanded.
 *  If you need this method override it and call super at the beginning of your implementation.
 *  @param tableView The tableview in which a row was selected.
 *  @param indexPath The indexPath of the selected row.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath NS_REQUIRES_SUPER;

@end
