//
//  DAAccessLog.h
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 7/23/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAWebServiceActionResult.h"

@interface DAAccessLog : NSObject {

}

+ (void)saveAccessLog:(DAWebServiceActionResult *)actionResult;

@end
