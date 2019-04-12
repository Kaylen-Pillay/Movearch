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
#import "MSMovieTableViewCell.h"
#import "DGActivityIndicatorView.h"
#import "BookmarksTableViewController.h"
#import "MSBookmarkStore.h"

@interface MSHomeViewController ()

@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) UIView *defaultStateView;
@property (strong, nonatomic) NSString *searchTerm;
@property (nonatomic) NSURLSession *session;
@property (nonatomic, strong) SearchURL *searchHelper;
@property (nonatomic, strong) DGActivityIndicatorView *loadingIndicator;
@property (nonatomic, strong) NSCache *imageCache;
@property (nonatomic, strong) NSCache *searchCache;
@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation MSHomeViewController

- (instancetype) init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        
        NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIColor whiteColor],NSForegroundColorAttributeName, nil];
        
        [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
        
        [[UISearchBar appearance] setTintColor:[UIColor whiteColor]];
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize
                                                                             target:self
                                                                             action:@selector(viewBookmarks:)];

        
        UINavigationItem *navItem = self.navigationItem;
        UISearchController *search = self.searchController;
        
        search = [[UISearchController alloc] initWithSearchResultsController:nil];
        search.obscuresBackgroundDuringPresentation = NO;
        search.searchResultsUpdater = self;
        search.searchBar.delegate = self;
        search.searchBar.placeholder = @"Search Movies";
        search.searchBar.showsBookmarkButton=NO;
        _searchBar = search.searchBar;

        navItem.searchController = search;
        navItem.title = @"Movearch";
        navItem.leftBarButtonItem = bbi;
        
        self.navigationController.hidesBarsWhenVerticallyCompact = false;
        self.definesPresentationContext = YES;
        
        UINib *nib = [UINib nibWithNibName:@"WelcomeView" bundle:self.nibBundle];
        self.defaultStateView = [nib instantiateWithOwner:self options:nil][0];
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config
                                                 delegate:nil
                                            delegateQueue:nil];
        
        _searchHelper = [[SearchURL alloc] init];
        
        _loadingIndicator = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeCookieTerminator
                                                                tintColor:[UIColor blueColor]
                                                                     size:20.0f];
        
        _imageCache = [[NSCache alloc] init];
        _searchCache = [[NSCache alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (void)hideIfNA:(UILabel *)view {
    if ([view.text isEqualToString:@"N/A"]) {
        view.hidden = YES;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // configure a cell;
    MSMovieTableViewCell *cell = (MSMovieTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MSMovieTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSArray *movieItems = [[MSMovieItemStore sharedStore] allItems];
    MSMovieItem *item = movieItems[indexPath.row];
    NSString *posterHTTPS = [_searchHelper getPosterURL:item.posterURL];
    UIImage *image = [[self imageCache] objectForKey:posterHTTPS];
    if (!image) {
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:posterHTTPS]]];
        
        // Poster URL is broken, default to the standard poster URL.
        if (!image) {
            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: _searchHelper.defaultPosterURL]]];
        }
        
        [[self imageCache] setObject:image forKey:posterHTTPS];
    }
    
    cell.neatLabel.text = item.title;
    cell.typeLabel.text = item.staring;
    cell.dateLabel.text = [NSString stringWithFormat:@"Rated: %@", item.rating];
    cell.runningTime.text = item.runningTime;
    cell.yearLabel.text = item.year;
    cell.directorLabel.text = [NSString stringWithFormat:@"Director: %@", item.director];
    cell.genreLabel.text = [NSString stringWithFormat:@"Genre: %@", item.genre];
    cell.plotLabel.text = item.plot;
    cell.posterImage.image = image;
    cell.rottenScore.text = item.rottenScore;
    
    // Check if the views need to be hidden
    [self hideIfNA:cell.typeLabel];
    [self hideIfNA:cell.plotLabel];
    [self hideIfNA:cell.typeLabel];
    [self hideIfNA:cell.runningTime];
    [self hideIfNA:cell.yearLabel];
    
    if ([item.rating isEqualToString:@"N/A"]) {
        cell.dateLabel.hidden = YES;
    }
    
    if ([item.director isEqualToString:@"N/A"]) {
        cell.directorLabel.hidden = YES;
    }
    
    if ([item.genre isEqualToString:@"N/A"]) {
        cell.genreLabel.hidden = YES;
    }
    
    if ([item.rottenScore isEqualToString:@""]) {
        cell.rottenScore.hidden = YES;
        cell.rottenImage.hidden = YES;
    } else {
        NSString *percentage = [item.rottenScore substringWithRange:NSMakeRange(0, 2)];
        float percentFloat = [percentage floatValue];
        
        if (percentFloat < 50) {
            cell.rottenImage.image = [UIImage imageNamed:@"rotten_bad"];
        } else if (percentFloat >= 50 && percentFloat < 90) {
            cell.rottenImage.image = [UIImage imageNamed:@"rotten"];
        } else {
            cell.rottenImage.image = [UIImage imageNamed:@"rotten_good"];
        }
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected!");
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 195;
}

