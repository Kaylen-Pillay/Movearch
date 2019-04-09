//
//  MSMovieTableViewCell.h
//  Movearch
//
//  Created by Travis Pillay on 2019/04/09.
//  Copyright © 2019 Takealot Grad Team. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MSMovieTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *thumbnailImage;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *type;

@property (weak, nonatomic) IBOutlet UILabel *year;


@end

NS_ASSUME_NONNULL_END
