//
//  FFCityCell.h
//  FFTableView Sample
//
//  Created by Florian Friedrich on 9.1.14.
//  Copyright (c) 2014 Florian Friedrich. All rights reserved.
//

#import "FFExpandableTableViewCell.h"

@class City;
@interface FFCityCell : FFExpandableTableViewCell

// You can change the type from id (superclass definition) to whatever you need.
- (void)configureWithObject:(City *)object expanded:(BOOL)expanded;

@end
