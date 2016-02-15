//
//  DAAddress.m
//  DirectAssist
//
//  Created by Ricardo Ramos on 13/03/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import "DAAddress.h"

@implementation DAAddress

@synthesize streetName, houseNumber, city, state, district, zipcode;
@synthesize coordinate;

- (id)initWithStreet:(NSString *)addressStreetName 
			  number:(NSString *)addressHouseNumber 
			district:(NSString *)addressDistrict
				city:(NSString *)addressCity 
			   state:(NSString *)addressState 
		  coordinate:(CLLocationCoordinate2D)addressCoordinate {

	if (self = [super init]) {
		self.streetName = [addressStreetName wordCapitalizedString];
		self.houseNumber = addressHouseNumber;
		self.district = [addressDistrict wordCapitalizedString];
		self.city = [addressCity wordCapitalizedString];
		self.state = [addressState uppercaseString];
		self.coordinate = addressCoordinate;
	}
	return self;
}

- (id)initWithStreet:(NSString *)addressStreetName 
			  number:(NSString *)addressHouseNumber 
			district:(NSString *)addressDistrict
				city:(NSString *)addressCity 
			   state:(NSString *)addressState 
			 zipcode:(NSString *)addressZipcode
		  coordinate:(CLLocationCoordinate2D)addressCoordinate {
	
	if (self = [self initWithStreet:addressStreetName 
							 number:addressHouseNumber 
						   district:addressDistrict 
							   city:addressCity 
							  state:addressState 
						 coordinate:addressCoordinate]) {

		self.zipcode = addressZipcode;
	}
	return self;
}

- (NSString *)fullAddress {
	
	NSMutableString *address = [NSMutableString stringWithString:self.streetName];
	if (nil != self.houseNumber)
		[address appendFormat:@", %@", self.houseNumber];
		
	if (nil != self.district)
		[address appendFormat:@" - %@", self.district];

	if (nil != self.city)
		[address appendFormat:@" - %@", self.city];

	if (nil != self.state)
		[address appendFormat:@" - %@", [self.state uppercaseString]];

	return address;
}


@end
