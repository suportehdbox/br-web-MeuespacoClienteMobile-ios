//
//  DAUserLocationAnnotation.m
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 6/24/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DAUserLocationAnnotation.h"


@implementation DAUserLocationAnnotation

@synthesize coordinate;
@synthesize isUpdatingAddress;

- (NSString *)title{
	
	if (isUpdatingAddress) {
		return DALocalizedString(@"UpdatingAddress", nil);
	}
	else {
		NSString *street = userAddress.streetName;
		if (nil != userAddress.houseNumber)
			street = [NSString stringWithFormat:@"%@, %@", street, userAddress.houseNumber];
	
		if (nil == street)
			street = @"Endereço desconhecido";
	
		return street;
	}
}

- (NSString *)subtitle{
	
	if (isUpdatingAddress) {
		return nil;
	}
	else {
		NSString *address = [NSString stringWithFormat:@"%@ - %@", userAddress.city,
						 userAddress.state];
		if (nil != userAddress.district)
			address = [NSString stringWithFormat:@"%@ - %@", userAddress.district, address];
	
		return address;
	}
}

- (id)initWithUserAddress:(DAAddress *)address {
	
	[self changeUserAddress:address];
	
	coordinate = address.coordinate;
	
	return self;
}

- (BOOL)hasAddress {
	return (nil == userAddress.streetName);
}

- (void)changeCoordinate:(CLLocationCoordinate2D)newCoordinate {
	coordinate = newCoordinate;
}

- (void)changeUserAddress:(DAAddress *)newAddress {
	userAddress = newAddress;
}

@end
