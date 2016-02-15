//
//  DAServiceDispatch.h
//  DirectAssist
//
//  Created by Ricardo Ramos on 23/03/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface DAServiceDispatch : NSObject {
	NSInteger fileNumber;
	NSString *requestNumber;
	NSString *dispatchStatus;
	NSString *acceptDate;
	NSString *dispatchChannel;
	NSString *arrivalTime;
	CLLocationCoordinate2D providerCoordinate;
	NSString *providerLatitude;
	NSString *providerLongitude;
	NSString *vehicleID;
	NSString *vehiclePlate;
	NSString *clientLatitude;
	NSString *clientLongitude;
	CLLocationCoordinate2D clientCoordinate;
	
	BOOL isSchedule;
	NSDate *scheduleBeginDate;
	NSDate *scheduleEndDate;
}

@property (nonatomic, assign) NSInteger fileNumber;
@property (nonatomic, copy) NSString *requestNumber;
@property (nonatomic, copy) NSString *dispatchStatus;
@property (nonatomic, copy) NSString *acceptDate;
@property (nonatomic, copy) NSString *dispatchChannel;
@property (nonatomic, copy) NSString *arrivalTime;
@property (nonatomic, assign) CLLocationCoordinate2D providerCoordinate;
@property (nonatomic, copy) NSString *providerLatitude;
@property (nonatomic, copy) NSString *providerLongitude;
@property (nonatomic, copy) NSString *vehicleID;
@property (nonatomic, copy) NSString *vehiclePlate;
@property (nonatomic, copy) NSString *clientLatitude;
@property (nonatomic, copy) NSString *clientLongitude;
@property (nonatomic, assign) CLLocationCoordinate2D clientCoordinate;


@property (nonatomic, assign) BOOL isSchedule;
@property (nonatomic, strong) NSDate *scheduleBeginDate;
@property (nonatomic, strong) NSDate *scheduleEndDate;@end
