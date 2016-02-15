//
//  DAPhone.m
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 7/10/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DAPhone.h"

@implementation DAPhone

@synthesize countryCode;
@synthesize areaCode;
@synthesize phoneNumber;

- (id)initWithCountryCode:(int)phoneCountryCode
				 areaCode:(int)phoneAreaCode
			  phoneNumber:(NSInteger)number {

	if (self = [super init]) {
		self.countryCode = phoneCountryCode;
		self.areaCode = phoneAreaCode;
		self.phoneNumber = number;
	}
	return self;
}

- (id)initWithAreCodeAndNumberString:(NSString *)phoneString {
	
	if (self = [super init]) {
		
		self.countryCode = 55;

		if ([phoneString length] <= 8) {

			self.areaCode = 11;
			self.phoneNumber = [phoneString intValue];

		}
		else {
			NSRange range;
			range.length = 2;
			range.location = 0;
			
			self.areaCode = [[phoneString substringWithRange:range] intValue];
			self.phoneNumber = [[phoneString substringFromIndex:range.length] intValue];
		}
	}
	return self;
}

- (NSString *)stringFromPhoneNumber {

	if (phoneNumber <= 999999)
		return @"";
	
	NSRange range;
	range.length = (phoneNumber <= 9999999 ? 3 : 4);
	range.location = 0;

	NSString *phone = [NSString stringWithFormat:@"%d", self.phoneNumber];
	NSString *phone1 = [phone substringWithRange:range];
	NSString *phone2 = [phone substringFromIndex:range.length];
	
	return [NSString stringWithFormat:@"(%d) %@-%@", self.areaCode, phone1, phone2];
}

@end
