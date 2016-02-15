//
//  DAAnnotation.m
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 7/8/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DAAnnotation.h"
#import "DAAddress.h"

@implementation DAAnnotation

@synthesize address;
@synthesize coordinate;
@synthesize updatingAddress;

- (id)initWithAddress:(DAAddress *)annotationAddress {

	[self setAddress:annotationAddress];
	return self;
}

- (NSString *)title{
	
	if (updatingAddress) {
		return DALocalizedString(@"UpdatingAddress", nil);
	}
	else {
		NSString *street = address.streetName;
		
		if (nil == street)
			return @"Endereço desconhecido";
		
		if (nil != address.houseNumber)
			street = [NSString stringWithFormat:@"%@, %@", street, address.houseNumber];
		
		return street;
	}
}

- (NSString *)subtitle{
	
	if (updatingAddress) {
		return nil;
	}
	else {
		
		if (nil == address.city)
			return nil;
		
		NSString *addressText = [NSString stringWithFormat:@"%@ - %@", address.city,
							 address.state];
		if (nil != address.district)
			addressText = [NSString stringWithFormat:@"%@ - %@", address.district, addressText];
		
		return addressText;
	}
}

- (void)setAddress:(DAAddress *)annotationAddress {
	address = annotationAddress;
	coordinate = address.coordinate;
}

- (void)changeCoordinate:(CLLocationCoordinate2D)newCoordinate {
	coordinate = newCoordinate;
}
@end
