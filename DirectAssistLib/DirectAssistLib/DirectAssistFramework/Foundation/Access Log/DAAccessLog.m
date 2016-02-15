//
//  DAAccessLog.m
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 7/23/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DAAccessLog.h"
#import "DAAccessLogWS.h"

@implementation DAAccessLog

+ (void)saveAccessLog:(DAWebServiceActionResult *)actionResult {

	DAAccessLogWS *accessLogWS = [[DAAccessLogWS alloc] init];
	[accessLogWS saveAccessLog:actionResult];
}

@end
