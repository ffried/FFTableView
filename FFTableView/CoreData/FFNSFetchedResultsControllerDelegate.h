//
//  FFNSFetchedResultsControllerDelegate.h
//
//  Created by Florian Friedrich on 14.12.13.
//  Copyright (c) 2013 Florian Friedrich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@protocol FFNSFetchedResultsControllerDelegate <NSFetchedResultsControllerDelegate, NSObject>
// Everything is adopted from the NSFetchedResultsControllerDelegate protocol
@end

@interface FFNSFetchedResultsControllerDelegate : NSObject <NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, assign) id<FFNSFetchedResultsControllerDelegate> delegate;

- (instancetype)initWithFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
                                       tableView:(UITableView *)tableView
                                        delegate:(id<FFNSFetchedResultsControllerDelegate>)delegate;

@end
