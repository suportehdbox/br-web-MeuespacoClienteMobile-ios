//
//  DAAutomotiveCaseListWS.h
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 7/24/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DAAutomotiveCaseListWSDelegate;

@interface DAAutomotiveCaseListWS : NSObject <NSXMLParserDelegate> {

	id <DAAutomotiveCaseListWSDelegate> delegate;

	BOOL recordsFound;
	BOOL errorsFound;
	
	NSMutableData *wsData;
	NSXMLParser *xmlParser;
	BOOL recordEnabled;
	NSMutableString *soapResults;
	NSMutableDictionary *wsResults;	
	
	NSMutableArray *cases;
}

@property (nonatomic, strong) id <DAAutomotiveCaseListWSDelegate> delegate;

- (void)listAutomotiveCases;

@end

@protocol DAAutomotiveCaseListWSDelegate <NSObject>
@required
- (void)automotiveCaseList:(DAAutomotiveCaseListWS *)caseList didListCases:(NSArray *)cases;
- (void)automotiveCaseList:(DAAutomotiveCaseListWS *)caseList didFailWithError:(NSString *)errorMessage;
@end