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

- (void)configureWithObject:(City *)object expanded:(BOOL)expanded;

@end
