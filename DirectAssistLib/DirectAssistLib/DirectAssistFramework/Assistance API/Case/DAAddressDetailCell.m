//
//  AddressDetailCell.m
//  DirectAssist
//
//  Created by Ricardo Ramos on 04/05/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import "DAAddressDetailCell.h"


@implementation DAAddressDetailCell




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void) setCellDataWithText:(NSString *)text {
	
	lblAddressDetail.text = DALocalizedString(@"AddressDetail", nil);
	txtAddressDetail.text = text;
    txtAddressDetail.textColor = [DAConfiguration settings].applicationClient.defaultColor;
}

- (void) setFontColor:(UIColor *)fontColor {
	lblAddressDetail.textColor = fontColor;
    //txtAddressDetail.textColor = fontColor;
}



@end
