//
//  UIDevice-Hardware.m
//  LibertyMutual
//
//  Created on 9/26/10.
//  Copyright 2010 Liberty Mutual. All rights reserved.
//

#import "UIDevice-Hardware.h"
#include <sys/sysctl.h>


@implementation UIDevice (Hardware)

/*
 Platforms
 
 iPhone1,2 ->	iPhone 3G
 iPhone2,1 ->	iPhone 3GS
 iPhone3,1 ->	iPhone 4
 iPhone3,2 ->	iPhone 4
 iPhone3,3 ->	iPhone 4
 
 i386, x86_64 -> iPhone Simulator
*/

#pragma mark sysctlbyname utils
- (NSString *)getSysInfoByName:(char *)typeSpecifier
{
	size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    char *answer = malloc(size);
	sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
	NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
	free(answer);
	return results;
}

- (NSString *)platform
{
	return [self getSysInfoByName:"hw.machine"];
}

#pragma mark platform type and name utils
- (NSUInteger)platformType
{
	NSString *platform = [self platform];
	
	if ([platform isEqualToString:@"iPhone1,2"])	return UIDevice3GiPhone;
	if ([platform hasPrefix:@"iPhone2"])			return UIDevice3GSiPhone;
	if ([platform hasPrefix:@"iPhone3"])			return UIDevice4iPhone;
	
	if ([platform hasPrefix:@"iPhone"])				return UIDeviceUnknowniPhone;
	
	if ([platform hasSuffix:@"86"] || [platform isEqual:@"x86_64"])
	{
		if ([[UIScreen mainScreen] bounds].size.width < 768)
			return UIDeviceiPhoneSimulatoriPhone;
		else 
			return UIDeviceiPhoneSimulatoriPad;
		
		return UIDeviceiPhoneSimulator;
	}
	return UIDeviceUnknown;
}

- (NSString *)platformString
{
	switch ([self platformType])
	{
		case UIDevice3GiPhone:				return IPHONE_3G_NAMESTRING;
		case UIDevice3GSiPhone:				return IPHONE_3GS_NAMESTRING;
		case UIDevice4iPhone:				return IPHONE_4_NAMESTRING;
		case UIDeviceUnknowniPhone:			return IPHONE_UNKNOWN_NAMESTRING;
			
		case UIDeviceiPhoneSimulator:		return IPHONE_SIMULATOR_NAMESTRING;
		case UIDeviceiPhoneSimulatoriPhone: return IPHONE_SIMULATOR_IPHONE_NAMESTRING;
		case UIDeviceiPhoneSimulatoriPad:	return IPHONE_SIMULATOR_IPAD_NAMESTRING;
			
		default: return IPOD_FAMILY_UNKNOWN_DEVICE;
	}
}

@end
