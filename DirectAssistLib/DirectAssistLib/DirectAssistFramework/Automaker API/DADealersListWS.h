//
//  DADealersListWS.h
//  DirectAssistFord
//
//  Created by Ricardo Ramos on 8/3/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol DADealersListWSDelegate;

@interface DADealersListWS : NSObject <NSXMLParserDelegate> {

	id <DADealersListWSDelegate> __unsafe_unretained delegate;
	
	NSMutableData *wsData;
	NSXMLParser *xmlParser;
	BOOL recordEnabled;
	BOOL recordsFound;
	BOOL errorsFound;
	NSMutableString *soapResults;
	NSMutableDictionary *wsResults;
	
	NSMutableArray *dealers;
}

@property (nonatomic, unsafe_unretained) id <DADealersListWSDelegate> delegate;

- (void)listDealersWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end

@protocol DADealersListWSDelegate <NSObject>
@optional
- (void)dealersList:(DADealersListWS *)dealersList didListDealers:(NSMutableArray *)dealers;
- (void)dealersList:(DADealersListWS *)dealersList didFailWithErrorMessage:(NSString *)errorMessage;
@end
