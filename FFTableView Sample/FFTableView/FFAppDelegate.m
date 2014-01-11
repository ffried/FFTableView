//
//  FFAppDelegate.m
//  FFTableView Sample
//
//  Created by Florian Friedrich on 7.1.14.
//  Copyright (c) 2014 Florian Friedrich. All rights reserved.
//

#import "FFAppDelegate.h"
#import "FFSampleTableViewController.h"
#import "FFSampleExpandableTableViewController.h"

#import "State.h"
#import "City.h"

@interface FFAppDelegate ()

@property (nonatomic, strong) UITabBarController *tabBarController;
@property (nonatomic, strong) FFSampleTableViewController *tableViewController;
@property (nonatomic, strong) FFSampleExpandableTableViewController *expandableTableViewController;

- (void)setupSampleData;

@end

@implementation FFAppDelegate
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Only fill the database if it wasn't yet filled
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"FilledCoreData"]) {
        [self setupSampleData]; // Fills Core Data with some sample data
        [self saveContext];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FilledCoreData"];
    }
    
    self.tableViewController = [[FFSampleTableViewController alloc] init];
    self.expandableTableViewController = [[FFSampleExpandableTableViewController alloc] init];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[self.tableViewController, self.expandableTableViewController];
    
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.tabBarController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FFTableViewSample" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"FFTableViewSample.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

