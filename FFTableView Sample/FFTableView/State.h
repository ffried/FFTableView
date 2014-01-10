//
//  State.h
//  FFTableView Sample
//
//  Created by Florian Friedrich on 9.1.14.
//  Copyright (c) 2014 Florian Friedrich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class City;

@interface State : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSOrderedSet *cities;
@end

@interface State (CoreDataGeneratedAccessors)

- (void)insertObject:(City *)value inCitiesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCitiesAtIndex:(NSUInteger)idx;
- (void)insertCities:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCitiesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCitiesAtIndex:(NSUInteger)idx withObject:(City *)value;
- (void)replaceCitiesAtIndexes:(NSIndexSet *)indexes withCities:(NSArray *)values;
- (void)addCitiesObject:(City *)value;
- (void)removeCitiesObject:(City *)value;
- (void)addCities:(NSOrderedSet *)values;
- (void)removeCities:(NSOrderedSet *)values;
@end
