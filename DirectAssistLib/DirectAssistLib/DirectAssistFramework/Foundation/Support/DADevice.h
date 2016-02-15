//
//  DADevice.h
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 30/05/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DADevice : NSObject {
}

@property (unsafe_unretained, nonatomic, readonly) NSString *UID;
@property (nonatomic, readonly) NSInteger manufacturerID;
@property (nonatomic, readonly) BOOL canMakeCalls;

+ (DADevice *)currentDevice;

@end
