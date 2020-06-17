//
//  ForgotPasswordModel.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 03/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseModel.h"

@protocol ForgotPasswordDelegate <NSObject>

-(void) forgotSuccess;
-(void) forgotError:(NSString*)message;

@end
@interface ForgotPasswordModel : BaseModel <ConexaoDelegate>

@property (nonatomic) id<ForgotPasswordDelegate> delegate;

-(void) requestNewPassword:(NSString*) email cpf:(NSString*)cpf;


@end
