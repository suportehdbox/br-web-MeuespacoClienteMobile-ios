//
//  AppConfig.h
//  DirectAssist
//
//  Created by Ricardo Ramos on 17/04/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Client, AutomotiveService;


@interface AppConfig : NSObject {
	
	Client				*appClient;
	AutomotiveService	*automotiveService;
}

@property (nonatomic, readonly)		Client				*appClient;
@property (nonatomic, strong)		AutomotiveService	*automotiveService;

+ (AppConfig *) sharedConfiguration;
+ (Client *) client;

@end

