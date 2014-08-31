//
//  FFExpandableTableViewCell.h
//
//  Created by Florian Friedrich on 8.1.14.
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

#import <UIKit/UIKit.h>

/**
 *  An expandable UITableViewCell.
 */
@interface FFExpandableTableViewCell : UITableViewCell

/**
 *  The upper view. Always visible.
 */
@property (nonatomic, strong) IBOutlet UIView *collapsedView;
/**
 *  The lower view. Visible below the collapsedView when expanded.
 */
@property (nonatomic, strong) IBOutlet UIView *expandedView;

/**
 *  Initializes the cell. Called no matter if XIBs are used or not.
 */
- (void)initialize NS_REQUIRES_SUPER;

/**
 *  Configures the cell with an object.
 *  @param object   The object with which to configure the cell.
 *  @param expanded YES if the cell is now expanded, NO otherwise.
 */
- (void)configureWithObject:(id)object expanded:(BOOL)expanded NS_REQUIRES_SUPER;

/**
 *  Called whenever the expanded state of the cell changes.
 *  @param expanded YES if the cell is now expanded, NO otherwise.
 */
- (void)setupExpanded:(BOOL)expanded NS_REQUIRES_SUPER;

@end
