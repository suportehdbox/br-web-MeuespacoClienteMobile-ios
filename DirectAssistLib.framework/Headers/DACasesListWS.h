//
//  DACasesListWS.h
//  DirectAssistFord
//
//  Created by Ricardo Ramos on 8/3/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DACasesListWSDelegate;

@interface DACasesListWS : NSObject <NSXMLParserDelegate> {

	id <DACasesListWSDelegate> delegate;

	BOOL recordsFound;
	BOOL errorsFound;
	
	NSMutableData *wsData;
	NSXMLParser *xmlParser;
	BOOL recordEnabled;
	NSMutableString *soapResults;
	NSMutableDictionary *wsResults;	
	
	NSMutableArray *cases;
	
	DAAssistanceType internalAssistanceType;
}

@property (nonatomic, strong) id <DACasesListWSDelegate> delegate;

- (void)listCasesWithAssistanceType:(DAAssistanceType)assistanceType;

@end

@protocol DACasesListWSDelegate <NSObject>
@required
- (void)casesList:(DACasesListWS *)casesList didListCases:(NSArray *)cases;
- (void)casesList:(DACasesListWS *)casesList didFailWithError:(NSString *)errorMessage;
@end