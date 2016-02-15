//
//  DAPropertyPolicy.h
//  DirectAssistItau
//
//  Created by Ricardo Ramos on 8/11/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAPolicyBase.h"

@class DAAddress;

@interface DAPropertyPolicy : DAPolicyBase {


	DAAddress *address;
}

@property (nonatomic, strong) DAAddress *address;

@end
