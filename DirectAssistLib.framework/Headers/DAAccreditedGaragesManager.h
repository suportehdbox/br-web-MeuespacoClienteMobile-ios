//
//  DAAccreditedGaragesManager.h
//  DirectAssist
//
//  Created by Ricardo Ramos on 06/04/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class DAAccreditedGaragesManager;

@protocol DAAccreditedGaragesManagerDelegate <NSObject>
@optional
- (void)accreditedGaragesManager:(DAAccreditedGaragesManager *)manager didFindAccreditedGarages:(NSMutableArray *)garages;
- (void)accreditedGaragesManager:(DAAccreditedGaragesManager *)manager didFailWithError:(NSError *)error;
- (void)accreditedGaragesManagerDidNotFindAccreditedGarages:(DAAccreditedGaragesManager *)manager;
- (void)accreditedGaragesManagerDidFailWithNoInternetConnection:(DAAccreditedGaragesManager *)manager;
@end


@interface DAAccreditedGaragesManager : NSObject <NSXMLParserDelegate> {
	id <DAAccreditedGaragesManagerDelegate> __unsafe_unretained delegate;
	
	int selectedClientID;
	
	NSMutableData *wsData;
	NSXMLParser *xmlParser;
	BOOL recordEnabled;
	BOOL recordsFound;
	BOOL errorsFound;
	NSMutableString *soapResults;
	NSMutableDictionary *wsResults;
	
	NSMutableArray *garages;
}

@property (nonatomic, unsafe_unretained) id <DAAccreditedGaragesManagerDelegate> delegate;

- (void)findAccreditedGaragesWithClientID:(int)clientID withCoordinate:(CLLocationCoordinate2D)coordinate;


@end
