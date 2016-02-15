//
//  DAUserLocation.h
//  DirectAssist
//
//  Created by Ricardo Ramos on 07/05/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface DAUserLocation : NSObject <CLLocationManagerDelegate> {
	CLLocationManager	*locationManager;
	CLLocation			*location;
	BOOL _stopsWhenReachGoodAccuracy;
	double _goodAccuracy;
}

@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, assign) BOOL stopsWhenReachGoodAccuracy;
@property (nonatomic, assign) double goodAccuracy;

+ (DAUserLocation *)sharedLocation;
+ (void)startUpdatingLocation;
+ (CLLocation *)currentLocation;

- (void)start;

@end
