//
//  Client.h
//  DirectAssist
//
//  Created by Ricardo Ramos on 19/04/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DAClientBase : NSObject {
	int			clientID;
	NSString	*clientName;
	UIColor		*defaultColor;
	NSString	*bannerHomepage;
	NSString	*mainPhoneNumber;
	NSString	*propertyPhoneNumber;
	NSString	*altPhoneNumber;
	
	BOOL			automotiveServiceEnabled;
	BOOL			automakerServiceEnabled;
	BOOL			propertyServiceEnabled;
	BOOL			qualitySurveyEnabled;
	BOOL	_dynamicFooter;
	
	BOOL	automotiveServiceAccreditedGaragesEnabled;
	BOOL	findPolicyDismissUserDocument;

	BOOL		multipleBranding;
	NSString	*brandingIdentifier;
	
	NSMutableArray	*services;
}

@property (nonatomic, assign)	int			clientID;
@property (nonatomic, copy)		NSString	*clientName;
@property (nonatomic, strong)	UIColor		*defaultColor;
@property (nonatomic, copy)		NSString	*bannerHomepage;
@property (nonatomic, copy)		NSString	*mainPhoneNumber;
@property (nonatomic, copy)		NSString	*propertyPhoneNumber;
@property (nonatomic, copy)		NSString	*altPhoneNumber;

@property (nonatomic, assign)	BOOL	dynamicFooter;

@property (nonatomic, assign)	BOOL			automotiveServiceEnabled;
@property (nonatomic, assign)	BOOL			automakerServiceEnabled;
@property (nonatomic, assign)	BOOL			propertyServiceEnabled;
@property (nonatomic, assign)	BOOL			qualitySurveyEnabled;
@property (nonatomic, assign)	BOOL			automotiveServiceAccreditedGaragesEnabled;
@property (nonatomic, assign)	BOOL			findPolicyDismissUserDocument;

@property (nonatomic, assign)	BOOL		multipleBranding;
@property (nonatomic, copy)		NSString	*brandingIdentifier;

@property (nonatomic, strong)	NSMutableArray	*services;


-(void) setup;

@end
