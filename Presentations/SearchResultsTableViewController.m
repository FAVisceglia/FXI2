//
//  SearchResultsTableViewController.m
//  Presentations
//
//  Created by Visceglia Anthony on 2/6/15.
//  Copyright (c) 2015 FXI, Inc. All rights reserved.
//

#import "SearchResultsTableViewController.h"
#import "PresentationsCollectionViewController.h"
#import "FXIPresentation.h"


@interface SearchResultsTableViewController()

#pragma mark - Private Properties

// Array of the objects to represent in the table
@property (copy, nonatomic) NSArray *searchResults;

// Search controller
@property (strong, nonatomic) UISearchController *searchController;

// Primary view controller
@property (strong, nonatomic) PresentationsCollectionViewController *mainController;

@end


#pragma mark

@implementation SearchResultsTableViewController

#pragma mark - Getters

// Getter for the filtered faqs array
- (NSArray *)searchResults
{
    // Lazy array instantiation
    if (!_searchResults)
    {
        _searchResults = [[NSArray alloc] init];
    }
    
    return _searchResults;
}

#pragma mark - Delegation

// View controller lifecycle; message sent whenever view is done loading
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Convoluted way of getting the main window's active view controller
    [self setMainController:(PresentationsCollectionViewController *)((UINavigationController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController]).topViewController];
    
    [self setSearchController:[[UISearchController alloc] initWithSearchResultsController:nil]];
    [[self searchController] setSearchResultsUpdater:self];
    
    [[[self searchController] searchBar] setFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth([[self tableView] frame]), 44.0f)];
    [[[self searchController] searchBar] setSearchBarStyle:UISearchBarStyleMinimal];
    [[[self searchController] searchBar] setPlaceholder:@"Search Presentations"];
    [[[self searchController] searchBar] setDelegate:self];

    [[self tableView] setTableHeaderView:[[self searchController] searchBar]];
    [[self tableView] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [[self tableView] setAllowsSelection:YES];
    [[self tableView] setAllowsSelectionDuringEditing:YES];
    [[self tableView] setDelegate:self];
    [[self tableView] setDataSource:self];
}

#pragma mark - Table View Data Source

// Return the number of sections in the table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Return the number of rows in a given section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self searchResults] count];
}

// Return the cell (data) at a given index path (populates the table)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Reuse the cell identified in the storyboard for all table cells
//    UITableViewCell *cell = [[self tableView] dequeueReusableCellWithIdentifier:@"Search Results Cell"];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Search Results Cell"];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
    [cell setUserInteractionEnabled:YES];
    [[cell textLabel] setEnabled:YES];
    
    FXIPresentation *presentation = nil;
    
    presentation = [[self searchResults] objectAtIndex:[indexPath row]];

    [[cell textLabel] setText:[[presentation title] substringFromIndex:3]];
    [[cell textLabel] setTextColor:[UIColor colorWithRed:(18.0/255.0)
                                                   green:(52.0/255.0)
                                                    blue:(88.0/255.0)
                                                   alpha:1.0f]];
    
    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FXIPresentation *presentation = nil;
    
    presentation = [[self searchResults] objectAtIndex:[indexPath row]];
    
    NSURL *url = [presentation presentationURL];
    UIDocumentInteractionController *controller = [UIDocumentInteractionController interactionControllerWithURL:url];
    [controller setDelegate:[self mainController]];
    [controller presentPreviewAnimated:YES];
}

#pragma mark - Document Interaction Delegate

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return [self mainController];
}

#pragma mark - Navigation

#pragma mark - Target Actions

#pragma mark - Private Methods
/**
 - (void)preferredFontsChanged:(NSNotificationCenter *)notification
 {
 // Called whenever a UIContentSizeCategoryDidChangeNotification is sent by the system
 // Addresses situations where the view is already loaded and then the user changes their font accessibility options
 
 // Reload the table view (the table view data source grabs the preferred fonts)
 [[self tableView] reloadData];
 }**/
/**
- (void)filterContentForSearchText:(NSString *)searchText
{
    // Filtering algorithm for search queries
    
    // Reset any previous results
    [self setSearchResults:nil];
    
    // Use a predicate to parse search query and populate filtered results
    // "name" refers to the property to search against
    // "contains[c] means use a CONTAIN search logic, case-insensitive
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title contains[c] %@", searchText];
    [self setSearchResults:[((PresentationsCollectionViewController *)self.parentViewController).presentations filteredArrayUsingPredicate:predicate]];
}**/

#pragma mark - UISearchDisplayResults delegate

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    // Filtering algorithm for search queries
    
    // Reset any previous results
    [self setSearchResults:nil];
    
    // Use a predicate to parse search query and populate filtered results
    // "name" refers to the property to search against
    // "contains[c] means use a CONTAIN search logic, case-insensitive
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title contains[c] %@", [[[self searchController] searchBar] text]];
    [self setSearchResults:[[self fullResults] filteredArrayUsingPredicate:predicate]];
    
    [[self tableView] reloadData];
}

#pragma mark - UISearchBar delegate

/**
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}
 */
 
@end
