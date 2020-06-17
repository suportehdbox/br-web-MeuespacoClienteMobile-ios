//
//  ForgotPasswordModel.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 03/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "ForgotPasswordModel.h"

@implementation ForgotPasswordModel
@synthesize delegate;

-(void) requestNewPassword:(NSString*) email cpf:(NSString*)cpf{
    conn = [[Conexao alloc] initWithURL:[NSString stringWithFormat:@"%@Acesso/NovaSenha",[super getBaseUrl]] contentType:@"application/x-www-form-urlencoded"];
    [conn addPostParameters:email key:@"Email"];
    [conn addPostParameters:cpf key:@"CpfCnpj"];
    [conn addPostParameters:brandMarketing key:@"brandMarketing"];
    [conn setDelegate:self];
    [conn setRetornoConexao:@selector(returnPassword:)];
    [conn startRequest];

}

-(void)returnPassword:(NSData *)responseData{
    NSLog(@"Response: %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    
    if([responseData length] == 0){
        if(delegate && [delegate respondsToSelector:@selector(forgotSuccess)]){
            [delegate forgotSuccess];
        }
    }else{
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseData
                                                               options:NSJSONReadingMutableContainers error:&error];
        
       if(!error){
            if([result objectForKey:@"message"] != nil){
                
                if(delegate && [delegate respondsToSelector:@selector(forgotError:)]){
                    [delegate forgotError:[result objectForKey:@"message"]];
                }
                
                return;
            }else{
                if(delegate && [delegate respondsToSelector:@selector(forgotSuccess)]){
                    [delegate forgotSuccess];
                }
            }
        }
    }
//
}

-(void)retornaConexao:(NSURLResponse *)response responseString:(NSString *)responseString{
    
    NSLog(@"Retorno Conexao [%@] \n\n %@",response, responseString);
    
}

-(void)retornaErroConexao:(NSDictionary *)dictUserInfo response:(NSURLResponse *)response error:(NSError *)error{
    
    NSLog(@"Retorno erro conexão %@, %@", response , error);
    if(delegate && [delegate respondsToSelector:@selector(forgotError:)]){
        [delegate forgotError:NSLocalizedString(@"ConnectionError",@"") ];
    }
}
@end
