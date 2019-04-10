//
//  MSMovieItem.h
//  Movearch
//
//  Created by Travis Pillay on 2019/04/08.
//  Copyright © 2019 Takealot Grad Team. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MSMovieItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *imdbID;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *posterURL;
@property (nonatomic, strong) NSString *director;
@property (nonatomic, strong) NSString *plot;
@property (nonatomic, strong) NSString *staring;
@property (nonatomic, strong) NSString *rottenScore;
@property (nonatomic, strong) NSString *genre;
@property (nonatomic, strong) NSString *runningTime;
@property (nonatomic, strong) NSString *rating;

- (instancetype) initWithTitle:(NSString *)title
                          year:(NSString *)year
                        imdbID:(NSString *)imdbID
                          type:(NSString *)type
                     posterURL:(NSString *)posterURL;

@end

NS_ASSUME_NONNULL_END
