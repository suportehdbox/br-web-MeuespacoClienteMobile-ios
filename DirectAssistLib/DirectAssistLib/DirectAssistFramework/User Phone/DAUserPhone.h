//
//  DAUserPhone.h
//  DirectAssist
//
//  Created by Ricardo Ramos on 05/05/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DAUserPhone : NSObject {
	NSString	*areaCode;
	NSString	*phoneNumber;
}

@property (nonatomic, copy) NSString *areaCode;
@property (nonatomic, copy) NSString *phoneNumber;

+ (DAUserPhone *) getUserPhone;
- (void) save;
- (NSString *)phoneNumberWithAreaCode;
@end
