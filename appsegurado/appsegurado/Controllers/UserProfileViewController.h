//
//  UserProfileViewController.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 06/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseViewController.h"
#import "LoginModel.h"
#import "RegisterModel.h"

@import GoogleSignIn;

@interface UserProfileViewController : BaseViewController <UITableViewDelegate,UITableViewDataSource, LoginModelDelegate, RegisterModelDelegate, GIDSignInUIDelegate>

@end
