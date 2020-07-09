//
//  AppDelegate.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 22/08/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserBeans.h"


#import "SmiSdk.h"

@import Firebase;
@import UserNotifications;
@import GoogleSignIn;
//@import FirebaseAuth;


#import "BaseViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, FIRMessagingDelegate, UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) BOOL openingExternalProgram;
@property (nonatomic) BOOL gotoLoginView;
@property (nonatomic) BOOL shouldShowRMessage;
@property (nonatomic) BOOL loggedWithFacebook;
@property (nonatomic) BOOL loggedWithApple;
@property (nonatomic) BOOL has_auto_policy;
@property (nonatomic,strong) SmiResult* currentSr;
@property(nonatomic, readonly, strong) NSString *registrationKey;
@property(nonatomic, readonly, strong) NSString *messageKey;
@property(nonatomic, readonly, strong) NSString *gcmSenderID;
@property(nonatomic, strong) NSString *mainPolicyNumber;
@property(nonatomic, readonly, strong) NSDictionary *registrationOptions;

@property(nonatomic, readonly, strong) NSMutableArray *forgotQuestionsIds;

@property(nonatomic, strong) BaseViewController *current_controller;

-(NSString*)getGCM;

-(bool) isUserLogged;
-(void) setLoggedUser:(UserBeans*)user stayLogged:(BOOL)logged;
-(void) logoutUser;
-(void) setEmailUser:(NSString*)email;
-(NSString*) getEmailUser;
-(UserBeans*) getLoggeduser;
-(NSString*) getAuthToken;
-(NSString*) getCPF;
-(void) setUsesTouchID:(BOOL)use;
-(BOOL) usesTouchIDLogin;
@end

