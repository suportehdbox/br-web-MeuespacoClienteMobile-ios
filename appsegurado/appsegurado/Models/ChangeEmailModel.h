//
//  ChangeEmailModel.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 11/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseModel.h"
@protocol ChangeEmailModelDelegate <NSObject>
-(void) emailChangedSuccessfully;
-(void) emailError:(NSString*)message;
@end
@interface ChangeEmailModel : BaseModel <ConexaoDelegate>

@property (nonatomic) id<ChangeEmailModelDelegate> delegate;

-(void) changeEmail:(NSString*) newEmail;
-(void) changeEmail:(NSString*) newEmail cpf:(NSString*) cpf;
@end
