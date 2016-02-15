//
//  DAGeocoder.h
//  DirectAssist
//
//  Created by Ricardo Ramos on 22/03/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class DAGeocoder, DAAddress;

@protocol DAGeocoderDelegate <NSObject>
@required
- (void)geocoder:(DAGeocoder *)geocoder didFindAddresses:(NSArray *)addresses;
- (void)geocoder:(DAGeocoder *)geocoder didFailWithError:(NSError *)error;
- (void)geocoderDidFailNoInternetConnection:(DAGeocoder *)geocoder;
@end

@interface DAGeocoder : NSObject <NSXMLParserDelegate> {
	CLLocation *locationToGeocode;
	
	id <DAGeocoderDelegate> __unsafe_unretained delegate;

	NSMutableData		*wsData;
	NSXMLParser			*xmlParser;
	NSMutableString		*soapResults;
	NSMutableArray		*resultValues;
	
	BOOL recordEnabled;
	BOOL recordsFound;
	BOOL errorsFound;
	
	NSMutableDictionary *geocodeResults;
	NSMutableArray *addresses;
}

@property (nonatomic, unsafe_unretained) id <DAGeocoderDelegate> delegate;

- (void)searchWithAddress:(DAAddress *)address;
- (void)searchWithStreet:(NSString *)streetName city:(NSString *)city;
- (void)searchWithZipcode:(NSString *)zipcode;

@end

@interface DAGeocoder (Private)

- (void)internalSearchWithStreet:(NSString *)streetName 
					 houseNumber:(NSString *)houseNumber
							city:(NSString *)city 
						   state:(NSString *)state
						 zipcode:(NSString *)zipcode;

@end
