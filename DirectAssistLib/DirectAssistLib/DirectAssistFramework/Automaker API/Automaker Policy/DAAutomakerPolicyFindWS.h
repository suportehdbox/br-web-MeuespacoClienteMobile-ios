//
//  DAAutomakerPolicyFindWS.h
//  DirectAssistFord
//
//  Created by Ricardo Ramos on 8/18/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAPolicyFindBase.h"

@interface DAAutomakerPolicyFindWS : DAPolicyFindBase <NSXMLParserDelegate> {
	
	NSMutableData *wsData;
	NSXMLParser *xmlParser;
	BOOL recordEnabled;
	BOOL recordsFound;
	BOOL errorsFound;
	NSMutableString *soapResults;
	NSMutableDictionary *wsResults;

	NSString *vehicleChassis;
}

@end
