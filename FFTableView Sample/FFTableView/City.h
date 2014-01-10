//
//  City.h
//  FFTableView Sample
//
//  Created by Florian Friedrich on 9.1.14.
//  Copyright (c) 2014 Florian Friedrich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface City : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * rank;
@property (nonatomic, retain) NSManagedObject *state;

@end
