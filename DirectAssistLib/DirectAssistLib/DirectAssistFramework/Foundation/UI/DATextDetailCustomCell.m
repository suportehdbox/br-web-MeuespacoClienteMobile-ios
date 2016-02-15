//
//  DATextDetailCustomCell.m
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 7/14/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DATextDetailCustomCell.h"


@implementation DATextDetailCustomCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGSize tam = [self.detailTextLabel.text sizeWithFont:self.detailTextLabel.font 
		constrainedToSize:CGSizeMake(self.detailTextLabel.frame.size.width, 80) 
		   lineBreakMode:UILineBreakModeWordWrap];
	
	self.detailTextLabel.frame = CGRectMake(self.detailTextLabel.frame.origin.x,
											self.detailTextLabel.frame.origin.y, 
											self.detailTextLabel.frame.size.width, 
											tam.height);
}



@end
