//
//  DALocationCell.m
//  DirectAssist
//
//  Created by Ricardo Ramos on 12/03/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import "DALocationCell.h"
#import "DAAddress.h"

@implementation DALocationCell
@synthesize txtLocation, locationLabel;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setCellDataWithAddress:(DAAddress *)address {
	
	NSMutableString *locationText = [[NSMutableString alloc] initWithString:(address.streetName != nil) ? address.streetName : @""];
	[locationText appendString:(address.houseNumber != nil) ? [NSString stringWithFormat:@", %@", address.houseNumber] : @""];
	[locationText appendString:(address.district != nil) ? [NSString stringWithFormat:@" - %@", address.district] : @""];
	[locationText appendString:(address.city != nil) ? [NSString stringWithFormat:@" - %@", address.city] : @""];
	[locationText appendString:(address.state != nil) ? [[NSString stringWithFormat:@" - %@", address.state] uppercaseString] : @""];
	
	locationLabel.text = DALocalizedString(@"Location", nil);
	txtLocation.text = locationText;
    txtLocation.textColor = [DAConfiguration settings].applicationClient.defaultColor;
}

- (void) setFontColor:(UIColor *)fontColor {
	locationLabel.textColor = fontColor;
    //txtLocation.textColor = fontColor;
}



@end
