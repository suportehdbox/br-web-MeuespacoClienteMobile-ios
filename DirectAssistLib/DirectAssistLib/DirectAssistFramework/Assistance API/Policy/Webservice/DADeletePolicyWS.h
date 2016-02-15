//
//  DADeletePolicyWS.h
//  DirectAssistFramework
//
//  Created by Ricardo Ramos on 7/21/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DAPolicyManagerDelegate;
@class DAPolicyBase;

@interface DADeletePolicyWS : NSObject <NSXMLParserDelegate> {
	
	id <DAPolicyManagerDelegate> delegate;
	
	NSMutableData *wsData;
	NSXMLParser *xmlParser;
	BOOL recordEnabled;
	BOOL recordsFound;
	BOOL errorsFound;
	NSMutableString *soapResults;
	NSMutableDictionary *wsResults;
	
	DAPolicyBase *policyToDelete;
}

@property (nonatomic, strong) id <DAPolicyManagerDelegate> delegate;

- (void)deletePolicy:(DAPolicyBase *)policy;

@end

