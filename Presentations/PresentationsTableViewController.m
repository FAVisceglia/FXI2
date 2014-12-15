//
//  PresentationsTableViewController.m
//  Presentations
//
//  Created by Visceglia Anthony on 12/2/14.
//  Copyright (c) 2014 FXI, Inc. All rights reserved.
//

#import "PresentationsTableViewController.h"
#import "FXIPresentation.h"

@interface PresentationsTableViewController()

#pragma mark - Private Properties

// Array of the objects to represent in the table
@property (copy, nonatomic) NSMutableArray *presentations;

// Filtered array of the objects to represent in the search results table
@property (copy, nonatomic) NSArray *filteredPresentations;

@end

#pragma mark

@implementation PresentationsTableViewController

#pragma mark - Constants

// Convert to enum?
#define CELL_BUFFER_SPACING 15.0

#pragma mark - Getters

// Getter for the faqs array
- (NSMutableArray *)presentations
{
    // Lazy array instantiation
    if (!_presentations)
    {
        _presentations = [[NSMutableArray alloc] init];
    }
    
    return _presentations;
}

// Getter for the filtered faqs array
- (NSArray *)filteredPresentations
{
    // Lazy array instantiation
    if (!_filteredPresentations)
    {
        _filteredPresentations = [[NSArray alloc] init];
    }
    
    return _filteredPresentations;
}

#pragma mark - Delegation

// View controller lifecycle; message sent whenever view is done loading
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    FXIPresentation *presentation = nil;
    
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"01 Corporate Overview"
                                             withExtension:@"pdf"];
    if (fileURL)
    {
        presentation = [[FXIPresentation alloc] initWithURL:fileURL];
        [[self presentations] addObject:presentation];
    }
    
    fileURL = [[NSBundle mainBundle] URLForResource:@"02 FXI Overview-TECH"
                                      withExtension:@"pdf"];
    if (fileURL)
    {
        presentation = [[FXIPresentation alloc] initWithURL:fileURL];
        [[self presentations] addObject:presentation];
    }
    
    fileURL = [[NSBundle mainBundle] URLForResource:@"03 Activus Presentation"
                                      withExtension:@"pdf"];
    if (fileURL)
    {
        presentation = [[FXIPresentation alloc] initWithURL:fileURL];
        [[self presentations] addObject:presentation];
    }
    
    fileURL = [[NSBundle mainBundle] URLForResource:@"04 Aerus Presentation"
                                      withExtension:@"pdf"];
    if (fileURL)
    {
        presentation = [[FXIPresentation alloc] initWithURL:fileURL];
        [[self presentations] addObject:presentation];
    }
    
    fileURL = [[NSBundle mainBundle] URLForResource:@"05 Altus Presentation"
                                      withExtension:@"pdf"];
    if (fileURL)
    {
        presentation = [[FXIPresentation alloc] initWithURL:fileURL];
        [[self presentations] addObject:presentation];
    }
    
    fileURL = [[NSBundle mainBundle] URLForResource:@"06 Cores Collection with Script"
                                      withExtension:@"pdf"];
    if (fileURL)
    {
        presentation = [[FXIPresentation alloc] initWithURL:fileURL];
        [[self presentations] addObject:presentation];
    }
    
    fileURL = [[NSBundle mainBundle] URLForResource:@"07 Cores Collections"
                                      withExtension:@"pdf"];
    if (fileURL)
    {
        presentation = [[FXIPresentation alloc] initWithURL:fileURL];
        [[self presentations] addObject:presentation];
    }
    
    fileURL = [[NSBundle mainBundle] URLForResource:@"08 MAXPERM Presentation"
                                      withExtension:@"pdf"];
    if (fileURL)
    {
        presentation = [[FXIPresentation alloc] initWithURL:fileURL];
        [[self presentations] addObject:presentation];
    }
    
    fileURL = [[NSBundle mainBundle] URLForResource:@"09 MemGel Presentation"
                                      withExtension:@"pdf"];
    if (fileURL)
    {
        presentation = [[FXIPresentation alloc] initWithURL:fileURL];
        [[self presentations] addObject:presentation];
    }
    
    fileURL = [[NSBundle mainBundle] URLForResource:@"10 TRF System"
                                      withExtension:@"pdf"];
    if (fileURL)
    {
        presentation = [[FXIPresentation alloc] initWithURL:fileURL];
        [[self presentations] addObject:presentation];
    }
    
    fileURL = [[NSBundle mainBundle] URLForResource:@"11 TRF System with Foams"
                                      withExtension:@"pdf"];
    if (fileURL)
    {
        presentation = [[FXIPresentation alloc] initWithURL:fileURL];
        [[self presentations] addObject:presentation];
    }
    
    // Hides search bar on view load by offsetting the table (scrolling it down)
    [[self tableView] setContentOffset:CGPointMake(0, [[[self searchDisplayController] searchBar] frame].size.height - [[self tableView] contentOffset].y)];
    
    // Disables autocorrect and autocapitalization for the searchbar
    [[[self searchDisplayController] searchBar] setAutocorrectionType:UITextAutocorrectionTypeNo];
    [[[self searchDisplayController] searchBar] setAutocapitalizationType:UITextAutocapitalizationTypeNone];
}

