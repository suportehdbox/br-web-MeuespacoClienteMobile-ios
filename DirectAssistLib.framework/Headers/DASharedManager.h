//
//  DASharedManager.h
//  DirectAssistLib
//
//  Created by Danilo Salvador on 11/5/12.
//
//

#import <Foundation/Foundation.h>

@interface DASharedManager : NSObject
{
    NSMutableArray *caseList;
}

@property (nonatomic, strong) NSMutableArray  *caseList;

+ (DASharedManager *)sharedManager;
- (void)addCase:(NSString *)caseNumber;
- (void)clearCaseList;

@end
