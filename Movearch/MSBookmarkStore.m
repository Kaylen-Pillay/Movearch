//
//  MSBookmarkStore.m
//  Movearch
//
//  Created by Travis Pillay on 2019/04/11.
//  Copyright © 2019 Takealot Grad Team. All rights reserved.
//

#import "MSBookmarkStore.h"

@interface MSBookmarkStore()

@property (nonatomic, strong) NSMutableArray *privateBookmarkStore;

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
        _privateBookmarkStore = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray *)allBookmarks {
    return [self.privateBookmarkStore copy];
}

- (void)addBookmark:(NSString *)searchTerm {
    [_privateBookmarkStore addObject:searchTerm];
}

- (void)removeBookmark:(NSUInteger)searchTermIndex {
    [_privateBookmarkStore removeObjectAtIndex:searchTermIndex];
}

- (void)reorderBookmarkFromIndex:(NSUInteger)from toIndex:(NSUInteger)to {
    
}

@end
