//
//  DAAddress.h
//  DirectAssist
//
//  Created by Ricardo Ramos on 13/03/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface DAAddress : NSObject {
	NSString *streetName;
	NSString *houseNumber;
	NSString *district;
	NSString *city;
	NSString *state;
	NSString *zipcode;
	CLLocationCoordinate2D coordinate;
}

@property (nonatomic, copy) NSString *streetName;
@property (nonatomic, copy) NSString *houseNumber;
@property (nonatomic, copy) NSString *district;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *zipcode;
@property (nonatomic) CLLocationCoordinate2D coordinate;

- (id)initWithStreet:(NSString *)streetName number:(NSString *)houseNumber district:(NSString *)district
				city:(NSString *)city state:(NSString *)state coordinate:(CLLocationCoordinate2D)coordinate;
- (NSString *)fullAddress;

@end
