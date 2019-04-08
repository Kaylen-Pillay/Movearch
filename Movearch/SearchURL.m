//
//  SearchURL.m
//  Movearch
//
//  Created by Travis Pillay on 2019/04/08.
//  Copyright © 2019 Takealot Grad Team. All rights reserved.
//

#import "SearchURL.h"
#import "APIKey.h"

@interface SearchURL()

@property (nonatomic, strong) NSString *baseURL;
@property (nonatomic, strong) NSString *imdbURL;

@end
@implementation SearchURL

- (instancetype)init
{
    self = [super init];
    if (self) {
        _baseURL = @"http://www.omdbapi.com/?s=";
        _imdbURL = @"https://www.imdb.com/title/";
    }
    return self;
}

- (NSURL *)getQueryURL:(NSString *)searchQuery {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@&apikey=%@", _baseURL, searchQuery, APIKey.getApiKey]];
}

- (NSURL *)getIMDBSiteURL:(NSString *)imdbCode {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", _imdbURL, imdbCode]];
}

@end
