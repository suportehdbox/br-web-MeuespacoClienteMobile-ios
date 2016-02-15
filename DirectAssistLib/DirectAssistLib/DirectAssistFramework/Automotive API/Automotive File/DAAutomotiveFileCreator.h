//
//  FileWS.h
//  DirectAssist
//
//  Created by Ricardo Ramos on 24/03/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAFileBase.h"

@class DAAutomotiveFileCreator;

@protocol DAAutomotiveFileCreatorDelegate <NSObject>
@required
- (void)automotiveFileCreator:(DAAutomotiveFileCreator *)fileCreator didCreateFile:(NSString *)fileNumber 
					  request:(NSString *)requestNumber newFile:(DAFileBase *)newFileObj;
- (void)automotiveFileCreator:(DAAutomotiveFileCreator *)fileCreator didFailWithError:(NSError *)error;
- (void)automotiveFileCreatorDidFailWithNoInternetConnection:(DAAutomotiveFileCreator *)fileCreator;
@end


@interface DAAutomotiveFileCreator : NSObject <NSXMLParserDelegate> {
	id <DAAutomotiveFileCreatorDelegate> __unsafe_unretained delegate;
	
	DAFileBase *selectedFile;	
	
	NSMutableData *wsData;
	NSXMLParser *xmlParser;
	BOOL recordEnabled;
	NSMutableString *soapResults;
	NSMutableDictionary *wsResults;
}

@property (nonatomic, unsafe_unretained) id <DAAutomotiveFileCreatorDelegate> delegate;

- (void)createFile:(DAFileBase *)newFile;

@end
