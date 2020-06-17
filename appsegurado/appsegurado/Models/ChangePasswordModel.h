//
//  ChangePasswordModel.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 10/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseModel.h"
@protocol PasswordModelDelegate <NSObject>
-(void) passwordChangedSuccessfully;
-(void) passwordError:(NSString*)message;
@end
@interface ChangePasswordModel : BaseModel <ConexaoDelegate>

@property (nonatomic) id<PasswordModelDelegate> delegate;

-(void) changePassowrdOldPwd:(NSString*) oldPwd newPwd:(NSString*) newPwd;
@end