// View controller lifecycle; message sent whenever view will appear on screen
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /**
     // Add a notification that calls the given method when the user changes their font settings
     [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(preferredFontsChanged:)
     name:UIContentSizeCategoryDidChangeNotification
     object:nil];**/
}

// View controller lifecycle; message sent whenever view will disappear off screen
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    /**
     // Removes the notification (don't listen when the view isn't on screen)
     [[NSNotificationCenter defaultCenter] removeObserver:self
     name:UIContentSizeCategoryDidChangeNotification
     object:nil];**/
}

// View controller lifecycle; message sent when OS has a memory warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

// Message sent when search string (query) changes
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // Run the filtering algorithm
    [self filterContentForSearchText:searchString
                             inScope:[[[[self searchDisplayController] searchBar] scopeButtonTitles] objectAtIndex:[[[self searchDisplayController] searchBar] selectedScopeButtonIndex]]];
    
    // Returning YES means the table should reload its cells
    return YES;
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
    // If the tableview being passed is the search results table, use filtered count
    if (tableView == [[self searchDisplayController] searchResultsTableView])
    {
        return [[self filteredPresentations] count];
    }
    // Else (the tableview is normal), use full array count
    else
    {
        return [[self presentations] count];
    }
}

/**
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle;
    
    switch (section)
    {
        case 0:
            sectionTitle = nil;
            break;
        case 1:
            sectionTitle = @"Pressure Mapping Videos";
            break;
        default:
            sectionTitle = nil;
    }
    
    return sectionTitle;
}**/

// Return the cell (data) at a given index path (populates the table)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Reuse the cell identified in the storyboard for all table cells
    UITableViewCell *cell = [[self tableView] dequeueReusableCellWithIdentifier:@"Presentation Cell"];
    
    FXIPresentation *presentation = nil;
    
    // Determine the object in the table view (or search results table view) for the given indexpath
    if (tableView == [[self searchDisplayController] searchResultsTableView])
    {
        presentation = [[self filteredPresentations] objectAtIndex:[indexPath row]];
    }
    else
    {
        presentation = [[self presentations] objectAtIndex:[indexPath row]];
    }
    
    /**    // Set cell contents and parameters
     [[cell textLabel] setLineBreakMode:NSLineBreakByWordWrapping];
     [[cell textLabel] setNumberOfLines:0];
     [[cell textLabel] setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];**/
    [[cell textLabel] setText:[[presentation title] substringFromIndex:3]];
    [[cell textLabel] setTextColor:[UIColor colorWithRed:(18.0/255.0)
                                                   green:(52.0/255.0)
                                                    blue:(88.0/255.0)
                                                   alpha:1.0f]];
    
    return cell;
}

