//
//  DAAutomakerCreateCaseWS.h
//  DirectAssistFord
//
//  Created by Ricardo Ramos on 8/5/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAFileBase.h"

@protocol DAAutomakerCreateCaseWSDelegate;

@interface DAAutomakerCreateCaseWS : NSObject <NSXMLParserDelegate> {

	id <DAAutomakerCreateCaseWSDelegate> delegate;
	
	DAFileBase *selectedCase;	
	
	NSMutableData *wsData;
	NSXMLParser *xmlParser;
	BOOL recordEnabled;
	NSMutableString *soapResults;
	NSMutableDictionary *wsResults;
	
}

@property (nonatomic, strong) id <DAAutomakerCreateCaseWSDelegate> delegate;

- (void)createCase:(DAFileBase *)automakerCase;

@end

@protocol DAAutomakerCreateCaseWSDelegate <NSObject>
@optional

- (void)automakerCreateCaseWS:(DAAutomakerCreateCaseWS *)automakerCreateCaseWS 
				didCreateCase:(DAFileBase *)createdCase;

- (void)automakerCreateCaseWS:(DAAutomakerCreateCaseWS *)automakerCreateCaseWS 
				didFailWithErrorMessage:(NSString *)errorMessage;

@end