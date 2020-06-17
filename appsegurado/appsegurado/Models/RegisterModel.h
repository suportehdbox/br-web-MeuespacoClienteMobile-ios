//
//  RegisterModel.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 04/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseModel.h"
#import "RegisterBeans.h"
#import "LoginModel.h"

@protocol RegisterModelDelegate <NSObject>

-(void)registeredSucessfully;
-(void)registeredFacebook;
-(void)registeredWithLoginError:(NSString*)message;
-(void)registerError:(NSString*)message;
-(void)userInactiveError:(NSString *)message beans:(RegisterBeans*)beans;
-(void)verifyDuplicated:(NSString*)message couldChangeInput:(bool)couldChange;
-(void)emailSent;
@end


@interface RegisterModel : BaseModel <ConexaoDelegate, LoginModelDelegate>

@property (nonatomic) id<RegisterModelDelegate> delegate;
-(void) doRegister:(RegisterBeans*) beans;
-(void) verifyPolice:(RegisterBeans*) beans;
-(void) sendActiveEmail:(RegisterBeans*) beans;
@end