#pragma mark - Table View Delegate
/**
 // Return the row height for a given indexpath (cell)
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 FXIVideo *test = nil;
 
 // Same logic as before, get the object at the indexpath of either search results or regular table
 if (tableView == [[self searchDisplayController] searchResultsTableView])
 {
 test = [[self filteredVideos] objectAtIndex:[indexPath row]];
 }
 else
 {
 test = [[self videos] objectAtIndex:[indexPath row]];
 }
 
 // The string that will go in the cell
 NSString *cellText = [test title];
 // The attributes to apply to the string (which can affect its size)
 NSDictionary *attributes = @{ NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleBody] };
 // The frame of the text, determined by getting the rect that will contain the text
 UITableViewCell *cell = [[self tableView] dequeueReusableCellWithIdentifier:@"Video Cell"];
 CGRect frame = [cellText boundingRectWithSize:CGSizeMake((CGRectGetWidth([cell contentView].bounds)), CGFLOAT_MAX)
 options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
 attributes:attributes
 context:nil];
 // This cell serves no purpose except to establish the content view, so dealloc manually
 cell = nil;
 
 // Return the height (rounded up to integer) plus a static buffer
 return ceilf(CGRectGetHeight(frame) + CELL_BUFFER_SPACING);
 }**/
/**
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    //    [view setTintColor:[UIColor colorWithRed:70.0f/255.0f green:133.0f/255.0f blue:197.0f/255.0f alpha:1.0f]];
    UITableViewHeaderFooterView *sectionHeader = (UITableViewHeaderFooterView *)view;
    [[sectionHeader textLabel] setTextColor:[UIColor colorWithRed:(18.0/255.0)
                                                            green:(52.0/255.0)
                                                             blue:(88.0/255.0)
                                                            alpha:1.0f]];
}**/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FXIPresentation *presentation = nil;
    
    if (tableView == [[self searchDisplayController] searchResultsTableView])
    {
        presentation = [[self filteredPresentations] objectAtIndex:[indexPath row]];
    }
    else
    {
        presentation = [[self presentations] objectAtIndex:[indexPath row]];
    }
    
    NSURL *url = [presentation presentationURL];
    UIDocumentInteractionController *controller = [UIDocumentInteractionController interactionControllerWithURL:url];
    [controller setDelegate:self];
    [controller presentPreviewAnimated:YES];
}

#pragma mark - Document Interaction Delegate

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return [self navigationController];
}

#pragma mark - Navigation
/**
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Invoked when a segue in the navigation controller heirarchy occurs
 
 // If the segue is the expected (ID from storyboard)
 if ([[segue identifier] isEqualToString:@"Segue to Video"])
 {
 // Get the viewcontroller we are going to
 FAQAnswerViewController *avc = [segue destinationViewController];
 // The cell's object
 FrequentlyAskedQuestion *faq = nil;
 // The cell's index
 NSIndexPath *indexPath = nil;
 
 // If using the search results table view...
 if (self.searchDisplayController.active)
 {
 // Get the indexpath for the selected row
 indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
 // Get the object at the selected row index
 faq = [[self filteredFaqs] objectAtIndex:[indexPath row]];
 }
 // Else using the normal table view...
 else
 {
 // Same logic as above
 indexPath = [self.tableView indexPathForSelectedRow];
 faq = [[self faqs] objectAtIndex:[indexPath row]];
 }
 
 // Set a public property of the destination view controller to be used in that view
 [avc setFaq:faq];
 }
 }**/

#pragma mark - Target Actions

- (IBAction)searchButtonTouched:(UIBarButtonItem *)sender
{
    [[self tableView] setContentOffset:CGPointMake(0.0f, -self.tableView.contentInset.top)
                              animated:NO];
    [[self searchDisplayController] setActive:YES
                                     animated:YES];
    [[[self searchDisplayController] searchBar] becomeFirstResponder];
}

#pragma mark - Private Methods
/**
 - (void)preferredFontsChanged:(NSNotificationCenter *)notification
 {
 // Called whenever a UIContentSizeCategoryDidChangeNotification is sent by the system
 // Addresses situations where the view is already loaded and then the user changes their font accessibility options
 
 // Reload the table view (the table view data source grabs the preferred fonts)
 [[self tableView] reloadData];
 }**/

- (void)filterContentForSearchText:(NSString *)searchText inScope:(NSString *)scope
{
    // Filtering algorithm for search queries
    
    // Reset any previous results
    [self setFilteredPresentations:nil];
    
    // Use a predicate to parse search query and populate filtered results
    // "name" refers to the property to search against
    // "contains[c] means use a CONTAIN search logic, case-insensitive
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title contains[c] %@", searchText];
    [self setFilteredPresentations:[[self presentations] filteredArrayUsingPredicate:predicate]];
}

@end