- (void)updateSearchResultsForSearchController:(nonnull UISearchController *)searchController {
    // do nothing
    return;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchTerm = self.searchTerm;
    _searchTerm = searchBar.text;
    searchTerm = searchBar.text;
    
    [[MSMovieItemStore sharedStore] clear];
    [self.tableView reloadData];
    
    [_loadingIndicator startAnimating];
    [self.tableView setBackgroundView:_loadingIndicator];
    
    NSArray *prevStore = [_searchCache objectForKey:searchTerm];
    if (prevStore == nil) {
        NSLog(@"Never saw this search before!");
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^{
            [self fetchFeed:searchTerm];
        });
    } else {
        NSLog(@"I've seen this search !!!!!!!!");
        [[MSMovieItemStore sharedStore] restoreStore:prevStore];
        [self.tableView setBackgroundView:nil];
        [self.tableView reloadData];
        if (! [[MSBookmarkStore bookmarkBank] isContainedInBookmarkStore:searchTerm]){
            self.searchBar.showsBookmarkButton = YES;
        }
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [[MSMovieItemStore sharedStore] clear];
    [self.tableView reloadData];
    [self.tableView setBackgroundView:self.defaultStateView];
    self.searchBar.showsBookmarkButton = NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText length] == 0) {
        self.searchBar.showsBookmarkButton = NO;
    }
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
            NSMutableArray *imdbIDs = [[NSMutableArray alloc] init];
            for (int i = 0; i < searchResults.count; i++) {
                NSDictionary *result = searchResults[i];
                [imdbIDs addObject:result[@"imdbID"]];
            }

            [self searchMovies:imdbIDs];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView setBackgroundView:self.defaultStateView];
                [[MSMovieItemStore sharedStore] clear];
                [self.tableView reloadData];
                self.searchBar.showsBookmarkButton = NO;
            });
        }
    }];
    
    [dataTask resume];
}

- (void) searchMovies:(NSArray *)imdbIDs {
    for (int i = 0; i < imdbIDs.count; i++) {
        NSString *imdbID = [imdbIDs objectAtIndex:i];
        NSURL *url = [_searchHelper getDetailsURL:imdbID];
        NSURLRequest *req = [NSURLRequest requestWithURL:url];
        
        NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:req
                                                         completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
        {
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                                       options:0
                                                                         error:nil];
            
            if (! [jsonObject[@"Response"] isEqual:@"False"]) {
                MSMovieItem *item = [[MSMovieItemStore sharedStore]
                                     createMovieItemWithTitle:jsonObject[@"Title"]
                                     year:jsonObject[@"Year"]
                                     imdbID:jsonObject[@"imdbID"]
                                       type:jsonObject[@"Type"]
                                  posterURL:jsonObject[@"Poster"]];
                
                item.director = jsonObject[@"Director"];
                item.genre = jsonObject[@"Genre"];
                item.plot = jsonObject[@"Plot"];
                item.staring = jsonObject[@"Actors"];
                item.rating = jsonObject[@"Rated"];
                item.runningTime = jsonObject[@"Runtime"];
                
                NSArray *ratingSources = jsonObject[@"Ratings"];
                item.rottenScore = @"";
                for (int i = 0; i < ratingSources.count; i++) {
                    NSString *source = ratingSources[i][@"Source"];
                    if ([source isEqualToString:@"Rotten Tomatoes"]) {
                        item.rottenScore = ratingSources[i][@"Value"];
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.searchBar.showsBookmarkButton = YES;
                    if ([[[MSMovieItemStore sharedStore] allItems] count] == [imdbIDs count]) {
                        [self.tableView setBackgroundView:nil];
                        [self.tableView reloadData];
                        [self.searchCache setObject:[[MSMovieItemStore sharedStore] allItems] forKey:self.searchTerm];
                    } else if ([[[MSMovieItemStore sharedStore] allItems] count] >= [imdbIDs count] / 2){
                        [self.tableView setBackgroundView:nil];
                        [self.tableView reloadData];
                    }
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView setBackgroundView:self.defaultStateView];
                    [[MSMovieItemStore sharedStore] clear];
                    [self.tableView reloadData];
                    self.searchBar.showsBookmarkButton = NO;
                });
            }
            
            
        }];
        
        [dataTask resume];
    }
}

- (void)viewBookmarks:(id)sender {
    BookmarksTableViewController *bvc = [[BookmarksTableViewController alloc] init];
    [self.navigationController pushViewController:bvc animated:YES];
}

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar {
    [[MSBookmarkStore bookmarkBank] addBookmark:searchBar.text];
    searchBar.showsBookmarkButton = NO;
    
    NSString *message = [NSString stringWithFormat:@"Bookmarked search - '%@'", searchBar.text];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    int duration = 2; // duration in seconds
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
    });
}

@end
