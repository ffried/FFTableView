//
//  FFExpandableTableViewController.m
//
//  Created by Florian Friedrich on 7.1.14.
//  Copyright (c) 2014 Florian Friedrich. All rights reserved.
//

#import "FFExpandableTableViewController.h"
#import "FFExpandableTableViewCell.h"

@interface FFExpandableTableViewController ()

@property (nonatomic, strong) NSMutableArray *expandedIndexPaths;

@end


@implementation FFExpandableTableViewController

- (void)initialize
{
    [super initialize];
    self.expandedIndexPaths = [[NSMutableArray alloc] init];
}

- (BOOL)isIndexPathExpanded:(NSIndexPath *)indexPath
{
    return [self.expandedIndexPaths containsObject:indexPath];
}

- (void)setIndexPath:(NSIndexPath *)indexPath expanded:(BOOL)expanded
{
    NSArray *indexPaths = @[indexPath];
    if (expanded) {
        if (self.allowsMultipleExpandedCells) {
            [self.expandedIndexPaths addObject:indexPath];
        } else {
            if (self.expandedIndexPaths.count > 0) {
                NSIndexPath *oldIndexPath = self.expandedIndexPaths.lastObject;
                indexPaths = @[oldIndexPath, indexPath];
                [self.expandedIndexPaths removeObject:oldIndexPath];
            }
            [self.expandedIndexPaths addObject:indexPath];
        }
    } else {
        [self.expandedIndexPaths removeObject:indexPath];
    }
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self setIndexPath:indexPath expanded:![self isIndexPathExpanded:indexPath]];
}

@end
