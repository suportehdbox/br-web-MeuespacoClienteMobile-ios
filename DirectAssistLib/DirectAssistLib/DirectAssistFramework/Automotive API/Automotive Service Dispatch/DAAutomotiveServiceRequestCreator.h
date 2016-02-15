//
//  DAAutomotiveServiceRequestCreator.h
//  DirectAssist
//
//  Created by Ricardo Ramos on 29/04/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAFileBase.h"

@class DAAutomotiveServiceRequestCreator;

@protocol DAAutomotiveServiceRequestCreatorDelegate <NSObject>
@required
- (void)automotiveServiceRequestCreator:(DAAutomotiveServiceRequestCreator *)serviceRequestCreator
				didCreateServiceRequest:(NSString *)fileNumber request:(NSString *)requestNumber newFile:(DAFileBase *)newFileObj;
- (void)automotiveServiceRequestCreator:(DAAutomotiveServiceRequestCreator *)serviceRequestCreator 
					   didFailWithError:(NSError *)error;
- (void)automotiveServiceRequestCreatorDidFailWithNoInternet:(DAAutomotiveServiceRequestCreator *)serviceRequestCreator;
@end

@interface DAAutomotiveServiceRequestCreator : NSObject <NSXMLParserDelegate> {
	id <DAAutomotiveServiceRequestCreatorDelegate> __unsafe_unretained delegate;
	
	DAFileBase *selectedFile;	
	
	NSMutableData *wsData;
	NSXMLParser *xmlParser;
	BOOL recordEnabled;
	NSMutableString *soapResults;
	NSMutableDictionary *wsResults;	
}

@property (nonatomic, unsafe_unretained) id <DAAutomotiveServiceRequestCreatorDelegate> delegate;

- (void)createServiceRequest:(DAFileBase *)file;

@end
