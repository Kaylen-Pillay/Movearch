//
//  MSHomeViewController.m
//  Movearch
//
//  Created by Travis Pillay on 2019/04/08.
//  Copyright © 2019 Takealot Grad Team. All rights reserved.
//

#import "MSHomeViewController.h"

@interface MSHomeViewController ()

@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSString *searchTerm;

@end

@implementation MSHomeViewController

- (instancetype) init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        UISearchController *search = self.searchController;
        
        search = [[UISearchController alloc] initWithSearchResultsController:nil];
        search.obscuresBackgroundDuringPresentation = NO;
        search.searchResultsUpdater = self;
        search.searchBar.delegate = self;
        search.searchBar.placeholder = @"Search Movies";
        navItem.searchController = search;
        navItem.title = @"Movearch";
        
        self.definesPresentationContext = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // configure a cell;
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)updateSearchResultsForSearchController:(nonnull UISearchController *)searchController {
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchTerm = self.searchTerm;
    searchTerm = searchBar.text;
    NSLog(@"%@",searchTerm);
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    // Return to the default empty state of a tableview
    NSLog(@"Cancelled");
}

@end
