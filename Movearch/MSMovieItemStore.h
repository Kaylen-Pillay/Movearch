//
//  MSMovieItemStore.h
//  Movearch
//
//  Created by Travis Pillay on 2019/04/08.
//  Copyright © 2019 Takealot Grad Team. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class MSMovieItem;

@interface MSMovieItemStore : NSObject

@property (nonatomic, readonly) NSArray *allItems;

+ (instancetype)sharedStore;
- (MSMovieItem *)createMovieItemWithTitle:(NSString *) title
                                     year:(NSString *) year
                                   imdbID:(NSString *) imdbID
                                     type:(NSString *) type
                                posterURL:(NSString *) posterURL;

- (void)clear;


@end

NS_ASSUME_NONNULL_END
