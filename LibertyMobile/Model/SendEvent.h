//
//  SendEvent.h
//  LibertyMutual
//
//  Created by Kevin Ingvalson on 8/31/10.
//  Copyright 2010 Liberty Mutual. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"
#import "User.h"


@interface SendEvent : NSObject {

}

- (NSString *) applicationSignature;

@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) NSString *photoOrder;

@end
