//
//  MSMovieTableViewCell.h
//  Movearch
//
//  Created by Travis Pillay on 2019/04/10.
//  Copyright © 2019 Takealot Grad Team. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MSMovieTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *neatLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterImage;
@property (weak, nonatomic) IBOutlet UILabel *directorLabel;
@property (weak, nonatomic) IBOutlet UILabel *plotLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rottenImage;
@property (weak, nonatomic) IBOutlet UILabel *rottenScore;
@property (weak, nonatomic) IBOutlet UILabel *genreLabel;
@property (weak, nonatomic) IBOutlet UILabel *runningTime;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;

@end

NS_ASSUME_NONNULL_END
