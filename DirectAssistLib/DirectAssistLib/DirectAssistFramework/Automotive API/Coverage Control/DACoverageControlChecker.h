//
//  CoverageControlWS.h
//  DirectAssist
//
//  Created by Ricardo Ramos on 05/05/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DAFileBase;

@protocol DACoverageControlCheckerDelegate <NSObject>
@required
- (void)coverageControlDidGetOK:(DAFileBase *)file;
- (void)coverageControlDidGetRefusal:(NSString *)message;
- (void)coverageControlDidFailWithError:(NSError *)error;
- (void)coverageControlDidFailWithNoInternet;
@end

@interface DACoverageControlChecker : NSObject <NSXMLParserDelegate> {
	id <DACoverageControlCheckerDelegate> __unsafe_unretained delegate;
	
	DAFileBase *selectedFile;	
	
	NSMutableData *wsData;
	NSXMLParser *xmlParser;
	BOOL recordEnabled;
	BOOL errorsFound;
	BOOL recordsFound;
	NSMutableString *soapResults;
	NSMutableDictionary *wsResults;
}

@property (nonatomic, unsafe_unretained) id <DACoverageControlCheckerDelegate> delegate;

- (void)checkCoverages:(DAFileBase *)newFile;

@end
