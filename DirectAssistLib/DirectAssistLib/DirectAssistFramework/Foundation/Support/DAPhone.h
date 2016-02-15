//
//  DAPhone.h
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 7/10/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DAPhone : NSObject {
	int countryCode;
	int areaCode;
	NSInteger phoneNumber;
}

@property (assign) int countryCode;
@property (assign) int areaCode;
@property (assign) NSInteger phoneNumber;

- (id)initWithCountryCode:(int)phoneCountryCode
				 areaCode:(int)phoneAreaCode
			  phoneNumber:(NSInteger)number;

- (id)initWithAreCodeAndNumberString:(NSString *)phoneString;

- (NSString *)stringFromPhoneNumber;

@end
