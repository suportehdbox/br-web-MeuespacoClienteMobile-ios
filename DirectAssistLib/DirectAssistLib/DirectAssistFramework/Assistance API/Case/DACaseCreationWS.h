//
//  DACaseCreationWS.h
//  DirectAssistItau
//
//  Created by Ricardo Ramos on 8/12/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAFileBase.h"

@protocol DACaseCreationWSDelegate;

@interface DACaseCreationWS : NSObject <NSXMLParserDelegate> {

	id <DACaseCreationWSDelegate> delegate;
	
	DAFileBase *selectedCase;	
	
	NSMutableData *wsData;
	NSXMLParser *xmlParser;
	BOOL recordEnabled;
	NSMutableString *soapResults;
	NSMutableDictionary *wsResults;
	
}

@property (nonatomic, strong) id <DACaseCreationWSDelegate> delegate;

- (void)createCase:(DAFileBase *)newCase forAssistanceType:(DAAssistanceType)assistanceType;

@end

@protocol DACaseCreationWSDelegate <NSObject>
@optional

- (void)caseCreationWS:(DACaseCreationWS *)caseCreationWS 
				didCreateCase:(DAFileBase *)createdCase;

- (void)caseCreationWS:(DACaseCreationWS *)caseCreationWS 
	  didFailWithErrorMessage:(NSString *)errorMessage;

@end