//
//  ForgotEmailModel.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 10/11/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseModel.h"
#import "ForgotEmailBeans.h"

@protocol ForgotEmailModelDelegate <NSObject>
-(void) returntQuestions:(ForgotEmailBeans*)forgotBeans;
-(void) returnAnswerSucessfully;
-(void) questionsError:(NSString*)message;
-(void) answersError:(NSString*)message;
@end
@interface ForgotEmailModel : BaseModel <ConexaoDelegate>

@property (nonatomic) id<ForgotEmailModelDelegate> delegate;

-(void) getQuestions:(NSString*) cpf lastQuestions:(NSArray*) array;
-(void)sendAnswersCPF:(NSString*) cpf newEmail:(NSString*)newEmail questions:(NSArray*) arrayQuestions;
@end
