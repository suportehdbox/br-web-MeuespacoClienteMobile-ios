//
//  EditAddressDetailCell.m
//  DirectAssist
//
//  Created by Ricardo Ramos on 04/05/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import "DAEditAddressDetailCell.h"


@implementation DAEditAddressDetailCell

@synthesize txtAddressDetail;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setAddressDetailText:(NSString *)text {
	txtAddressDetail.text = text;
}



@end
