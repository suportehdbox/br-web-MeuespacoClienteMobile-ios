//
//  DAAutomakerPolicyListWS.h
//  DirectAssistFord
//
//  Created by Ricardo Ramos on 8/3/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAPolicyListBase.h"

@interface DAAutomakerPolicyListWS : DAPolicyListBase <NSXMLParserDelegate> {

	BOOL recordsFound;
	BOOL errorsFound;
	
	NSMutableData *wsData;
	NSXMLParser *xmlParser;
	BOOL recordEnabled;
	NSMutableString *soapResults;
	NSMutableDictionary *wsResults;	
	
	NSMutableArray *policies;
}

@end
