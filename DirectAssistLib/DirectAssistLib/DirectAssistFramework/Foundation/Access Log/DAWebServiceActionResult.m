//
//  DAWebServiceActionResult.m
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 7/20/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DAWebServiceActionResult.h"

@implementation DAWebServiceActionResult

@synthesize actionType, actionParameters, resultType, errorMessage;

- (id)init {
	if (self = [super init]) {
		self.errorMessage = @"";
		self.actionParameters = @"";
	}
	return self;	
}

- (id)initWithResultType:(NSInteger)result errorMessage:(NSString *)message {

	if (self =		 [super init]) {
		self.resultType = result;
		self.errorMessage = message;
		self.actionParameters = @"";
	}
	return self;
}

- (id)initWithActionType:(kDAActionType)action actionParameters:(NSString *)parameters resultType:(kDAResultType)result {

	if (self = [super init]) {
		self.actionType = action;
		self.actionParameters = parameters;
		self.resultType = result;
	}
	return self;
}

@end
