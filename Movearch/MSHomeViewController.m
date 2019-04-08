//
//  MSHomeViewController.m
//  Movearch
//
//  Created by Travis Pillay on 2019/04/08.
//  Copyright © 2019 Takealot Grad Team. All rights reserved.
//

#import "MSHomeViewController.h"
#import "MSMovieItemStore.h"
#import "MSMovieItem.h"
#import "SearchURL.h"

@interface MSHomeViewController ()

@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) UIView *defaultStateView;
@property (strong, nonatomic) NSString *searchTerm;
@property (nonatomic) NSURLSession *session;
@property (nonatomic, strong) SearchURL *searchHelper;

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
        self.navigationController.hidesBarsWhenVerticallyCompact = false;
        self.definesPresentationContext = YES;
        
        UINib *nib = [UINib nibWithNibName:@"DefaultStateTableView" bundle:self.nibBundle];
        self.defaultStateView = [nib instantiateWithOwner:self options:nil][0];
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config
                                                 delegate:nil
                                            delegateQueue:nil];
        
        _searchHelper = [[SearchURL alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.hidesSearchBarWhenScrolling = false;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    self.navigationItem.hidesSearchBarWhenScrolling = true;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger count = [[[MSMovieItemStore sharedStore] allItems] count];
    
    if (count < 1) {
        [self.tableView setBackgroundView:self.defaultStateView];
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // configure a cell;
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                   reuseIdentifier:@"UITableViewCell"];
    
    
    
    NSArray *movieItems = [[MSMovieItemStore sharedStore] allItems];
    MSMovieItem *item = movieItems[indexPath.row];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:item.posterURL]]];
    
    [cell.textLabel setText:item.title];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@ - %@", item.year, item.type]];
    [cell.imageView setImage:image];
    return cell;
}

- (void)updateSearchResultsForSearchController:(nonnull UISearchController *)searchController {
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchTerm = self.searchTerm;
    searchTerm = searchBar.text;
    NSLog(@"%@",searchTerm);
    
    
    [self.tableView reloadData];
    [self.tableView setBackgroundView:nil];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [[MSMovieItemStore sharedStore] clear];
    [self.tableView reloadData];
    [self.tableView setBackgroundView:self.defaultStateView];
}

- (void)fetchFeed:(NSString *)queryString {
    NSURL *url = [_searchHelper getQueryURL:queryString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    // TODO: Complete the implementation
}

@end
