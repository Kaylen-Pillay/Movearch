//
//  MSBookmarkStore.m
//  Movearch
//
//  Created by Travis Pillay on 2019/04/11.
//  Copyright © 2019 Takealot Grad Team. All rights reserved.
//

#import "MSBookmarkStore.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>

@interface MSBookmarkStore()

@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation MSBookmarkStore

+ (instancetype)bookmarkBank {
    static MSBookmarkStore *bookmarkBank;
    if (!bookmarkBank) {
        bookmarkBank = [[self alloc] initPrivate];
        // Read in all of the data from the serilization store.
        // If this file does not exist, the create it.
        // Use the addBookmark method to add these bookmarks into the store.
    }
    
    return bookmarkBank;
}

- (instancetype)init{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use [MSBookmarkStore bookmarkBank]"
                                 userInfo:nil];
}

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
        _context = app.persistentContainer.viewContext;
    }
    return self;
}

- (NSArray *)allBookmarks {
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BookmarkBankEntity" inManagedObjectContext:_context];
    [request setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObjects = [_context executeFetchRequest:request error:&error];
    if (!error) {
        NSMutableArray *bookmarks = [[NSMutableArray alloc] init];
        for (int i = 0; i < fetchedObjects.count; i++) {
            [bookmarks addObject: [[fetchedObjects objectAtIndex:i] valueForKey:@"bookmark_query"] ];
        }
        return [[NSArray alloc] initWithArray:bookmarks];
    } else {
        return nil;
    }
}

- (BOOL)addBookmark:(NSString *)searchTerm {
    NSManagedObject *entity = [NSEntityDescription insertNewObjectForEntityForName:@"BookmarkBankEntity" inManagedObjectContext:_context];
    [entity setValue:searchTerm forKey:@"bookmark_query"];
    NSError *error;
    
    if (![_context save:&error]){
        return NO;
    } else {
        return YES;
    }
}

- (void)removeBookmark:(NSString *)searchTerm {
    NSEntityDescription *entity = [NSEntityDescription entityForName: @"BookmarkBankEntity" inManagedObjectContext:_context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bookmark_query == %@", searchTerm];
    [request setEntity:entity];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *fetchedBookmarks = [_context executeFetchRequest:request error:&error];
    
    for (NSManagedObject *bookmark in fetchedBookmarks) {
        [_context deleteObject:bookmark];
    }
    
    [_context save:&error];
}

- (BOOL)isContainedInBookmarkStore:(NSString *)query {
    NSEntityDescription *entity = [NSEntityDescription entityForName: @"BookmarkBankEntity" inManagedObjectContext:_context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bookmark_query == %@", query];
    [request setEntity:entity];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *fetchedBookmarks = [_context executeFetchRequest:request error:&error];
    
    if (fetchedBookmarks.count > 0) {
        return YES;
    } else {
        return NO;
    }
}

@end
