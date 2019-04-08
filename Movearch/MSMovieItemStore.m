//
//  MSMovieItemStore.m
//  Movearch
//
//  Created by Travis Pillay on 2019/04/08.
//  Copyright © 2019 Takealot Grad Team. All rights reserved.
//

#import "MSMovieItemStore.h"

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
    return [self.privateItems copy];
}



@end
