//
//  AppConfig.m
//  DirectAssist
//
//  Created by Ricardo Ramos on 17/04/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//	

#import "AppConfig.h"
#import "DAUserPhone.h"
#import "Client.h" 

@implementation AppConfig

static AppConfig *sharedConfigData;

@synthesize appClient;
@synthesize automotiveService;

- (id) init {

	appClient = [[Client alloc] init];
    
//	automotiveService = [[AutomotiveService alloc] initWithClient:appClient];

	return self;
}

+ (AppConfig *) sharedConfiguration {
	
    @synchronized(self)	{
        if (sharedConfigData == nil) {
            sharedConfigData = [[self alloc] init];
        }
    }
    return sharedConfigData;
}

+ (Client *) client {
	return [[AppConfig sharedConfiguration] appClient];
}

@end

