//
//  DAUtil.m
//  DirectAssistFord
//
//  Created by Ricardo Ramos on 10/22/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DAUtil.h"


@implementation DAUtil


void ShowErrorAlert(NSError *error, NSString *title, id <UIAlertViewDelegate> delegate) {
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title 
													message:[error localizedDescription] 
												   delegate:delegate 
										  cancelButtonTitle:nil 
										  otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
	[alert show];
}

@end
