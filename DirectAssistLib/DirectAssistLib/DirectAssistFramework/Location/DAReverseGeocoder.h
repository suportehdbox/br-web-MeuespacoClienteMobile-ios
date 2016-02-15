//
//  DAReverseGeocoder.h
//  DirectAssist
//
//  Created by Ricardo Ramos on 22/03/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class DAAddress, DAReverseGeocoder;

@protocol DAReverseGeocoderDelegate <NSObject>
@required
- (void)reverseGeocoder:(DAReverseGeocoder *)geocoder didFindAddress:(DAAddress *)address;
- (void)reverseGeocoder:(DAReverseGeocoder *)geocoder didFailWithError:(NSError *)error;
- (void)reverseGeocoderDidFailNoInternetConnection:(DAReverseGeocoder *)geocoder;
@end

@interface DAReverseGeocoder : NSObject <NSXMLParserDelegate> {
	CLLocation *locationToGeocode;
	
	id <DAReverseGeocoderDelegate> __unsafe_unretained delegate;

	NSMutableData		*wsData;
	NSXMLParser			*xmlParser;
	NSMutableString		*soapResults;
	NSMutableArray		*resultValues;
	
	BOOL recordEnabled;
	BOOL recordsFound;
	BOOL errorsFound;
	
	NSMutableDictionary *geocodeResults;
}

@property (nonatomic, unsafe_unretained) id <DAReverseGeocoderDelegate> delegate;

- (id)initWithLocation:(CLLocation *)location;
- (void)start;

@end
