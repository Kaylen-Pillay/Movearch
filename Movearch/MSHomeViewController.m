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
#import "DGActivityIndicatorView.h"

@interface MSHomeViewController ()

@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) UIView *defaultStateView;
@property (strong, nonatomic) NSString *searchTerm;
@property (nonatomic) NSURLSession *session;
@property (nonatomic, strong) SearchURL *searchHelper;
@property (nonatomic, strong) DGActivityIndicatorView *loadingIndicator;

@end

@implementation MSHomeViewController

- (instancetype) init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIColor whiteColor],NSForegroundColorAttributeName, nil];
        
        [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
        
        [[UISearchBar appearance] setTintColor:[UIColor whiteColor]];
        
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
        
        UINib *nib = [UINib nibWithNibName:@"NoResultsView" bundle:self.nibBundle];
        self.defaultStateView = [nib instantiateWithOwner:self options:nil][0];
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config
                                                 delegate:nil
                                            delegateQueue:nil];
        
        _searchHelper = [[SearchURL alloc] init];
        
        _loadingIndicator = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeCookieTerminator
                                                                tintColor:[UIColor blueColor]
                                                                     size:20.0f];
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

- (void)viewWillLayoutSubviews {
    CGRect bounds = [[UIScreen mainScreen] bounds];
    float size = 50.0f;
    CGRect loadingFrame = CGRectMake(bounds.size.width - size, bounds.size.height - size, size, size);
    
    _loadingIndicator.frame = loadingFrame;
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
    NSString *posterHTTPS = [_searchHelper getPosterURL:item.posterURL];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:posterHTTPS]]];
    
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
    
    [[MSMovieItemStore sharedStore] clear];
    [self.tableView reloadData];
    
    [_loadingIndicator startAnimating];
    [self.tableView setBackgroundView:_loadingIndicator];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^{
        [self fetchFeed:searchTerm];
    });
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [[MSMovieItemStore sharedStore] clear];
    [self.tableView reloadData];
    [self.tableView setBackgroundView:self.defaultStateView];
}

- (void)fetchFeed:(NSString *)queryString {
    NSURL *url = [_searchHelper getQueryURL:queryString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:req
                                                     completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:0
                                                                     error:nil];
        
        
        if (! [jsonObject[@"Response"] isEqual:@"False"]) {
            NSArray *searchResults = jsonObject[@"Search"];
            for (int i = 0; i < searchResults.count; i++) {
                NSDictionary *result = searchResults[i];
                [[MSMovieItemStore sharedStore] createMovieItemWithTitle:result[@"Title"]
                                                                    year:result[@"Year"]
                                                                  imdbID:result[@"imdbID"]
                                                                    type:result[@"Type"]
                                                               posterURL:result[@"Poster"]];
            }

            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView setBackgroundView:nil];
                [self.tableView reloadData];
            });
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView setBackgroundView:self.defaultStateView];
                [[MSMovieItemStore sharedStore] clear];
                [self.tableView reloadData];
            });
        }
    }];
    
    [dataTask resume];
}

@end
