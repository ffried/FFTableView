//
//  FFNSFetchedResultsControllerDelegate.h
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
 *  The delegate protocol of FFNSFetchedResultsControllerDelegate.
 *  It's completely adopted from the NSFetchedResultsControllerDelegate protocol.
 */
@protocol FFNSFetchedResultsControllerDelegate <NSFetchedResultsControllerDelegate, NSObject>
@end

/**
 *  Handles the delegate of a NSFetchedResultsController but allows to override the methods to do work on yourself.
 */
@interface FFNSFetchedResultsControllerDelegate : NSObject <NSFetchedResultsControllerDelegate>

/**
 *  The NSFetchedResultsController to handle the delegate for.
 */
@property (nonatomic, weak) NSFetchedResultsController *fetchedResultsController;
/**
 *  The UITableView to update with the NSFetchedResultsController.
 */
@property (nonatomic, weak) UITableView *tableView;
/**
 *  The delegate to check for overridden NSFetchedResultsControllerDelegate methods.
 */
@property (nonatomic, assign) id<FFNSFetchedResultsControllerDelegate> delegate;

/**
 *  Instantiates a new FFNSFetchedResultsControllerDelegate.
 *  @param fetchedResultsController The NSFetchedResultsController to use.
 *  @param tableView                The UITableView to use.
 *  @param delegate                 A delegate or nil.
 *  @return A new instance of FFNSFetchedResultsControllerDelegate.
 */
- (instancetype)initWithFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
                                       tableView:(UITableView *)tableView
                                        delegate:(id<FFNSFetchedResultsControllerDelegate>)delegate;

@end
