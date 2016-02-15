//
//  DAUserPhone.m
//  DirectAssist
//
//  Created by Ricardo Ramos on 05/05/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import "DAUserPhone.h"

#define AREA_CODE_KEY		@"USER_PHONE_AREA_CODE"
#define PHONE_NUMBER_KEY	@"USER_PHONE_NUMBER"

@implementation DAUserPhone

@synthesize areaCode, phoneNumber;

+ (DAUserPhone *) getUserPhone {
	
	DAUserPhone *userPhone = nil;
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *areaCode = [prefs stringForKey:AREA_CODE_KEY];
	NSString *phoneNumber = [prefs stringForKey:PHONE_NUMBER_KEY];
	if (nil != areaCode && nil != phoneNumber) {
		userPhone = [[DAUserPhone alloc] init];
		[userPhone setAreaCode:areaCode];
		[userPhone setPhoneNumber:phoneNumber];
	}
	
	return userPhone;
}

- (void) save {
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:[self areaCode] forKey:AREA_CODE_KEY];
	[prefs setObject:[self phoneNumber] forKey:PHONE_NUMBER_KEY];
	[prefs synchronize];
}

- (NSString *)phoneNumberWithAreaCode {
	return [NSString stringWithFormat:@"%@%@", self.areaCode, self.phoneNumber];
}


@end
