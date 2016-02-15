//
//  DABannerCell.h
//  DirectAssist
//
//  Created by Ricardo Ramos on 06/04/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DABannerCell : UITableViewCell {
@private
	UIImageView *_bannerImageView;
}

@property (nonatomic, strong) UIImageView *bannerImageView;

@end
