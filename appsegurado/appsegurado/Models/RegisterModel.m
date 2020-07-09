	//
//  RegisterModel.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 04/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "RegisterModel.h"
@interface RegisterModel(){
    LoginModel *loginModel;
    RegisterBeans* registeredUser;
}

@end
@implementation RegisterModel
@synthesize delegate;

-(void) verifyPolice:(RegisterBeans*) beans{
    registeredUser = beans;
    conn = [[Conexao alloc] initWithURL:[NSString stringWithFormat:@"%@Acesso/Verificar",[super getBaseUrl]] contentType:@"application/x-www-form-urlencoded"];
    
    
    switch (beans.typePolice) {
        case 0:{//AUTO
            if([beans.policy rangeOfString:@"-"].location == NSNotFound){
                //policy
                [conn addPostParameters:beans.policy key:@"NumeroApolice"];
            }else{
                [conn addPostParameters:[beans.policy stringByReplacingOccurrencesOfString:@"-" withString:@""] key:@"Placa"];
            }
        }
            break;
        case 1://HOME
            if([beans.policy rangeOfString:@"-"].location == NSNotFound){
                //policy
                [conn addPostParameters:beans.policy key:@"NumeroApolice"];
            }else{
                [conn addPostParameters:[beans.policy stringByReplacingOccurrencesOfString:@"-" withString:@""] key:@"CEP"];
            }
            break;
        case 2://LIFE
            if([beans.policy rangeOfString:@"/"].location == NSNotFound){
                //policy
                [conn addPostParameters:beans.policy key:@"NumeroApolice"];
            }else{
                [conn addPostParameters:beans.policy key:@"DataNascimento"];
            }
            break;
        default:
            break;
    }
    
    
    [conn addPostParameters:beans.cpf key:@"CpfCnpj"];
    [conn addPostParameters:brandMarketing key:@"MarcaComercializacao"];
    [conn setDelegate:self];
    [conn setRetornoConexao:@selector(returnVerify:)];
    [conn startRequest];
}
-(void)returnVerify:(NSData *)responseData{
//    [delegate verifyDuplicated:@"CPF ja cadastrado" couldChangeInput:NO];
//    return;
    /*
     {"message":null,"rowsAffected":0,"sucesso":true,"numeroApolice":"3116537524","nomeSegurado":"TESTE TANIA CT 03","codigoCIF":3197471}
     */
    NSLog(@"Response: %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    

    NSError *error;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseData
                                                           options:NSJSONReadingMutableContainers error:&error];
    
    if(!error){
        if([result objectForKey:@"sucesso"]){
            registeredUser.name = [result valueForKey:@"nomeSegurado"];
            registeredUser.policy = [result valueForKey:@"numeroApolice"];
            registeredUser.CIFCode = [NSString stringWithFormat:@"%d",[[result valueForKey:@"codigoCIF"] intValue]];
            
            
            [self doRegister:registeredUser];
            return;
        }else{

            if([result objectForKey:@"message"] != nil){

                if(delegate && [delegate respondsToSelector:@selector(registerError:)]){
                    [delegate registerError:[result objectForKey:@"message"]];
                }

                return;
            
            }
        }
    }
        
    if(delegate && [delegate respondsToSelector:@selector(registerError:)]){
        [delegate registerError:NSLocalizedString(@"ConnectionError",@"")];
    }
    

    
}


