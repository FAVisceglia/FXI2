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

// Array of the search results
@property (copy, nonatomic) NSArray *searchResults;

// Search controller
@property (strong, nonatomic) UISearchController *searchController;

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
    
    [self setSearchController:[[UISearchController alloc] initWithSearchResultsController:nil]];
    [[self searchController] setSearchResultsUpdater:self];
    [[self searchController] setDimsBackgroundDuringPresentation:NO];
    
    [[[self searchController] searchBar] setFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth([[self tableView] frame]), 44.0f)];
    [[[self searchController] searchBar] setSearchBarStyle:UISearchBarStyleMinimal];
    [[[self searchController] searchBar] setPlaceholder:@"Search Presentations"];

    [[self tableView] setTableHeaderView:[[self searchController] searchBar]];
    [[[self tableView] tableHeaderView] setBackgroundColor:[UIColor whiteColor]];
    [[self tableView] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [[self tableView] setAllowsSelection:YES];
    [[self tableView] setAllowsSelectionDuringEditing:YES];
    [[self tableView] setDelegate:self];
    [[self tableView] setDataSource:self];
}

#pragma mark - Table View datasource

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

#pragma mark - Table View delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FXIPresentation *presentation = nil;
    
    presentation = [[self searchResults] objectAtIndex:[indexPath row]];
    
    NSDictionary *userInfo = @{ @"selection" : presentation };
    
    NSLog(@"Cell selected");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectionMadeNotification" object:nil userInfo:userInfo];
}

#pragma mark - Search Display Results delegate

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
 
@end
