//
//  FFExpandableTableViewCell.h
//
//  Created by Florian Friedrich on 8.1.14.
//  Copyright (c) 2014 Florian Friedrich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFExpandableTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *collapsedView; // Always displayed
@property (nonatomic, strong) UIView *expandedView; // Displayed below collapsed view when expanded

// Always called, no matter if you use XIBs or code. Requires you to call super
- (void)initialize;

// It's important to call super at the beginning and [self layoutIfNeeded]; at the and of the implenentation in a subclass
- (void)configureWithObject:(id)object expanded:(BOOL)expanded;

@end
