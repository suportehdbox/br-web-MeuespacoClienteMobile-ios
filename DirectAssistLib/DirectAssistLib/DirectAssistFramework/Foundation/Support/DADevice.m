//
//  Device.m
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 30/05/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import "DADevice.h"
#include <sys/types.h>
#include <sys/sysctl.h>

#define MANUFACTURER_ID	1

static DADevice *sharedDevice;

@implementation DADevice

+ (DADevice *)currentDevice {
	if (nil == sharedDevice) 
		sharedDevice = [[DADevice alloc] init];
	
	return sharedDevice;
}

- (BOOL)canMakeCalls {
	size_t size;  
	sysctlbyname("hw.machine", NULL, &size, NULL, 0);  
	char *machine = malloc(size);  
	sysctlbyname("hw.machine", machine, &size, 0, 0);  
	NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];  
	free(machine);  
	
	if ([platform isEqualToString:@"i386"]) return YES;  
	if ([platform hasPrefix:@"iPhone"]) return YES;  
	if ([platform hasPrefix:@"iPod"])   return NO;  
	
	return NO;
}

- (NSString *)UID {
    NSString *udid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return udid;
//	return [UIDevice currentDevice].uniqueIdentifier;
}

- (NSInteger)manufacturerID {
	return MANUFACTURER_ID;
}


@end
