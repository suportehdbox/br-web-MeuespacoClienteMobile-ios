//
//  DAAccreditedGarage.m
//  DirectAssist
//
//  Created by Ricardo Ramos on 03/04/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import "DAAccreditedGarage.h"
#import "DAAddress.h"

@implementation DAAccreditedGarage

@synthesize name;
@synthesize address; 
@synthesize phoneNumber;
@synthesize distanceFromYou;

- (NSString *)fullAddress {
	NSString *accreditedGarageAddress = self.address.streetName;
	if (![self.address.houseNumber isEqualToString:@""])
		accreditedGarageAddress = [NSString stringWithFormat:@"%@, %@", accreditedGarageAddress, 
								   self.address.houseNumber];
	
	return accreditedGarageAddress;
}

@end
