//
//  FFExpandableTableViewController.m
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

#import "FFExpandableTableViewController.h"
#import "FFExpandableTableViewCell.h"

@interface FFExpandableTableViewController ()

@property (nonatomic, strong) NSMutableArray *expandedIndexPaths;

@end


@implementation FFExpandableTableViewController

#pragma mark - Initialize
- (void)initialize
{
    [super initialize];
    self.expandedIndexPaths = [[NSMutableArray alloc] init];
    self.allowsMultipleExpandedCells = NO;
}

#pragma mark - Expanded methods
- (BOOL)isIndexPathExpanded:(NSIndexPath *)indexPath
{
    return [self.expandedIndexPaths containsObject:indexPath];
}

- (void)setIndexPath:(NSIndexPath *)indexPath expanded:(BOOL)expanded
{
    [self.tableView beginUpdates];
    NSArray *indexPaths = @[indexPath];
    if (expanded) {
        if (self.allowsMultipleExpandedCells) {
            [self.expandedIndexPaths addObject:indexPath];
        } else {
            if (self.expandedIndexPaths.count > 0) {
                NSIndexPath *oldIndexPath = [self.expandedIndexPaths lastObject];
                indexPaths = @[indexPath, oldIndexPath];
                [self.expandedIndexPaths removeObject:oldIndexPath];
            }
            [self.expandedIndexPaths addObject:indexPath];
        }
    } else {
        [self.expandedIndexPaths removeObject:indexPath];
    }
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    
    // This might cause random scrolling, but better than nothing
    if (![self.tableView.indexPathsForVisibleRows containsObject:indexPath]) {
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self setIndexPath:indexPath expanded:![self isIndexPathExpanded:indexPath]];
}

@end
