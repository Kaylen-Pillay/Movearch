//
//  BookmarksTableViewController.m
//  Movearch
//
//  Created by Travis Pillay on 2019/04/11.
//  Copyright © 2019 Takealot Grad Team. All rights reserved.
//

#import "BookmarksTableViewController.h"
#import "MSBookmarkStore.h"
#import "MSHomeViewController.h"

@interface BookmarksTableViewController ()

@end

@implementation BookmarksTableViewController

- (instancetype)init {
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Your Bookmared Searches";
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"BookmarkTableCell"];
    self.clearsSelectionOnViewWillAppear = NO;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[MSBookmarkStore bookmarkBank] allBookmarks] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookmarkTableCell" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"BookmarkTableCell"];
    }
    
    NSString *bookmark = [[[MSBookmarkStore bookmarkBank] allBookmarks] objectAtIndex:indexPath.row];
    cell.textLabel.text = bookmark;
    return cell;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *item = [[MSBookmarkStore bookmarkBank] allBookmarks];
        NSString *query = [item objectAtIndex:indexPath.row];
        [[MSBookmarkStore bookmarkBank] removeBookmark:query];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *bookmark = [[[MSBookmarkStore bookmarkBank] allBookmarks] objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"passData" object:bookmark];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
