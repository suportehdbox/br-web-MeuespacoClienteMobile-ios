//
//  DAUserLocation.m
//  DirectAssist
//
//  Created by Ricardo Ramos on 07/05/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import "DAUserLocation.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

static DAUserLocation *sharedUserLocation;

@implementation DAUserLocation

@synthesize location;
@synthesize stopsWhenReachGoodAccuracy = _stopsWhenReachGoodAccuracy;
@synthesize goodAccuracy = _goodAccuracy;

#pragma mark -
#pragma mark Class

+ (void)initialize {
	sharedUserLocation = [[DAUserLocation alloc] init];
}

+ (void)startUpdatingLocation {
	[sharedUserLocation start];
}

+ (DAUserLocation *)sharedLocation {
	return sharedUserLocation;
}

+ (CLLocation *)currentLocation {
	
#if TARGET_IPHONE_SIMULATOR
	CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:-23.717123 longitude:-46.543456];
	return newLocation;
#else
	if (nil == sharedUserLocation) 
		sharedUserLocation = [[DAUserLocation alloc] init];
	return [[sharedUserLocation location] copy];
#endif
}

#pragma mark -
#pragma mark NSObject

- (id)init {
	if (self = [super init]) {
		_stopsWhenReachGoodAccuracy = NO;
		_goodAccuracy = 300.0;
	}
	return self;
}


#pragma mark -
#pragma mark Public

- (void)start {
    
    if (nil == locationManager) {
        locationManager = [[CLLocationManager alloc] init];
        
        locationManager.delegate = self;
        if(IS_OS_8_OR_LATER){
            NSUInteger code = [CLLocationManager authorizationStatus];
            if (code == kCLAuthorizationStatusNotDetermined && ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
                // choose one request according to your business.
                if([[NSBundle bundleForClass:[self class]] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
                    [locationManager requestAlwaysAuthorization];
                } else if([[NSBundle bundleForClass:[self class]] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
                    [locationManager requestWhenInUseAuthorization];
                } else {
                    NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
                }
            }
        }
    }
    [locationManager startUpdatingLocation];
}

#pragma mark -
#pragma mark CLLocationManagerDelegate 

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	
	NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
	
	//NSLog(@"UserLocationManager: %.6f,%.6f Time: %.4f Accuracy: %.0fm, %@", newLocation.coordinate.latitude, newLocation.coordinate.longitude, howRecent, newLocation.horizontalAccuracy, [eventDate description]);

	if (howRecent < 0.0 && howRecent > -10.0) {
		
		location = newLocation;
		
		if (YES == _stopsWhenReachGoodAccuracy && location.horizontalAccuracy <= _goodAccuracy) {
			//[locationManager stopUpdatingLocation];
		}
	}
}
 
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	
	//NSLog(@"UserLocationManager didFailWithError: %@", [error description]);
	[locationManager stopUpdatingLocation];
}

@end
