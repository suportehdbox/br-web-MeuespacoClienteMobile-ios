//
//  DAPropertyManager.h
//  DirectAssistFord
//
//  Created by Ricardo Ramos on 8/6/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DAPropertyManager : NSObject {

	NSMutableArray *modules;
	NSArray *causesList;
	NSArray *servicesList;
}

@property (nonatomic, strong) NSMutableArray *modules;
@property (nonatomic, strong) NSArray *causesList;
@property (nonatomic, strong) NSArray *servicesList;

- (id)initWithClient:(DAClientBase *)client;

@end
