//
//  FFExpandableTableViewController.h
//
//  Created by Florian Friedrich on 7.1.14.
//  Copyright (c) 2014 Florian Friedrich. All rights reserved.
//

#import "FFTableViewController.h"

@interface FFExpandableTableViewController : FFTableViewController

@property (nonatomic, assign) BOOL allowsMultipleExpandedCells;

- (BOOL)isIndexPathExpanded:(NSIndexPath *)indexPath;
- (void)setIndexPath:(NSIndexPath *)indexPath expanded:(BOOL)expanded;

// I know this is a UITableViewDelegate method, but it's needed to do actually set the index path expanded.
// So if you need it just override it and don't forget to call super!
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
