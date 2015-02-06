//
//  SearchResultsTableViewController.h
//  Presentations
//
//  Created by Visceglia Anthony on 2/6/15.
//  Copyright (c) 2015 FXI, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultsTableViewController : UITableViewController <UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate>

@property (copy, nonatomic) NSArray *fullResults;

@end
