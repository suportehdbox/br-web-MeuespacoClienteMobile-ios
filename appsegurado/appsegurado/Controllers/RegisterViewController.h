//
//  RegisterViewController.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 29/09/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseViewController.h"
#import "RegisterView.h"
#import "FBUserBeans.h"
#import "RegisterModel.h"

@interface RegisterViewController : BaseViewController<RegisterModelDelegate>


-(void) loadWithFbUserBeans:(FBUserBeans*) fbUser;
@end
