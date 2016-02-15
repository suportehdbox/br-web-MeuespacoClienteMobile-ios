//
//  DAAccessLogWS.h
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 7/23/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DAWebServiceActionResult;

@interface DAAccessLogWS : NSObject {

	NSMutableData *wsData;
	NSXMLParser *xmlParser;
	BOOL recordEnabled;
	BOOL recordsFound;
	BOOL errorsFound;
	NSMutableString *soapResults;
	NSMutableDictionary *wsResults;
}

- (void)saveAccessLog:(DAWebServiceActionResult *)actionResult;

@end
