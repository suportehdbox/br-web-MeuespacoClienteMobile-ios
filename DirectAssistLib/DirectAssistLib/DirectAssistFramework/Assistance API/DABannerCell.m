//
//  DABannerCell.m
//  DirectAssist
//
//  Created by Ricardo Ramos on 06/04/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import "DABannerCell.h"

@implementation DABannerCell

@synthesize bannerImageView = _bannerImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
		_bannerImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		_bannerImageView.contentMode = UIViewContentModeCenter;
		[self.contentView addSubview:_bannerImageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)layoutSubviews {
	[super layoutSubviews];

	_bannerImageView.frame = self.contentView.bounds;
}


@end
