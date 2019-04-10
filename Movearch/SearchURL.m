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
@property (nonatomic, strong) NSString *detailsURL;

@end
@implementation SearchURL

- (instancetype)init
{
    self = [super init];
    if (self) {
        _baseURL = @"https://www.omdbapi.com/?s=";
        _imdbURL = @"https://www.imdb.com/title/";
        _detailsURL = @"https://www.omdbapi.com/?i=";
    }
    return self;
}

- (NSURL *)getQueryURL:(NSString *)searchQuery {
    NSString *encoded = [searchQuery stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@&apikey=%@", _baseURL, encoded, APIKey.getApiKey]];
}

- (NSURL *)getDetailsURL:(NSString *)imdbID {
    NSString *encoded = [imdbID stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@&apikey=%@", _detailsURL, encoded, APIKey.getApiKey]];
}

- (NSURL *)getIMDBSiteURL:(NSString *)imdbCode {
    NSString *encoded = [imdbCode stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", _imdbURL, encoded]];
}

- (NSString *)httpToHttps:(NSString *)string{
    return [string stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
}

- (NSString *)getPosterURL:(NSString *)poster {
    NSString *posterHTTPS = [self httpToHttps:poster];
    if ([posterHTTPS isEqualToString:@"N/A"]) {
        return @"https://d994l96tlvogv.cloudfront.net/uploads/film/poster/poster-image-coming-soon-placeholder-all-logos-500-x-740.png";
    } else {
        return posterHTTPS;
    }
}

@end
