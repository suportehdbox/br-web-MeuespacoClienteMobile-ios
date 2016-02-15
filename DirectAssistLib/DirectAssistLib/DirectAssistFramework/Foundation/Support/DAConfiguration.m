//
//  DAConfiguration.m
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 14/06/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import "DAConfiguration.h"

#define DESENV_ENVIRONMENT 0

@implementation DAConfiguration

static DAConfiguration *sharedConfiguration;

@synthesize applicationID;
@synthesize applicationVersion;
@synthesize applicationClient;
@synthesize directAssistWebServiceURL;
@synthesize automotiveWebServiceURL;
@synthesize automakerWebServiceURL;
@synthesize propertyWebServiceURL;
@synthesize WS_MONDIAL_URL;
@synthesize webserviceToken;
 

- (id)init {
    self = [super init];
	if (self) {
			
		applicationID = 1;
		applicationVersion = 1.0;

        WS_MONDIAL_URL = @"https://www.webmondial.com.br/directassistws/assist24h.asmx";
        propertyWebServiceURL = @"https://www.webmondial.com.br/directassistws/v2/property.asmx";
        automotiveWebServiceURL = @"https://www.webmondial.com.br/directassistws/v2/automotive.asmx";
        automakerWebServiceURL = @"https://www.webmondial.com.br/directassistws/v2/automaker.asmx";
        directAssistWebServiceURL = @"https://www.webmondial.com.br/directassistws/v2/directassistws.asmx";
        webserviceToken = @"3d5900ae-111a-45be-96b3-d9e4606ca793";

//        WS_MONDIAL_URL = @"http://desenv.webmondial.com.br/directassistwstre/mobile/assist24h.asmx";
//        directAssistWebServiceURL = @"http://desenv.webmondial.com.br/directassistwstre/v2/directassistWS.asmx";
//        automotiveWebServiceURL = @"http://desenv.webmondial.com.br/directassistwstre/v2/automotive.asmx";
//        automakerWebServiceURL = @"http://desenv.webmondial.com.br/directassistwstre/v2/automaker.asmx";
//        propertyWebServiceURL = @"http://desenv.webmondial.com.br/directassistwstre/v2/property.asmx";
//        webserviceToken = @"3d5900ae-111a-45be-96b3-d9e4606ca793";

//		if (DESENV_ENVIRONMENT) {
//			
//			WS_MONDIAL_URL = @"http://desenv.webmondial.com.br/mobile/assist24h.asmx";
//			directAssistWebServiceURL = @"http://desenv.webmondial.com.br/mobile/v6/directassistWS.asmx";
//			automotiveWebServiceURL = @"http://desenv.webmondial.com.br/mobile/v6/automotive.asmx";
//			automakerWebServiceURL = @"http://desenv.webmondial.com.br/mobile/v6/automaker.asmx";
//			propertyWebServiceURL = @"http://desenv.webmondial.com.br/mobile/v6/property.asmx";
//			webserviceToken = @"3d5900ae-111a-45be-96b3-d9e4606ca793";
//		
//		} else {
//		
//			WS_MONDIAL_URL = @"http://www.webmondial.com.br/mobile/assist24h.asmx"; 
//			directAssistWebServiceURL = @"http://www.webmondial.com.br/mobile/v5/directassistWS.asmx";
//			automotiveWebServiceURL = @"http://www.webmondial.com.br/mobile/v5/automotive.asmx";
//			automakerWebServiceURL = @"http://www.webmondial.com.br/mobile/v5/automaker.asmx";
//			propertyWebServiceURL = @"http://www.webmondial.com.br/mobile/v5/property.asmx";
//			webserviceToken = @"3d5900ae-111a-45be-96b3-d9e4606ca793";
//		}
		
	}
	return self;
}

+ (DAConfiguration *)settings {
	
    @synchronized(self)	{
        if (sharedConfiguration == nil) {
            sharedConfiguration = [[self alloc] init];
        }
    }
    return sharedConfiguration;
}


@end