// ATTENTION
// This is a very long method just doing the same over and over again. Only go down from here if you really want to see @end.
#pragma mark - Core Data filling
- (void)setupSampleData
{
    NSString *stateEntity = @"State";
    NSString *cityEntity = @"City";
    
    // Source: http://en.wikipedia.org/wiki/List_of_U.S._states'_largest_cities_by_population
    // Date: 01/09/2014
    State *alabama = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    alabama.name = @"Alabama";
    
    City *birmingham = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    birmingham.name = @"Birmingham";
    birmingham.rank = @"Most populous";
    birmingham.state = alabama;
    
    City *montgomery = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    montgomery.name = @"Montgomery";
    montgomery.rank = @"2nd most populous";
    montgomery.state = alabama;
    
    City *mobile = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    mobile.name = @"Mobile";
    mobile.rank = @"3rd most populous";
    mobile.state = alabama;
    
    City *huntsville = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    huntsville.name = @"Huntsville";
    huntsville.rank = @"4th most populous";
    huntsville.state = alabama;
    
    City *tuscaloosa = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    tuscaloosa.name = @"Tuscaloosa";
    tuscaloosa.rank = @"5th most populous";
    tuscaloosa.state = alabama;
    
    
    State *alaska = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    alaska.name = @"Alaska";
    
    City *anchorage = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    anchorage.name = @"Anchorage";
    anchorage.rank = @"Most populous";
    anchorage.state = alaska;
    
    City *juneau = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    juneau.name = @"Juneau";
    juneau.rank = @"2nd most populous";
    juneau.state = alaska;
    
    City *fairbanks = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    fairbanks.name = @"Fairbanks";
    fairbanks.rank = @"3rd most populous";
    fairbanks.state = alaska;
    
    City *sitka = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    sitka.name = @"Sitka";
    sitka.rank = @"4th most populous";
    sitka.state = alaska;
    
    City *ketchikan = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    ketchikan.name = @"Ketchikan";
    ketchikan.rank = @"5th most populous";
    ketchikan.state = alaska;
    
    
    State *arizona = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    arizona.name = @"Arizona";
    
    City *phoenix = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    phoenix.name = @"Phoenix";
    phoenix.rank = @"Most populous";
    phoenix.state = arizona;
    
    City *tucson = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    tucson.name = @"Tucson";
    tucson.rank = @"2nd most populous";
    tucson.state = arizona;
    
    City *mesa = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    mesa.name = @"Mesa";
    mesa.rank = @"3rd most populous";
    mesa.state = arizona;
    
    City *chandler = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    chandler.name = @"Chandler";
    chandler.rank = @"4th most populous";
    chandler.state = arizona;
    
    City *glendale = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    glendale.name = @"Glendale";
    glendale.rank = @"5th most populous";
    glendale.state = arizona;
    
    
    State *arkansas = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    arkansas.name = @"Arkansas";
    
    City *littleRock = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    littleRock.name = @"Little Rock";
    littleRock.rank = @"Most populous";
    littleRock.state = arkansas;
    
    City *fortSmith = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    fortSmith.name = @"Fort Smith";
    fortSmith.rank = @"2nd most populous";
    fortSmith.state = arkansas;
    
    City *fayetteville = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    fayetteville.name = @"Fayetteville";
    fayetteville.rank = @"3rd most populous";
    fayetteville.state = arkansas;
    
    City *springdale = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    springdale.name = @"Springdale";
    springdale.rank = @"4th most populous";
    springdale.state = arkansas;
    
    City *jonesboro = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    jonesboro.name = @"Jonesboro";
    jonesboro.rank = @"5th most populous";
    jonesboro.state = arkansas;
    
    
    State *california = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    california.name = @"California";
    
    City *losAngeles = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    losAngeles.name = @"Los Angeles";
    losAngeles.rank = @"Most populous";
    losAngeles.state = california;
    
    City *sanDiego = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    sanDiego.name = @"San Diego";
    sanDiego.rank = @"2nd most populous";
    sanDiego.state = california;
    
    City *sanJose = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    sanJose.name = @"San Jose";
    sanJose.rank = @"3rd most populous";
    sanJose.state = california;
    
    City *sanFrancisco = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    sanFrancisco.name = @"San Francisco";
    sanFrancisco.rank = @"4th most populous";
    sanFrancisco.state = california;
    
    City *fresno = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    fresno.name = @"Fresno";
    fresno.rank = @"5th most populous";
    fresno.state = california;
    
    
    State *colorado = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    colorado.name = @"Colorado";
    
    City *denver = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    denver.name = @"Denver";
    denver.rank = @"Most populous";
    denver.state = colorado;
    
    City *coloradoSprings = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    coloradoSprings.name = @"Colorado Springs";
    coloradoSprings.rank = @"2nd most populous";
    coloradoSprings.state = colorado;
    
    City *aurora = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    aurora.name = @"Aurora";
    aurora.rank = @"3rd most populous";
    aurora.state = colorado;
    
    City *fortCollins = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    fortCollins.name = @"Fort Collins";
    fortCollins.rank = @"4th most populous";
    fortCollins.state = colorado;
    
    City *lakewood = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    lakewood.name = @"Lakewood";
    lakewood.rank = @"5th most populous";
    lakewood.state = colorado;
    
    
    State *connecticut = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    connecticut.name = @"Connecticut";
    
    City *bridgeport = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    bridgeport.name = @"Bridgeport";
    bridgeport.rank = @"Most populous";
    bridgeport.state = connecticut;
    
    City *newHaven = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    newHaven.name = @"New Haven";
    newHaven.rank = @"2nd most populous";
    newHaven.state = connecticut;
    
    City *stamford = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    stamford.name = @"Stamford";
    stamford.rank = @"3rd most populous";
    stamford.state = connecticut;
    
    City *hartford = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    hartford.name = @"Hartford";
    hartford.rank = @"4th most populous";
    hartford.state = connecticut;
    
    City *waterbury = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    waterbury.name = @"Waterbury";
    waterbury.rank = @"5th most populous";
    waterbury.state = connecticut;
    
    
    State *delaware = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    delaware.name = @"Delaware";
    
    City *wilmington = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    wilmington.name = @"Wilmington";
    wilmington.rank = @"Most populous";
    wilmington.state = delaware;
    
    City *dover = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    dover.name = @"Dover";
    dover.rank = @"2nd most populous";
    dover.state = delaware;
    
    City *newark = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    newark.name = @"Newark";
    newark.rank = @"3rd most populous";
    newark.state = delaware;
    
    City *middletown = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    middletown.name = @"Middletown";
    middletown.rank = @"4th most populous";
    middletown.state = delaware;
    
    City *smyrna = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    smyrna.name = @"Smyrna";
    smyrna.rank = @"5th most populous";
    smyrna.state = delaware;
    
    
    State *florida = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    florida.name = @"Florida";
    
    City *jacksonville = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    jacksonville.name = @"Jacksonville";
    jacksonville.rank = @"Most populous";
    jacksonville.state = florida;
    
    City *miami = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    miami.name = @"Miami";
    miami.rank = @"2nd most populous";
    miami.state = florida;
    
    City *tampa = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    tampa.name = @"Tampa";
    tampa.rank = @"3rd most populous";
    tampa.state = florida;
    
    City *stPetersburg = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    stPetersburg.name = @"St. Petersburg";
    stPetersburg.rank = @"4th most populous";
    stPetersburg.state = florida;
    
    City *orlando = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    orlando.name = @"Orlando";
    orlando.rank = @"5th most populous";
    orlando.state = florida;
    
    
    State *georgia = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    georgia.name = @"Georgia";
    
    City *atlanta = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    atlanta.name = @"Atlanta";
    atlanta.rank = @"Most populous";
    atlanta.state = georgia;
    
    City *augusta = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    augusta.name = @"Augusta";
    augusta.rank = @"2nd most populous";
    augusta.state = georgia;
    
    City *columbus = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    columbus.name = @"Columbus";
    columbus.rank = @"3rd most populous";
    columbus.state = georgia;
    
    City *savannah = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    savannah.name = @"Savannah";
    savannah.rank = @"4th most populous";
    savannah.state = georgia;
    
    City *athens = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    athens.name = @"Athens";
    athens.rank = @"5th most populous";
    athens.state = georgia;
    
    
    State *hawaii = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    hawaii.name = @"Hawaii";
    
    City *honolulu = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    honolulu.name = @"Honolulu";
    honolulu.rank = @"Most populous";
    honolulu.state = hawaii;
    
    City *hilo = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    hilo.name = @"Hilo";
    hilo.rank = @"2nd most populous";
    hilo.state = hawaii;
    
    City *kailua = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    kailua.name = @"Kailua";
    kailua.rank = @"3rd most populous";
    kailua.state = hawaii;
    
    City *kapolei = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    kapolei.name = @"Kapolei";
    kapolei.rank = @"4th most populous";
    kapolei.state = hawaii;
    
    City *kaneohe = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    kaneohe.name = @"Kaneohe";
    kaneohe.rank = @"5th most populous";
    kaneohe.state = hawaii;
    
    
    State *idaho = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    idaho.name = @"Idaho";
    
    City *boise = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    boise.name = @"Boise";
    boise.rank = @"Most populous";
    boise.state = idaho;
    
    City *nampa = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    nampa.name = @"Nampa";
    nampa.rank = @"2nd most populous";
    nampa.state = idaho;
    
    City *meridian = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    meridian.name = @"Meridian";
    meridian.rank = @"3rd most populous";
    meridian.state = idaho;
    
    City *idahoFalls = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    idahoFalls.name = @"Idaho Falls";
    idahoFalls.rank = @"4th most populous";
    idahoFalls.state = idaho;
    
    City *pocatello = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    pocatello.name = @"Pocatello";
    pocatello.rank = @"5th most populous";
    pocatello.state = idaho;
    
    
    State *illinois = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    illinois.name = @"Illinois";
    
    City *chicago = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    chicago.name = @"Chicago";
    chicago.rank = @"Most populous";
    chicago.state = illinois;
    
    City *aurora1 = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    aurora1.name = @"Aurora";
    aurora1.rank = @"2nd most populous";
    aurora1.state = illinois;
    
    City *rockford = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    rockford.name = @"Rockford";
    rockford.rank = @"3rd most populous";
    rockford.state = illinois;
    
    City *joliet = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    joliet.name = @"Joliet";
    joliet.rank = @"4th most populous";
    joliet.state = illinois;
    
    City *naperville = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    naperville.name = @"Naperville";
    naperville.rank = @"5th most populous";
    naperville.state = illinois;
    
    
    State *indiana = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    indiana.name = @"Indiana";
    
    City *indianapolis = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    indianapolis.name = @"Indianapolis";
    indianapolis.rank = @"Most populous";
    indianapolis.state = indiana;
    
    City *fortWayne = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    fortWayne.name = @"Fort Wayne";
    fortWayne.rank = @"2nd most populous";
    fortWayne.state = indiana;
    
    City *evansville = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    evansville.name = @"Evansville";
    evansville.rank = @"3rd most populous";
    evansville.state = indiana;
    
    City *southBend = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    southBend.name = @"South Bend";
    southBend.rank = @"4th most populous";
    southBend.state = indiana;
    
    City *carmel = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    carmel.name = @"Carmel";
    carmel.rank = @"5th most populous";
    carmel.state = indiana;
    
    
    State *iowa = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    iowa.name = @"Iowa";
    
    City *desMoines = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    desMoines.name = @"Des Moines";
    desMoines.rank = @"Most populous";
    desMoines.state = iowa;
    
    City *cedarRapids = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    cedarRapids.name = @"Cedar Rapids";
    cedarRapids.rank = @"2nd most populous";
    cedarRapids.state = iowa;
    
    City *davenport = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    davenport.name = @"Davenport";
    davenport.rank = @"3rd most populous";
    davenport.state = iowa;
    
    City *siouxCity = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    siouxCity.name = @"Sioux City";
    siouxCity.rank = @"4th most populous";
    siouxCity.state = iowa;
    
    City *waterloo = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    waterloo.name = @"Waterloo";
    waterloo.rank = @"5th most populous";
    waterloo.state = iowa;
    
    
    State *kansas = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    kansas.name = @"Kansas";
    
    City *wichita = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    wichita.name = @"Wichita";
    wichita.rank = @"Most populous";
    wichita.state = kansas;
    
    City *overlandPark = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    overlandPark.name = @"Overland Park";
    overlandPark.rank = @"2nd most populous";
    overlandPark.state = kansas;
    
    City *kansasCity = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    kansasCity.name = @"Kansas City";
    kansasCity.rank = @"3rd most populous";
    kansasCity.state = kansas;
    
    City *topeka = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    topeka.name = @"Topeka";
    topeka.rank = @"4th most populous";
    topeka.state = kansas;
    
    City *olathe = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    olathe.name = @"Olathe";
    olathe.rank = @"5th most populous";
    olathe.state = kansas;
    
    
    State *kentucky = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    kentucky.name = @"Kentucky";
    
    City *louisville = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    louisville.name = @"Louisville";
    louisville.rank = @"Most populous";
    louisville.state = kentucky;
    
    City *lexington = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    lexington.name = @"Lexington";
    lexington.rank = @"2nd most populous";
    lexington.state = kentucky;
    
    City *bowlingGreen = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    bowlingGreen.name = @"Bowling Green";
    bowlingGreen.rank = @"3rd most populous";
    bowlingGreen.state = kentucky;
    
    City *owensboro = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    owensboro.name = @"Owensboro";
    owensboro.rank = @"4th most populous";
    owensboro.state = kentucky;
    
    City *covington = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    covington.name = @"Covington";
    covington.rank = @"5th most populous";
    covington.state = kentucky;
    
    
    State *louisiana = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    louisiana.name = @"Louisiana";
    
    City *newOrleans = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    newOrleans.name = @"New Orleans";
    newOrleans.rank = @"Most populous";
    newOrleans.state = louisiana;
    
    City *batonRouge = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    batonRouge.name = @"Baton Rouge";
    batonRouge.rank = @"2nd most populous";
    batonRouge.state = louisiana;
    
    City *shreveport = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    shreveport.name = @"Shreveport";
    shreveport.rank = @"3rd most populous";
    shreveport.state = louisiana;
    
    City *lafayette = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    lafayette.name = @"Lafayette";
    lafayette.rank = @"4th most populous";
    lafayette.state = louisiana;
    
    City *lakeCharles = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    lakeCharles.name = @"Lake Charles";
    lakeCharles.rank = @"5th most populous";
    lakeCharles.state = louisiana;
    
    
    State *maine = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    maine.name = @"Maine";
    
    City *portland = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    portland.name = @"Portland";
    portland.rank = @"Most populous";
    portland.state = maine;
    
    City *lewiston = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    lewiston.name = @"Lewiston";
    lewiston.rank = @"2nd most populous";
    lewiston.state = maine;
    
    City *bangor = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    bangor.name = @"Bangor";
    bangor.rank = @"3rd most populous";
    bangor.state = maine;
    
    City *southPortland = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    southPortland.name = @"South Portland";
    southPortland.rank = @"4th most populous";
    southPortland.state = maine;
    
    City *auburn = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    auburn.name = @"Auburn";
    auburn.rank = @"5th most populous";
    auburn.state = maine;
    
    
    State *maryland = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    maryland.name = @"Maryland";
    
    City *baltimore = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    baltimore.name = @"Baltimore";
    baltimore.rank = @"Most populous";
    baltimore.state = maryland;
    
    City *columbia = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    columbia.name = @"Columbia";
    columbia.rank = @"2nd most populous";
    columbia.state = maryland;
    
    City *germantown = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    germantown.name = @"Germantown";
    germantown.rank = @"3rd most populous";
    germantown.state = maryland;
    
    City *silverSpring = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    silverSpring.name = @"Silver Spring";
    silverSpring.rank = @"4th most populous";
    silverSpring.state = maryland;
    
    City *waldorf = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    waldorf.name = @"Waldorf";
    waldorf.rank = @"5th most populous";
    waldorf.state = maryland;
    
    
    State *massachusetts = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    massachusetts.name = @"Massachusetts";
    
    City *boston = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    boston.name = @"Boston";
    boston.rank = @"Most populous";
    boston.state = massachusetts;
    
    City *worcester = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    worcester.name = @"Worcester";
    worcester.rank = @"2nd most populous";
    worcester.state = massachusetts;
    
    City *springfield = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    springfield.name = @"Springfield";
    springfield.rank = @"3rd most populous";
    springfield.state = massachusetts;
    
    City *lowell = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    lowell.name = @"Lowell";
    lowell.rank = @"4th most populous";
    lowell.state = massachusetts;
    
    City *cambridge = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    cambridge.name = @"Cambridge";
    cambridge.rank = @"5th most populous";
    cambridge.state = massachusetts;
    
    
    State *michigan = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    michigan.name = @"Michigan";
    
    City *detroit = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    detroit.name = @"Detroit";
    detroit.rank = @"Most populous";
    detroit.state = michigan;
    
    City *grandRapids = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    grandRapids.name = @"Grand Rapids";
    grandRapids.rank = @"2nd most populous";
    grandRapids.state = michigan;
    
    City *warren = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    warren.name = @"Warren";
    warren.rank = @"3rd most populous";
    warren.state = michigan;
    
    City *sterlingHeights = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    sterlingHeights.name = @"Sterling Heights";
    sterlingHeights.rank = @"4th most populous";
    sterlingHeights.state = michigan;
    
    City *annArbor = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    annArbor.name = @"Ann Arbor";
    annArbor.rank = @"5th most populous";
    annArbor.state = michigan;
    
    
    State *minnesota = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    minnesota.name = @"Minnesota";
    
    City *minneapolis = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    minneapolis.name = @"Minneapolis";
    minneapolis.rank = @"Most populous";
    minneapolis.state = minnesota;
    
    City *saintPaul = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    saintPaul.name = @"Saint Paul";
    saintPaul.rank = @"2nd most populous";
    saintPaul.state = minnesota;
    
    City *rochester = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    rochester.name = @"Rochester";
    rochester.rank = @"3rd most populous";
    rochester.state = minnesota;
    
    City *duluth = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    duluth.name = @"Duluth";
    duluth.rank = @"4th most populous";
    duluth.state = minnesota;
    
    City *bloomington = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    bloomington.name = @"Bloomington";
    bloomington.rank = @"5th most populous";
    bloomington.state = minnesota;
    
    
    State *mississippi = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    mississippi.name = @"Mississippi";
    
    City *jackson = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    jackson.name = @"Jackson";
    jackson.rank = @"Most populous";
    jackson.state = mississippi;
    
    City *gulfport = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    gulfport.name = @"Gulfport";
    gulfport.rank = @"2nd most populous";
    gulfport.state = mississippi;
    
    City *hattiesburg = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    hattiesburg.name = @"Hattiesburg";
    hattiesburg.rank = @"3rd most populous";
    hattiesburg.state = mississippi;
    
    City *southaven = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    southaven.name = @"Southaven";
    southaven.rank = @"4th most populous";
    southaven.state = mississippi;
    
    City *biloxi = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    biloxi.name = @"Biloxi";
    biloxi.rank = @"5th most populous";
    biloxi.state = mississippi;
    
    
    State *missouri = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    missouri.name = @"Missouri";
    
    City *kansasCity1 = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    kansasCity1.name = @"Kansas City";
    kansasCity1.rank = @"Most populous";
    kansasCity1.state = missouri;
    
    City *saintLouis = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    saintLouis.name = @"Saint Louis";
    saintLouis.rank = @"2nd most populous";
    saintLouis.state = missouri;
    
    City *springfield1 = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    springfield1.name = @"Springfield";
    springfield1.rank = @"3rd most populous";
    springfield1.state = missouri;
    
    City *independence = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    independence.name = @"Independence";
    independence.rank = @"4th most populous";
    independence.state = missouri;
    
    City *columbia1 = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    columbia1.name = @"Columbia";
    columbia1.rank = @"5th most populous";
    columbia1.state = missouri;
    
    
    State *montana = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    montana.name = @"Montana";
    
    City *billings = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    billings.name = @"Billings";
    billings.rank = @"Most populous";
    billings.state = montana;
    
    City *missoula = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    missoula.name = @"Missoula";
    missoula.rank = @"2nd most populous";
    missoula.state = montana;
    
    City *greatFalls = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    greatFalls.name = @"Great Falls";
    greatFalls.rank = @"3rd most populous";
    greatFalls.state = montana;
    
    City *bozeman = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    bozeman.name = @"Bozeman";
    bozeman.rank = @"4th most populous";
    bozeman.state = montana;
    
    City *butte = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    butte.name = @"Butte";
    butte.rank = @"5th most populous";
    butte.state = montana;
    
    
    State *nebraska = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    nebraska.name = @"Nebraska";
    
    City *omaha = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    omaha.name = @"Omaha";
    omaha.rank = @"Most populous";
    omaha.state = nebraska;
    
    City *lincoln = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    lincoln.name = @"Lincoln";
    lincoln.rank = @"2nd most populous";
    lincoln.state = nebraska;
    
    City *bellevue = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    bellevue.name = @"Bellevue";
    bellevue.rank = @"3rd most populous";
    bellevue.state = nebraska;
    
    City *grandIsland = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    grandIsland.name = @"Grand Island";
    grandIsland.rank = @"4th most populous";
    grandIsland.state = nebraska;
    
    City *kearney = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    kearney.name = @"Kearney";
    kearney.rank = @"5th most populous";
    kearney.state = nebraska;
    
    
    State *nevada = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    nevada.name = @"Nevada";
    
    City *lasVegas = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    lasVegas.name = @"Las Vegas";
    lasVegas.rank = @"Most populous";
    lasVegas.state = nevada;
    
    City *henderson = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    henderson.name = @"Henderson";
    henderson.rank = @"2nd most populous";
    henderson.state = nevada;
    
    City *northLasVegas = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    northLasVegas.name = @"North Las Vegas";
    northLasVegas.rank = @"3rd most populous";
    northLasVegas.state = nevada;
    
    City *reno = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    reno.name = @"Reno";
    reno.rank = @"4th most populous";
    reno.state = nevada;
    
    City *sparks = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    sparks.name = @"Sparks";
    sparks.rank = @"5th most populous";
    sparks.state = nevada;
    
    
    State *newHampshire = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    newHampshire.name = @"New Hampshire";
    
    City *manchester = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    manchester.name = @"Manchester";
    manchester.rank = @"Most populous";
    manchester.state = newHampshire;
    
    City *nashua = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    nashua.name = @"Nashua";
    nashua.rank = @"2nd most populous";
    nashua.state = newHampshire;
    
    City *concord = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    concord.name = @"Concord";
    concord.rank = @"3rd most populous";
    concord.state = newHampshire;
    
    City *derry = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    derry.name = @"Derry";
    derry.rank = @"4th most populous";
    derry.state = newHampshire;
    
    City *rochester1 = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    rochester1.name = @"Rochester";
    rochester1.rank = @"5th most populous";
    rochester1.state = newHampshire;
    
    
    State *newJersey = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    newJersey.name = @"New Jersey";
    
    City *newark1 = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    newark1.name = @"Newark";
    newark1.rank = @"Most populous";
    newark1.state = newJersey;
    
    City *jerseyCity = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    jerseyCity.name = @"Jersey City";
    jerseyCity.rank = @"2nd most populous";
    jerseyCity.state = newJersey;
    
    City *paterson = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    paterson.name = @"Paterson";
    paterson.rank = @"3rd most populous";
    paterson.state = newJersey;
    
    City *elizabeth = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    elizabeth.name = @"Elizabeth";
    elizabeth.rank = @"4th most populous";
    elizabeth.state = newJersey;
    
    City *edison = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    edison.name = @"Edison";
    edison.rank = @"5th most populous";
    edison.state = newJersey;
    
    
    State *newMexico = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    newMexico.name = @"New Mexico";
    
    City *albuquerque = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    albuquerque.name = @"Albuquerque";
    albuquerque.rank = @"Most populous";
    albuquerque.state = newMexico;
    
    City *lasCruces = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    lasCruces.name = @"Las Cruces";
    lasCruces.rank = @"2nd most populous";
    lasCruces.state = newMexico;
    
    City *rioRancho = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    rioRancho.name = @"Rio Rancho";
    rioRancho.rank = @"3rd most populous";
    rioRancho.state = newMexico;
    
    City *santaFe = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    santaFe.name = @"Santa Fe";
    santaFe.rank = @"4th most populous";
    santaFe.state = newMexico;
    
    City *roswell = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    roswell.name = @"Roswell";
    roswell.rank = @"5th most populous";
    roswell.state = newMexico;
    
    
    State *newYork = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    newYork.name = @"New York";
    
    City *newYork1 = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    newYork1.name = @"New York";
    newYork1.rank = @"Most populous";
    newYork1.state = newYork;
    
    City *buffalo = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    buffalo.name = @"Buffalo";
    buffalo.rank = @"2nd most populous";
    buffalo.state = newYork;
    
    City *rochester2 = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    rochester2.name = @"Rochester";
    rochester2.rank = @"3rd most populous";
    rochester2.state = newYork;
    
    City *yonkers = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    yonkers.name = @"Yonkers";
    yonkers.rank = @"4th most populous";
    yonkers.state = newYork;
    
    City *syracuse = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    syracuse.name = @"Syracuse";
    syracuse.rank = @"5th most populous";
    syracuse.state = newYork;
    
    
    State *northCarolina = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    northCarolina.name = @"North Carolina";
    
    City *charlotte = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    charlotte.name = @"Charlotte";
    charlotte.rank = @"Most populous";
    charlotte.state = northCarolina;
    
    City *raleigh = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    raleigh.name = @"Raleigh";
    raleigh.rank = @"2nd most populous";
    raleigh.state = northCarolina;
    
    City *greensboro = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    greensboro.name = @"Greensboro";
    greensboro.rank = @"3rd most populous";
    greensboro.state = northCarolina;
    
    City *durham = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    durham.name = @"Durham";
    durham.rank = @"4th most populous";
    durham.state = northCarolina;
    
    City *winstonSalem = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    winstonSalem.name = @"Winston-Salem";
    winstonSalem.rank = @"5th most populous";
    winstonSalem.state = northCarolina;
    
    
    State *northDakota = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    northDakota.name = @"North Dakota";
    
    City *fargo = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    fargo.name = @"Fargo";
    fargo.rank = @"Most populous";
    fargo.state = northDakota;
    
    City *bismarck = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    bismarck.name = @"Bismarck";
    bismarck.rank = @"2nd most populous";
    bismarck.state = northDakota;
    
    City *grandForks = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    grandForks.name = @"Grand Forks";
    grandForks.rank = @"3rd most populous";
    grandForks.state = northDakota;
    
    City *minot = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    minot.name = @"Minot";
    minot.rank = @"4th most populous";
    minot.state = northDakota;
    
    City *westFargo = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    westFargo.name = @"West Fargo";
    westFargo.rank = @"5th most populous";
    westFargo.state = northDakota;
    
    
    State *ohio = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    ohio.name = @"Ohio";
    
    City *columbus1 = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    columbus1.name = @"Columbus";
    columbus1.rank = @"Most populous";
    columbus1.state = ohio;
    
    City *cleveland = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    cleveland.name = @"Cleveland";
    cleveland.rank = @"2nd most populous";
    cleveland.state = ohio;
    
    City *cincinnati = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    cincinnati.name = @"Cincinnati";
    cincinnati.rank = @"3rd most populous";
    cincinnati.state = ohio;
    
    City *toledo = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    toledo.name = @"Toledo";
    toledo.rank = @"4th most populous";
    toledo.state = ohio;
    
    City *akron = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    akron.name = @"Akron";
    akron.rank = @"5th most populous";
    akron.state = ohio;
    
    
    State *oklahoma = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    oklahoma.name = @"Oklahoma";
    
    City *oklahomaCity = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    oklahomaCity.name = @"Oklahoma City";
    oklahomaCity.rank = @"Most populous";
    oklahomaCity.state = oklahoma;
    
    City *tulsa = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    tulsa.name = @"Tulsa";
    tulsa.rank = @"2nd most populous";
    tulsa.state = oklahoma;
    
    City *norman = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    norman.name = @"Norman";
    norman.rank = @"3rd most populous";
    norman.state = oklahoma;
    
    City *brokenArrow = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    brokenArrow.name = @"Broken Arrow";
    brokenArrow.rank = @"4th most populous";
    brokenArrow.state = oklahoma;
    
    City *lawton = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    lawton.name = @"Lawton";
    lawton.rank = @"5th most populous";
    lawton.state = oklahoma;
    
    
    State *oregon = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    oregon.name = @"Oregon";
    
    City *portland1 = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    portland1.name = @"Portland";
    portland1.rank = @"Most populous";
    portland1.state = oregon;
    
    City *eugene = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    eugene.name = @"Eugene";
    eugene.rank = @"2nd most populous";
    eugene.state = oregon;
    
    City *salem = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    salem.name = @"Salem";
    salem.rank = @"3rd most populous";
    salem.state = oregon;
    
    City *gresham = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    gresham.name = @"Gresham";
    gresham.rank = @"4th most populous";
    gresham.state = oregon;
    
    City *hillsboro = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    hillsboro.name = @"Hillsboro";
    hillsboro.rank = @"5th most populous";
    hillsboro.state = oregon;
    
    
    State *pennsylvania = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    pennsylvania.name = @"Pennsylvania";
    
    City *philadelphia = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    philadelphia.name = @"Philadelphia";
    philadelphia.rank = @"Most populous";
    philadelphia.state = pennsylvania;
    
    City *pittsburgh = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    pittsburgh.name = @"Pittsburgh";
    pittsburgh.rank = @"2nd most populous";
    pittsburgh.state = pennsylvania;
    
    City *allentown = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    allentown.name = @"Allentown";
    allentown.rank = @"3rd most populous";
    allentown.state = pennsylvania;
    
    City *erie = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    erie.name = @"Erie";
    erie.rank = @"4th most populous";
    erie.state = pennsylvania;
    
    City *reading = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    reading.name = @"Reading";
    reading.rank = @"5th most populous";
    reading.state = pennsylvania;
    
    
    State *rhodeIsland = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    rhodeIsland.name = @"Rhode Island";
    
    City *providence = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    providence.name = @"Providence";
    providence.rank = @"Most populous";
    providence.state = rhodeIsland;
    
    City *warwick = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    warwick.name = @"Warwick";
    warwick.rank = @"2nd most populous";
    warwick.state = rhodeIsland;
    
    City *cranston = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    cranston.name = @"Cranston";
    cranston.rank = @"3rd most populous";
    cranston.state = rhodeIsland;
    
    City *pawtucket = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    pawtucket.name = @"Pawtucket";
    pawtucket.rank = @"4th most populous";
    pawtucket.state = rhodeIsland;
    
    City *eastProvidence = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    eastProvidence.name = @"East Providence";
    eastProvidence.rank = @"5th most populous";
    eastProvidence.state = rhodeIsland;
    
    
    State *southCarolina = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    southCarolina.name = @"South Carolina";
    
    City *columbia2 = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    columbia2.name = @"Columbia";
    columbia2.rank = @"Most populous";
    columbia2.state = southCarolina;
    
    City *charleston = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    charleston.name = @"Charleston";
    charleston.rank = @"2nd most populous";
    charleston.state = southCarolina;
    
    City *greenville = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    greenville.name = @"Greenville";
    greenville.rank = @"3rd most populous";
    greenville.state = southCarolina;
    
    City *mountPleasant = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    mountPleasant.name = @"Mount Pleasant";
    mountPleasant.rank = @"4th most populous";
    mountPleasant.state = southCarolina;
    
    City *rockHill = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    rockHill.name = @"Rock Hill";
    rockHill.rank = @"5th most populous";
    rockHill.state = southCarolina;
    
    
    State *southDakota = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    southDakota.name = @"South Dakota";
    
    City *siouxFalls = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    siouxFalls.name = @"Sioux Falls";
    siouxFalls.rank = @"Most populous";
    siouxFalls.state = southDakota;
    
    City *rapidCity = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    rapidCity.name = @"Rapid City";
    rapidCity.rank = @"2nd most populous";
    rapidCity.state = southDakota;
    
    City *aberdeen = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    aberdeen.name = @"Aberdeen";
    aberdeen.rank = @"3rd most populous";
    aberdeen.state = southDakota;
    
    City *brookings = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    brookings.name = @"Brookings";
    brookings.rank = @"4th most populous";
    brookings.state = southDakota;
    
    City *watertown = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    watertown.name = @"Watertown";
    watertown.rank = @"5th most populous";
    watertown.state = southDakota;
    
    
    State *tennessee = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    tennessee.name = @"Tennessee";
    
    City *memphis = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    memphis.name = @"Memphis";
    memphis.rank = @"Most populous";
    memphis.state = tennessee;
    
    City *nashville = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    nashville.name = @"Nashville";
    nashville.rank = @"2nd most populous";
    nashville.state = tennessee;
    
    City *knoxville = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    knoxville.name = @"Knoxville";
    knoxville.rank = @"3rd most populous";
    knoxville.state = tennessee;
    
    City *chattanooga = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    chattanooga.name = @"Chattanooga";
    chattanooga.rank = @"4th most populous";
    chattanooga.state = tennessee;
    
    City *clarksville = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    clarksville.name = @"Clarksville";
    clarksville.rank = @"5th most populous";
    clarksville.state = tennessee;
    
    
    State *texas = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    texas.name = @"Texas";
    
    City *houston = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    houston.name = @"Houston";
    houston.rank = @"Most populous";
    houston.state = texas;
    
    City *sanAntonio = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    sanAntonio.name = @"San Antonio";
    sanAntonio.rank = @"2nd most populous";
    sanAntonio.state = texas;
    
    City *dallas = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    dallas.name = @"Dallas";
    dallas.rank = @"3rd most populous";
    dallas.state = texas;
    
    City *austin = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    austin.name = @"Austin";
    austin.rank = @"4th most populous";
    austin.state = texas;
    
    City *fortWorth = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    fortWorth.name = @"Fort Worth";
    fortWorth.rank = @"5th most populous";
    fortWorth.state = texas;
    
    
    State *utah = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    utah.name = @"Utah";
    
    City *saltLakeCity = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    saltLakeCity.name = @"Salt Lake City";
    saltLakeCity.rank = @"Most populous";
    saltLakeCity.state = utah;
    
    City *westValleyCity = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    westValleyCity.name = @"West Valley City";
    westValleyCity.rank = @"2nd most populous";
    westValleyCity.state = utah;
    
    City *provo = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    provo.name = @"Provo";
    provo.rank = @"3rd most populous";
    provo.state = utah;
    
    City *westJordan = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    westJordan.name = @"West Jordan";
    westJordan.rank = @"4th most populous";
    westJordan.state = utah;
    
    City *orem = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    orem.name = @"Orem";
    orem.rank = @"5th most populous";
    orem.state = utah;
    
    
    State *vermont = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    vermont.name = @"Vermont";
    
    City *burlington = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    burlington.name = @"Burlington";
    burlington.rank = @"Most populous";
    burlington.state = vermont;
    
    City *essex = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    essex.name = @"Essex";
    essex.rank = @"2nd most populous";
    essex.state = vermont;
    
    City *southBurlington = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    southBurlington.name = @"South Burlington";
    southBurlington.rank = @"3rd most populous";
    southBurlington.state = vermont;
    
    City *colchester = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    colchester.name = @"Colchester";
    colchester.rank = @"4th most populous";
    colchester.state = vermont;
    
    City *rutland = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    rutland.name = @"Rutland";
    rutland.rank = @"5th most populous";
    rutland.state = vermont;
    
    
    State *virginia = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    virginia.name = @"Virginia";
    
    City *virginiaBeach = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    virginiaBeach.name = @"Virginia Beach";
    virginiaBeach.rank = @"Most populous";
    virginiaBeach.state = virginia;
    
    City *norfolk = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    norfolk.name = @"Norfolk";
    norfolk.rank = @"2nd most populous";
    norfolk.state = virginia;
    
    City *chesapeake = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    chesapeake.name = @"Chesapeake";
    chesapeake.rank = @"3rd most populous";
    chesapeake.state = virginia;
    
    City *richmond = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    richmond.name = @"Richmond";
    richmond.rank = @"4th most populous";
    richmond.state = virginia;
    
    City *newportNews = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    newportNews.name = @"Newport News";
    newportNews.rank = @"5th most populous";
    newportNews.state = virginia;
    
    
    State *washington = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    washington.name = @"Washington";
    
    City *seattle = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    seattle.name = @"Seattle";
    seattle.rank = @"Most populous";
    seattle.state = washington;
    
    City *spokane = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    spokane.name = @"Spokane";
    spokane.rank = @"2nd most populous";
    spokane.state = washington;
    
    City *tacoma = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    tacoma.name = @"Tacoma";
    tacoma.rank = @"3rd most populous";
    tacoma.state = washington;
    
    City *vancouver = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    vancouver.name = @"Vancouver";
    vancouver.rank = @"4th most populous";
    vancouver.state = washington;
    
    City *bellevue1 = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    bellevue1.name = @"Bellevue";
    bellevue1.rank = @"5th most populous";
    bellevue1.state = washington;
    
    
    State *westVirginia = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    westVirginia.name = @"West Virginia";
    
    City *charleston1 = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    charleston1.name = @"Charleston";
    charleston1.rank = @"Most populous";
    charleston1.state = westVirginia;
    
    City *huntington = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    huntington.name = @"Huntington";
    huntington.rank = @"2nd most populous";
    huntington.state = westVirginia;
    
    City *parkersburg = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    parkersburg.name = @"Parkersburg";
    parkersburg.rank = @"3rd most populous";
    parkersburg.state = westVirginia;
    
    City *morgantown = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    morgantown.name = @"Morgantown";
    morgantown.rank = @"4th most populous";
    morgantown.state = westVirginia;
    
    City *wheeling = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    wheeling.name = @"Wheeling";
    wheeling.rank = @"5th most populous";
    wheeling.state = westVirginia;
    
    
    State *wisconsin = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    wisconsin.name = @"Wisconsin";
    
    City *milwaukee = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    milwaukee.name = @"Milwaukee";
    milwaukee.rank = @"Most populous";
    milwaukee.state = wisconsin;
    
    City *madison = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    madison.name = @"Madison";
    madison.rank = @"2nd most populous";
    madison.state = wisconsin;
    
    City *greenBay = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    greenBay.name = @"Green Bay";
    greenBay.rank = @"3rd most populous";
    greenBay.state = wisconsin;
    
    City *kenosha = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    kenosha.name = @"Kenosha";
    kenosha.rank = @"4th most populous";
    kenosha.state = wisconsin;
    
    City *racine = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    racine.name = @"Racine";
    racine.rank = @"5th most populous";
    racine.state = wisconsin;
    
    
    State *wyoming = [NSEntityDescription insertNewObjectForEntityForName:stateEntity inManagedObjectContext:self.managedObjectContext];
    wyoming.name = @"Wyoming";
    
    City *cheyenne = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    cheyenne.name = @"Cheyenne";
    cheyenne.rank = @"Most populous";
    cheyenne.state = wyoming;
    
    City *casper = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    casper.name = @"Casper";
    casper.rank = @"2nd most populous";
    casper.state = wyoming;
    
    City *laramie = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    laramie.name = @"Laramie";
    laramie.rank = @"3rd most populous";
    laramie.state = wyoming;
    
    City *gillette = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    gillette.name = @"Gillette";
    gillette.rank = @"4th most populous";
    gillette.state = wyoming;
    
    City *rockSprings = [NSEntityDescription insertNewObjectForEntityForName:cityEntity inManagedObjectContext:self.managedObjectContext];
    rockSprings.name = @"Rock Springs";
    rockSprings.rank = @"5th most populous";
    rockSprings.state = wyoming;
}

@end