-(void) doRegister:(RegisterBeans*) beans{
    registeredUser = beans;
    
    conn = [[Conexao alloc] initWithURL:[NSString stringWithFormat:@"%@Acesso/Segurado",[super getBaseUrl:@"v2"]] contentType:@"application/x-www-form-urlencoded"];
    
    [conn addPostParameters:beans.policy key:@"Policy"];
    
    [conn addPostParameters:beans.cpf key:@"CpfCnpj"];
    [conn addPostParameters:beans.email key:@"Email"];
    [conn addPostParameters:beans.name key:@"InsuredsName"];
    
    if(beans.facebookInfo != nil){
        [conn addPostParameters:[beans.facebookInfo getFormattedUserID] key:@"IdMidiaSocial"];
        //
        if(beans.facebookInfo.type == Facebook){
            [conn addPostParameters:[NSString stringWithFormat:@"https=//graph.facebook.com/%@/picture",beans.facebookInfo.idUser] key:@"Photo"];
            [conn addPostParameters:@"2" key:@"OrigemCadastro"];
        }else if(beans.facebookInfo.type == Apple){
            [conn addPostParameters:@"" key:@"Photo"];
            [conn addPostParameters:@"5" key:@"OrigemCadastro"];
        }else{
            [conn addPostParameters:beans.facebookInfo.picture key:@"Photo"];
            [conn addPostParameters:@"1" key:@"OrigemCadastro"];
        }
    }else{
        [conn addPostParameters:@"0" key:@"OrigemCadastro"];
    }
    if([beans.password isEqualToString:@""]){
        beans.password = [self generatePassword];
    }
    [conn addPostParameters:beans.password key:@"Pwd"];
    [conn addPostParameters:brandMarketing key:@"brandMarketing"];
    [conn addPostParameters:beans.CIFCode key:@"CIFCode"];
    
    [conn setDelegate:self];
    [conn setRetornoConexao:@selector(returnRegister:)];
    [conn startRequest];
}

-(NSString*) generatePassword{
    
    static NSUInteger length = 5;
    static NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!@$*()+-";
    static NSString *numbers = @"0123456789";
    NSMutableString * randomString = [NSMutableString stringWithCapacity:length];
    for (NSInteger i = 0; i < length; ++i) {
        [randomString appendFormat: @"%C", [letters characterAtIndex:(NSUInteger)arc4random_uniform((u_int32_t)[letters length])]];
    }
    [randomString appendFormat: @"%C", [numbers characterAtIndex:(NSUInteger)arc4random_uniform((u_int32_t)[numbers length])]];
    
    NSLog(@"random string %@", randomString);
    return randomString;
}

-(void)returnRegister:(NSData *)responseData{
    NSLog(@"Response: %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    
    if([responseData length] == 0){
        if(delegate && [delegate respondsToSelector:@selector(registeredFacebook)]){
            [delegate registeredFacebook];
        }else{
//            [self doLogin];
            if(delegate && [delegate respondsToSelector:@selector(registeredSucessfully)]){
                [delegate registeredSucessfully];
            }
        }
    }else{
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseData
                                                               options:NSJSONReadingMutableContainers error:&error];
        
        if(!error){
            if([[result valueForKey:@"sucesso"] boolValue]){
                if(delegate && [delegate respondsToSelector:@selector(registeredFacebook)]){
                    [delegate registeredFacebook];
                }else{
                    if(delegate && [delegate respondsToSelector:@selector(registeredSucessfully)]){
                        [delegate registeredSucessfully];
                    }
                }
            }else{

                @try {
                    if([[result valueForKey:@"messageCode"] isEqualToString:@"ADD_USER_DUPLICATED_EMAIL"]){
                        
                        if(delegate && [delegate respondsToSelector:@selector(verifyDuplicated:couldChangeInput:)]){
                            [delegate verifyDuplicated:[result objectForKey:@"message"]  couldChangeInput:YES];
                        }
                        
                        return;
                    }else if([[result valueForKey:@"messageCode"] isEqualToString:@"ADD_USER_INACTIVE"]){
                        
                        if(delegate && [delegate respondsToSelector:@selector(userInactiveError:beans:)]){
                            [delegate userInactiveError:[result objectForKey:@"message"] beans:registeredUser];
                        }
                        return;
                    }else if([[result valueForKey:@"messageCode"] isEqualToString:@"ADD_USER_DUPLICATED"] ||
                             [[result valueForKey:@"messageCode"] isEqualToString:@"ADD_USER_DUPLICATED_CPFCNPJ"]){
                        if(delegate && [delegate respondsToSelector:@selector(verifyDuplicated:couldChangeInput:)]){
                            [delegate verifyDuplicated:[result objectForKey:@"message"]  couldChangeInput:NO];
                        }
                        return;
                    }else {
                        if(delegate && [delegate respondsToSelector:@selector(registerError:)]){
                            [delegate registerError:[result objectForKey:@"message"]];
                        }   
                        return;
                    }
                }@catch (NSException * e) {
                    if(delegate && [delegate respondsToSelector:@selector(registerError:)]){
                        [delegate registerError:[e description]];
                    }
                }
                
                
              
            }
            
        }else{
            if(delegate && [delegate respondsToSelector:@selector(registerError:)]){
                [delegate registerError:NSLocalizedString(@"ConnectionError",@"")];
            }
        }
    }

}

