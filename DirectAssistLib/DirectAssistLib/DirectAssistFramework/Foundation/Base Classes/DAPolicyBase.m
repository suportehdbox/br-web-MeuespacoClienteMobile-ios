//
//  DAPolicyBase.m
//  DirectAssist
//
//  Created by Ricardo Ramos on 12/03/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import "DAPolicyBase.h"

@implementation DAPolicyBase

@synthesize customerName, policyID, customerDoc;
@synthesize groupID = _groupID;
@synthesize startDate = _startDate;

+ (NSMutableArray *) getPolicies {
	return nil;
}

- (void) addPolicy {
}

- (BOOL) notEmpty {
    if (self.policyID && self.policyID.length > 0) {
        return YES;
    }
    return NO;
}

//@property (nonatomic, copy) NSString *customerName;
//@property (nonatomic, copy) NSString *customerDoc;
//@property (nonatomic, copy) NSString *policyID;
//@property (nonatomic, assign) NSInteger groupID;
//@property (nonatomic, strong) NSDate *startDate;

@end
