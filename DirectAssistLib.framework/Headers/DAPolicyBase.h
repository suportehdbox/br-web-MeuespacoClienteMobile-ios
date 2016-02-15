//
//  DAPolicyBase.h
//  DirectAssist
//
//  Created by Ricardo Ramos on 12/03/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define FOOTER_GROUP_ID_KEY @"FOOTER_GROUP_ID_KEY"
#define FOOTER_GROUP_ID_CHANGE_NOTIFICATION @"FOOTER_GROUP_ID_CHANGE_NOTIFICATION"

@interface DAPolicyBase : NSObject {
	NSString *customerName;
	NSString *customerDoc;
	NSString *policyID;
	NSInteger _groupID;
	NSDate *_startDate;
}

@property (nonatomic, copy) NSString *customerName;
@property (nonatomic, copy) NSString *customerDoc;
@property (nonatomic, copy) NSString *policyID;
@property (nonatomic, assign) NSInteger groupID;
@property (nonatomic, strong) NSDate *startDate;

+ (NSMutableArray *) getPolicies;
- (void) addPolicy;
- (BOOL) notEmpty;

@end
