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
- (void)removeBookmark:(NSUInteger)searchTermIndex;
- (void)reorderBookmarkFromIndex:(NSUInteger)from toIndex:(NSUInteger)to;

@end

NS_ASSUME_NONNULL_END
