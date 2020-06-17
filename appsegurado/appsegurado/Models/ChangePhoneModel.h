//
//  ChangeEmailModel.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 11/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseModel.h"
@protocol ChangePhoneModelDelegate <NSObject>
-(void) loadedPhone:(NSString*) phone extension:(NSString*) extension cellphone:(NSString*) cellphone;
-(void) phoneChangedSuccessfully;
-(void) phoneError:(NSString*)message;
@end
@interface ChangePhoneModel : BaseModel <ConexaoDelegate>

@property (nonatomic) id<ChangePhoneModelDelegate> delegate;
-(void) getPhone;
-(void) changePhone:(NSString*) phone extension:(NSString*) extension cellphone:(NSString*) cellphone;
@end
