//
//  MSBookmarkStore.h
//  Movearch
//
//  Created by Travis Pillay on 2019/04/11.
//  Copyright © 2019 Takealot Grad Team. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MSBookmarkStore : NSObject
@property (nonatomic, readonly) NSArray *allBookmarks;

+(instancetype)bookmarkBank;
- (BOOL)addBookmark:(NSString *)searchTerm;
- (void)removeBookmark:(NSString *)searchTerm;
- (BOOL)isContainedInBookmarkStore:(NSString *)query;
@end

NS_ASSUME_NONNULL_END
