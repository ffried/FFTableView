# FFTableView

FFTableView contains some easy-to-use classes for creating UITableViews with CoreData's NSFetchedResultsController.
Save many lines of code by just using standard code and only overriding what you really need.

# How it works

## FFTableViewController
For standard usage just subclass `FFTableViewController` and use it as you would generally use a normal UITableViewController subclass.
However, there are a few differences. `FFTableViewController` comes with two properties:

	@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
	@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;


If your `AppDelegate` responds to `managedObjectContext` you don't need to set it manually. Otherwise you do have to set it manually for example in the `- (void)initialize;` method, which get's called no matter if you use XIBs or create your instances from code.

Furthermore, `FFTableViewController` has two more properties and a convenience method to assign them:

	@property (nonatomic, strong) FFTableViewDataSource *tableViewDataSource;
	@property (nonatomic, strong) FFNSFetchedResultsControllerDelegate *fetchedResultsControllerDelegate;
	
	- (void)setupWithFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController tableView:(UITableView *)tableView fetchedResultsControllerDelegate:(id<FFNSFetchedResultsControllerDelegate>)frcdelegate tableViewDataSourceDelegate:(id<FFTableViewDataSourceDelegate>)tvdsdelegate;

The `FFTableViewController` is also automatically set as the tableview's delegate.

If you should not want the CoreData part of FFTableView (such as if you only want the expandable table view classes) you can turn it off by setting the `#define FFTableViewUseCoreData 1` to 0.
Also, FFTableView fixes the iOS 7 bug that the cell doesn't get deselected when using interactive dismiss in a navigation controller. You can also turn this off by setting `#define FFTableViewShouldFixIOS7InteractiveDeselectBug 1` to 0.
Both defines are in `FFTableViewController.h`.


## FFTableViewDataSource and FFNSFetchedResultsControllerDelegate
The `FFTableViewDataSource` is a data source class which handles all the data source methods. It has, however, a delegate you need to implement to provide some information needed:

	@protocol FFTableViewDataSourceDelegate <NSObject>
	@required
	- (NSString *)tableView:(UITableView *)tableView cellIdentifierForRowAtIndexPath:(NSIndexPath *)indexPath;
	- (void)tableView:(UITableView *)tableView configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath withObject:(id)object;
	
	@optional
	- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
	- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section;
	
	- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
	- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath;
	
	- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index;
	- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView;
	
	- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
	- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;
	@end

If you don't implement the optional methods it'll ask the `NSFetchedResultsController` for it (if possible) or just return the default value.

The `FFNSFetchedResultsControllerDelegate` implements all the delegate methods of the `NSFetchedResultsController`. It also has a delegate which needs to be conform to the `FFNSFetchedResultsControllerDelegate` protocol. This protocol does not define any additional methods and just adopts the `NSFetchedResultsControllerDelegate` protocol.
If you implement one of the methods the `FFNSFetchedResultsControllerDelegate` will call it either before or after it has done its work. Here's when which method gets called:

	// Called before
	- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller;
	
	// Called after
	- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type;
		 
	// Called after
	- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath;
	
	// Called after
	- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller;
	
	// If the delegate implements it use the delegate's string, otherwise use the NSFetchedResultsController's string
	- (NSString *)controller:(NSFetchedResultsController *)controller sectionIndexTitleForSectionName:(NSString *)sectionName;

The convenience method mentioned above sets up both properties and the delegates so you only need to call this method.

## FFExpandableTableViewController and FFExpandableTableViewCell
If you want a tableview in which you can expand the cell make your tableview controller a subclass of `FFExpandableTableViewController` and your cells (for which you need a subclass here) a subclass of `FFExpandableTableViewCell`.
`FFExpandableTableViewController` is a subclass of `FFTableViewController` so it's easy for you to use it with core data as well.
With that, the `FFExpandableTableViewController` is also the tableview's delegate and there's an important thing to notice here. `FFExpandableTableViewController` uses the `- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath` method to expand cells. That means, that if you need this method as well, you need to override it and call super in your subclass.

There are also two methods in the `FFExpandableTableViewController` to managed expanded index paths:

	- (BOOL)isIndexPathExpanded:(NSIndexPath *)indexPath;
	- (void)setIndexPath:(NSIndexPath *)indexPath expanded:(BOOL)expanded;

To allow multiple cells to be expanded just set this property to `YES` for example in the `- (void)initialize` method:

	@property (nonatomic, assign) BOOL allowsMultipleExpandedCells;

For the `FFExpandedTableViewCell` there are also a few things to remember. First, there's also a `- (void)initialize` method which works the same as with all the other classes in FFTableView.
Then, there are two properties you need to fill this cell:

	@property (nonatomic, strong) UIView *collapsedView; // Always displayed
	@property (nonatomic, strong) UIView *expandedView;  // Displayed below collapsed view when expanded

The `collapsedView` is always displayed. It's like the `contentView` property of a normal `UITableViewCell`. The `expandedView` is a view, which is placed just below the `collapsedView`. When the cell gets expanded the row height updates animated. This requires you to also implement `- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath` in your tableview controller. The `FFExpandableTableViewCell` has a method `- (void)configureWithObject:(id)object expanded:(BOOL)expanded` with which you can configure the cell. It's important that your subclasses have this method implemented exactly with this signature (you can change the type from id to whatever you need, though). Also it's important that you call super at the beginning and `[self layoutIfNeeded];` at the end of your implementation.
For the calculation of the height using AutoLayout I recommend having a look a [this blog post](http://blog.amyworrall.com/post/66085151655/using-auto-layout-to-calculate-table-cell-height). If you target iOS 7 and your tableview has a lot of rows consider also implementing `- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath`. With that the tableview loads significantly faster.

## Sample Project
There's a sample project included in which you can see both, the `FFExpandableTableViewController` and the normal `FFTableViewController` in action.

# To Do
There are still some more or less random `unsatisfiable constraints` exceptions coming along with the expandable tableview classes. However, they don't cause a crash.

# License
The FFTableView is under MIT license. See LICENSE.md file for the full license.
