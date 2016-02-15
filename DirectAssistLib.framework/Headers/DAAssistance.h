//
//  DAAssistance.h
//  DirectAssistFord
//
//  Created by Ricardo Ramos on 7/28/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "DAAutomakerManager.h"
#import "DAAutomotiveManager.h"
#import "DAPropertyManager.h"
#import "DAClientBase.h" 

@class DAAutomakerManager;

enum {
	kDAAssistanceTypeAutomotive = 0,
	kDAAssistanceTypeAutomaker,
	kDAAssistanceTypeProperty
};
typedef NSInteger DAAssistanceType;

@interface DAAssistance : NSObject {

	DAAutomakerManager *automakerManager;
	DAAutomotiveManager *automotiveManager;
	DAPropertyManager *propertyManager;
}

@property (nonatomic, strong) DAAutomakerManager *automakerManager;
@property (nonatomic, strong) DAAutomotiveManager *automotiveManager;
@property (nonatomic, strong) DAPropertyManager *propertyManager;

- (void)initializeClient:(DAClientBase *)client;
+ (id)application;

@end
