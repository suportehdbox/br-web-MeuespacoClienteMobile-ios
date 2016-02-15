//
//  DAAutomakerManager.h
//  DirectAssistFord
//
//  Created by Ricardo Ramos on 7/28/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAClientBase.h"

@interface DAAutomakerManager : NSObject {

	NSMutableArray *modules;
	NSArray *causesList;
	NSArray *problemsList;
	NSArray *servicesList;
}

@property (nonatomic, strong) NSMutableArray *modules;
@property (nonatomic, strong) NSArray *causesList;
@property (nonatomic, strong) NSArray *problemsList;
@property (nonatomic, strong) NSArray *servicesList;

- (id)initWithClient:(DAClientBase *)client;

@end
