//
//  MSMovieItem.m
//  Movearch
//
//  Created by Travis Pillay on 2019/04/08.
//  Copyright © 2019 Takealot Grad Team. All rights reserved.
//

#import "MSMovieItem.h"

@implementation MSMovieItem

- (instancetype) initWithTitle:(NSString *)title
                          year:(NSString *)year
                        imdbID:(NSString *)imdbID
                          type:(NSString *)type
                     posterURL:(NSString *)posterURL {
    
    self = [super init];
    if (self) {
        _title = title;
        _year = year;
        _imdbID = imdbID;
        _type = type;
        _posterURL = posterURL;
    }
    
    return self;
}

@end
