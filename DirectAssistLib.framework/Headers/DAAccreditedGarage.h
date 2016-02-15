//
//  DAAccreditedGarage.h
//  DirectAssist
//
//  Created by Ricardo Ramos on 03/04/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DAAddress;

@interface DAAccreditedGarage : NSObject {
	NSString *name;
	DAAddress *address;
	NSString *phoneNumber;
	double distanceFromYou;	
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) DAAddress *address;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic) double distanceFromYou;
@property (unsafe_unretained, nonatomic, readonly) NSString *fullAddress;


@end
