//
//  DAConfiguration.h
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 14/06/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DAClientBase;

@interface DAConfiguration : NSObject {

	// Application settings
	NSInteger		applicationID;
	double			applicationVersion;
	DAClientBase	*applicationClient;
	
	// WebServices settings
	NSString		*WS_MONDIAL_URL;
	NSString		*directAssistWebServiceURL;
	NSString		*automotiveWebServiceURL;
	NSString		*automakerWebServiceURL;
	NSString		*propertyWebServiceURL;
	NSString		*webserviceToken;
}

// Application settings
@property (nonatomic, assign) NSInteger applicationID;
@property (nonatomic, assign) double applicationVersion;
@property (nonatomic, strong) DAClientBase *applicationClient;

// WebServices settings
@property (nonatomic, strong) NSString *WS_MONDIAL_URL;
@property (nonatomic, strong) NSString *directAssistWebServiceURL;
@property (nonatomic, strong) NSString *automotiveWebServiceURL;
@property (nonatomic, strong) NSString *automakerWebServiceURL;
@property (nonatomic, strong) NSString *propertyWebServiceURL;
@property (nonatomic, strong) NSString *webserviceToken;

+ (DAConfiguration *) settings;

@end
