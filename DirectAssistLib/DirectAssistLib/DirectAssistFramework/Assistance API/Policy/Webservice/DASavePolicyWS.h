//
//  DASavePolicyWS.h
//  DirectAssistFramework
//
//  Created by Ricardo Ramos on 7/20/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DAPolicyManagerDelegate;
@class DAPolicyBase;

@interface DASavePolicyWS : NSObject <NSXMLParserDelegate> {

	id <DAPolicyManagerDelegate> delegate;
	DAPolicyBase *policyToSave;
	
	NSMutableData *wsData;
	NSXMLParser *xmlParser;
	BOOL recordEnabled;
	BOOL recordsFound;
	BOOL errorsFound;
	NSMutableString *soapResults;
	NSMutableDictionary *wsResults;
	
}

@property (nonatomic, strong) id <DAPolicyManagerDelegate> delegate;

- (void)savePolicy:(DAPolicyBase *)policy;
@end

