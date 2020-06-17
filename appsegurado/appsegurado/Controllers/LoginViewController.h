//
//  LoginViewController.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 26/09/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseViewController.h"
#import "LoginView.h"
#import "LoginModel.h"

@import GoogleSignIn;


@interface LoginViewController : BaseViewController <LoginModelDelegate, GIDSignInUIDelegate>

@end
