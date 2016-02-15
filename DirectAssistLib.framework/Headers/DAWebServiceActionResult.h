//
//  DAWebServiceActionResult.h
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 7/20/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
	kDAActionCreateCase = 1,
	kDAActionListAccreditedGarages = 2,
	kDAActionFindPolicy = 3,
	kDAActionGetServiceDispatch = 4,
	kDAActionListPolicies = 5,
	kDAActionSavePolicy = 6,
	kDAActionDeletePolicy = 7,
	kDAActionListDealers = 8
};
typedef NSInteger kDAActionType;

enum {
	kDAResultNotFound = -100,
	kDAResultSuccess = 0,
	kDAResultInvalidToken = 99
};
typedef NSInteger kDAResultType;

@interface DAWebServiceActionResult : NSObject {
	kDAActionType actionType;
	NSString *actionParameters;
	kDAResultType resultType;
	NSString *errorMessage;
}

@property (assign) kDAActionType actionType;
@property (nonatomic, copy) NSString *actionParameters;
@property (assign) kDAResultType resultType;
@property (nonatomic, copy) NSString *errorMessage;

- (id)initWithResultType:(kDAResultType)result errorMessage:(NSString *)message;
- (id)initWithActionType:(kDAActionType)action actionParameters:(NSString *)parameters resultType:(kDAResultType)result;

@end
