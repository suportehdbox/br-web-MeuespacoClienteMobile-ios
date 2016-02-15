//
//  ServiceDispatchWS.h
//  DirectAssist
//
//  Created by Ricardo Ramos on 23/03/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAServiceDispatch.h"

@class DAServiceDispatchFinder;

@protocol DAServiceDispatchFinderDelegate <NSObject>
@required
- (void)serviceDispatchFinder:(DAServiceDispatchFinder *)dispatchFinder didFindServiceDispatch:(DAServiceDispatch *)dispatch;
- (void)serviceDispatchFinder:(DAServiceDispatchFinder *)dispatchFinder didFailWithError:(NSError *)error;
- (void)serviceDispatchFinderDidFailWithNoResults:(DAServiceDispatchFinder *)dispatchFinder;
- (void)serviceDispatchFinderDidFailWithNoInternetConnection:(DAServiceDispatchFinder *)dispatchFinder;
@end

@interface DAServiceDispatchFinder : NSObject <NSXMLParserDelegate> {
	id <DAServiceDispatchFinderDelegate> __unsafe_unretained delegate;
	
	NSInteger selectedFileNumber;

	BOOL errorsFound;
	BOOL recordsFound;
	
	NSMutableData *wsData;
	NSXMLParser *xmlParser;
	BOOL recordEnabled;
	NSMutableString *soapResults;
	NSMutableDictionary *wsResults;
}

@property (nonatomic, unsafe_unretained) id <DAServiceDispatchFinderDelegate> delegate;

- (void)getServiceDispatchWithFileNumber:(NSInteger)fileNumber;

@end
