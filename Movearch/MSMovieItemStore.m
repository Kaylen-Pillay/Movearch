//
//  MSMovieItemStore.m
//  Movearch
//
//  Created by Travis Pillay on 2019/04/08.
//  Copyright © 2019 Takealot Grad Team. All rights reserved.
//

#import "MSMovieItemStore.h"
#import "MSMovieItem.h"

@interface MSMovieItemStore ()

@property (nonatomic) NSMutableArray *privateItems;

@end

@implementation MSMovieItemStore

+ (instancetype)sharedStore {
    static MSMovieItemStore *sharedStore;
    
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    
    return sharedStore;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[MSMovieItemStore sharedStore]"
                                 userInfo:nil];
}

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        _privateItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray *)allItems {
    @synchronized (self) {
        return [self.privateItems copy];
    }
}

- (void)clear {
    @synchronized (self) {
        [self.privateItems removeAllObjects];
    }
}

- (MSMovieItem *)createMovieItemWithTitle:(NSString *)title year:(NSString *)year imdbID:(NSString *)imdbID
                                     type:(NSString *)type posterURL:(NSString *)posterURL {
    @synchronized (self) {
        MSMovieItem *item = [[MSMovieItem alloc] initWithTitle:title
                                                          year:year
                                                        imdbID:imdbID
                                                          type:type
                                                     posterURL:posterURL];
        
        [self.privateItems addObject:item];
        return item;
    }
}

- (void) restoreStore:(NSArray *)prevStore {
    _privateItems = [[NSMutableArray alloc] initWithArray:prevStore];
}

@end
