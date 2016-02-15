//
//  DAPropertyPolicyFindWS.h
//  DirectAssistItau
//
//  Created by Ricardo Ramos on 8/11/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAPolicyFindBase.h"

@interface DAPropertyPolicyFindWS : DAPolicyFindBase <NSXMLParserDelegate> {

	NSMutableData *wsData;
	NSXMLParser *xmlParser;
	BOOL recordEnabled;
	BOOL recordsFound;
	BOOL errorsFound;
	NSMutableString *soapResults;
	NSMutableDictionary *wsResults;
}

@end

