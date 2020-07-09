//
//  LoginModel.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 27/09/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseModel.h"
#import "UserBeans.h"
#import "FBUserBeans.h"

@import GoogleSignIn;
@import AuthenticationServices;
@protocol LoginModelDelegate <NSObject>

@optional
-(void) loginSuccess:(UserBeans*)userBeans;
-(void) loginError:(NSString*)message;
-(void) loginFBNotRegistered:(FBUserBeans *) fbUserBeans;
-(void) linkFacebookUser:(FBUserBeans *) fbUserBeans;
-(void) showRequestPassword:(UIAlertController*)controller;
-(void) touchIdLoginClicked;
-(void) cancelTouchIdLogin;
-(void) activationReturn:(NSString*)message;

@end
@interface LoginModel : BaseModel <ConexaoDelegate, GIDSignInDelegate, ASAuthorizationControllerDelegate>



@property (nonatomic) id<LoginModelDelegate> delegate;
- (id)init;
-(void) doLogin:(NSString*) emailCpf password:(NSString*)password stayLogged:(BOOL) stayLogged;
-(void) doFacebookLogin:(UIViewController*)currentViewController;
-(void) doFacebookLink:(UIViewController*)currentViewController;
-(void) doLoginFacebook:(FBUserBeans*) fbUser;
-(BOOL) shouldAutoLogin;
-(void) sendNotificationToken:(UserBeans*)beans;
-(void) doGoogleLogin:(id<GIDSignInUIDelegate>)currentViewController;
-(void) doGoogleLink:(id<GIDSignInUIDelegate>)currentViewController;
-(void) sendActivation:(NSDictionary*)dict;
-(void)doAppleLogin:(id)currentViewController;
@end
