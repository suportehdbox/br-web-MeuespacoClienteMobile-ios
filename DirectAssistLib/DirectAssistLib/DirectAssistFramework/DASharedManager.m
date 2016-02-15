//
//  DASharedManager.m
//  DirectAssistLib
//
//  Created by Danilo Salvador on 11/5/12.
//
//

#import "DASharedManager.h"

@implementation DASharedManager
@synthesize caseList;

- (id)init
{
    self = [super init];
    if (self) {
        [self clearCaseList];
    }
    return self;
}

+ (DASharedManager *)sharedManager {
	static DASharedManager *_sharedManager = nil;
	
	if (_sharedManager == nil) {
		_sharedManager = [[DASharedManager alloc] init];
	}
	return _sharedManager;
}

- (void)addCase:(NSString *)caseNumber{
    
    [caseList addObject:caseNumber];
}

- (void)clearCaseList
{
    caseList = [[NSMutableArray alloc] init];
}


@end
