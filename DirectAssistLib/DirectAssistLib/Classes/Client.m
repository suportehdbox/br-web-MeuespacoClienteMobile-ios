//
//  CustomClient.m
//  DirectAssist
//
//  Created by Ricardo Ramos on 24/04/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import "Client.h"

@implementation Client
-(void) setup {
	[super setup];
	
	self.clientID = 2;
	self.clientName = @"Liberty";
	self.defaultColor = [UIColor colorWithRed:41.0/255.0 green:123.0/255.0 blue:198.0/255.0 alpha:1.0];
	self.bannerHomepage = @"http://www.libertyseguros.com.br/";
	self.mainPhoneNumber = @"0800-701-4120";
	self.propertyPhoneNumber = @"0800-702-5100";
	
	self.automotiveServiceEnabled = YES;
    self.automakerServiceEnabled = NO;
    self.automotiveServiceAccreditedGaragesEnabled = YES;
	self.propertyServiceEnabled = YES;
}
@end
