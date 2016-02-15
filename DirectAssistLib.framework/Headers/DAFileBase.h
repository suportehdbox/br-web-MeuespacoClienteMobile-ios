//
//  DAFileBase.h
//  DirectAssist
//
//  Created by Ricardo Ramos on 16/03/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DAFileBase : NSObject {
	
	NSString *fileNumber;
	NSString *requestNumber;
	NSString *contractNumber;
	NSString *phoneAreaCode;
	NSString *phoneNumber;
	NSString *fileCause;
	NSString *problemCode;
	NSString *serviceCode;
	NSString *fileCity;
	NSString *fileState;
	NSString *streetName;
	NSString *houseNumber;
	NSString *addressDetail;
	NSString *district;
	NSString *latitude;
	NSString *longitude;
	NSDate *creationDate;
	NSString *creationDateString;
	
	NSDate *scheduleBeginDate;
	NSDate *scheduleEndDate;
	NSString *zipcode;
}

@property (nonatomic, strong) NSString *fileNumber;
@property (nonatomic, strong) NSString *requestNumber;
@property (nonatomic, strong) NSString *contractNumber;
@property (nonatomic, strong) NSString *phoneAreaCode;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *fileCause;
@property (nonatomic, strong) NSString *problemCode;
@property (nonatomic, strong) NSString *serviceCode;
@property (nonatomic, strong) NSString *fileCity;
@property (nonatomic, strong) NSString *fileState;
@property (nonatomic, strong) NSString *streetName;
@property (nonatomic, strong) NSString *houseNumber;
@property (nonatomic, strong) NSString *addressDetail;
@property (nonatomic, strong) NSString *district;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) NSString *creationDateString;

@property (nonatomic, strong) NSDate *scheduleBeginDate;
@property (nonatomic, strong) NSDate *scheduleEndDate;

@property (nonatomic, copy) NSString *zipcode;

@end

