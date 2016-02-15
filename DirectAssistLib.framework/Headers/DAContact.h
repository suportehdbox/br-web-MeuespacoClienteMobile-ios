//
//  DAContact.h
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 7/10/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DAAddress, DAPhone;

@interface DAContact : NSObject {
	NSString *name;
	DAAddress *address;
	DAPhone *businessPhone;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) DAAddress *address;
@property (nonatomic, strong) DAPhone *businessPhone;

@end	
