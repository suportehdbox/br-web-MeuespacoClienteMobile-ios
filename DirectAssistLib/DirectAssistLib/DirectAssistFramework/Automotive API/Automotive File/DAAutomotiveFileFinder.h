//
//  DAAutomotiveFileFinder.h
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 14/02/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DAAutomotiveFileFinder;

@protocol DAAutomotiveFileFinderDelegate <NSObject>
@required
- (void)automotiveFileFinder:(DAAutomotiveFileFinder *)fileFinder didFindFiles:(NSMutableArray *)files;
- (void)automotiveFileFinderDidNotFindFiles:(DAAutomotiveFileFinder *)fileFinder;
- (void)automotiveFileFinderDidFailWithNoInternetConnection:(DAAutomotiveFileFinder *)fileFinder;
- (void)automotiveFileFinder:(DAAutomotiveFileFinder *)fileFinder didFailWithError:(NSError *)error;
@end

@interface DAAutomotiveFileFinder : NSObject <NSXMLParserDelegate> {
	id <DAAutomotiveFileFinderDelegate> __unsafe_unretained delegate;
	
	NSString *selectedPolicyID;
	BOOL recordsFound;
	BOOL errorsFound;
	
	NSMutableData *wsData;
	NSXMLParser *xmlParser;
	BOOL recordEnabled;
	NSMutableString *soapResults;
	NSMutableDictionary *wsResults;	
	
	NSMutableArray *files;
}

@property (nonatomic, unsafe_unretained) id <DAAutomotiveFileFinderDelegate> delegate;

- (void)findFilesWithPolicyID:(NSString *)policyID;

@end