-(void) sendActiveEmail:(RegisterBeans*) beans{
    registeredUser = beans;
    
    conn = [[Conexao alloc] initWithURL:[NSString stringWithFormat:@"%@Acesso/ReenviarEmail",[super getBaseUrl]] contentType:@"application/x-www-form-urlencoded"];

    [conn addPostParameters:beans.cpf key:@"CpfCnpj"];

    [conn addPostParameters:brandMarketing key:@"MarcaComercializacao"];
    [conn setDelegate:self];
    [conn setRetornoConexao:@selector(returnMail:)];
    [conn startRequest];
}

-(void)returnMail:(NSData *)responseData{
    NSLog(@"Response: %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    
    if([responseData length] == 0){
        if(delegate && [delegate respondsToSelector:@selector(registeredFacebook)]){
            [delegate registeredFacebook];
        }else{
            if(delegate && [delegate respondsToSelector:@selector(emailSent)]){
                [delegate emailSent];
            }
            return;
        }
    }else{
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseData
                                                               options:NSJSONReadingMutableContainers error:&error];
        
        if(!error){
            if([[result valueForKey:@"sucesso"] boolValue]){
                if(delegate && [delegate respondsToSelector:@selector(emailSent)]){
                    [delegate emailSent];
                }
                return;
            }else{
                if(delegate && [delegate respondsToSelector:@selector(registerError:)]){
                    [delegate registerError:[result valueForKey:@"message"] ];
                }
                return;
                
            }
        }
        if(delegate && [delegate respondsToSelector:@selector(registerError:)]){
            [delegate registerError:NSLocalizedString(@"ConnectionError",@"")];
        }
        
    }
    
}

-(void)retornaConexao:(NSURLResponse *)response responseString:(NSString *)responseString{
    NSLog(@"Retorno Conexao [%@] \n\n %@",response, responseString);
    
}

-(void)retornaErroConexao:(NSDictionary *)dictUserInfo response:(NSURLResponse *)response error:(NSError *)error{
    
    NSLog(@"Retorno erro conexão %@, %@", response , error);
    if(delegate && [delegate respondsToSelector:@selector(registerError:)]){
        [delegate registerError:NSLocalizedString(@"ConnectionError",@"") ];
    }
}



-(void)doLogin{
    loginModel = [[LoginModel alloc] init];
    [loginModel setDelegate:self];
     if(registeredUser.facebookInfo == nil){
         [loginModel doLogin:registeredUser.email password:registeredUser.password stayLogged:YES];
     }else{
         [loginModel doLoginFacebook:registeredUser.facebookInfo];
     }

}
-(void)loginSuccess:(UserBeans *)userBeans{
    if (userBeans != nil) {
        if(delegate && [delegate respondsToSelector:@selector(registeredSucessfully)]){
            [delegate registeredSucessfully];
        }
    }else{
        if(delegate && [delegate respondsToSelector:@selector(registeredWithLoginError:)]){
            [delegate registeredWithLoginError:NSLocalizedString(@"ConnectionError",@"") ];
        }
    }
    
}

-(void)loginError:(NSString *)message{
    if(delegate && [delegate respondsToSelector:@selector(registeredWithLoginError:)]){
        [delegate registeredWithLoginError:message];
    }
}

@end
