//
//  DACallMaker.m
//  DirectAssist
//
//  Created by Ricardo Ramos on 19/04/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import "DACallMaker.h"

@implementation DACallMaker

- (void)callToClientPhoneNumber:(UIView *)view {	
	if ([AppConfig sharedConfiguration].appClient.altPhoneNumber) {
		UIActionSheet *callAsk = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:nil otherButtonTitles:@"Ligar: capitais", @"Ligar: demais regiões", nil];
		[callAsk showInView:view];
	} else
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", [AppConfig sharedConfiguration].appClient.mainPhoneNumber]]];
}

- (void)callToClientPhoneNumber:(UIView *)view assistanceType:(DAAssistanceType)assistanceType {
	
	NSString *phoneNumber;
	switch (assistanceType) {
		case kDAAssistanceTypeProperty:
			phoneNumber = [AppConfig sharedConfiguration].appClient.propertyPhoneNumber;
			break;
		default:
			phoneNumber = [AppConfig sharedConfiguration].appClient.mainPhoneNumber;
			break;
	}
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phoneNumber]]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (buttonIndex) {
		case 0:
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", [AppConfig sharedConfiguration].appClient.mainPhoneNumber]]];
			break;
		case 1: 
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", [AppConfig sharedConfiguration].appClient.altPhoneNumber]]];
			break;
	}
}

+ (void)callToPhone:(DAPhone *)phone {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:021%d-%d", phone.areaCode, phone.phoneNumber]]];
}

@end
