//
//  UIDevice-Hardware.h
//  LibertyMutual
//
//  Created on 9/26/10.
//  Copyright 2010 Liberty Mutual. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IPHONE_3G_NAMESTRING			@"iPhone 3G"
#define IPHONE_3GS_NAMESTRING			@"iPhone 3GS" 
#define IPHONE_4_NAMESTRING				@"iPhone 4" 
#define IPHONE_UNKNOWN_NAMESTRING		@"Unknown iPhone"

#define IPOD_FAMILY_UNKNOWN_DEVICE			@"Unknown iOS device"
#define IPHONE_SIMULATOR_NAMESTRING			@"iPhone Simulator"
#define IPHONE_SIMULATOR_IPHONE_NAMESTRING	@"iPhone Simulator"
#define IPHONE_SIMULATOR_IPAD_NAMESTRING	@"iPad Simulator"

typedef enum {
	UIDeviceUnknown,
	
	UIDeviceiPhoneSimulator,
	UIDeviceiPhoneSimulatoriPhone,
	UIDeviceiPhoneSimulatoriPad,
	
	UIDevice3GiPhone,
	UIDevice3GSiPhone,
	UIDevice4iPhone,
	
	UIDeviceUnknowniPhone,
	
} UIDevicePlatform;

@interface UIDevice (Hardware) {

}

- (NSString *)platform;
- (NSUInteger)platformType;
- (NSString *)platformString;

@end
