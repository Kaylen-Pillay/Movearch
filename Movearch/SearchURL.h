//
//  SearchURL.h
//  Movearch
//
//  Created by Travis Pillay on 2019/04/08.
//  Copyright © 2019 Takealot Grad Team. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchURL : NSObject

@property (nonatomic, strong) NSString *defaultPosterURL;

- (NSURL *)getQueryURL:(NSString *)searchQuery;

- (NSURL *)getIMDBSiteURL:(NSString *)imdbCode;

- (NSString *)getPosterURL:(NSString *)poster;

- (NSURL *)getDetailsURL:(NSString *)imdbID;

@end

NS_ASSUME_NONNULL_END
