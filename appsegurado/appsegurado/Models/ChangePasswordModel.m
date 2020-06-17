//
//  ChangePasswordModel.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 10/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "ChangePasswordModel.h"
#import "AppDelegate.h"

@implementation ChangePasswordModel
@synthesize delegate;


-(void) changePassowrdOldPwd:(NSString*) oldPwd newPwd:(NSString*) newPwd{
    
    conn = [[Conexao alloc] initWithURL:[NSString stringWithFormat:@"%@Acesso/Senha",[super getBaseUrl]] contentType:@"application/x-www-form-urlencoded"];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
    [conn addHeaderValue:[NSString stringWithFormat:@"Bearer %@",[appDelegate getLoggeduser].access_token] field:@"Authorization"];
    [conn addPostParameters:[appDelegate getCPF] key:@"CpfCnpj"];
    [conn addPostParameters:newPwd key:@"pwd"];
    [conn addPostParameters:oldPwd key:@"OldPwd"];
    [conn addPostParameters:brandMarketing key:@"brandMarketing"];
    
    [conn setDelegate:self];
    [conn setRetornoConexao:@selector(returnPasswordChange:)];
    [conn startRequest];
    
    
}

-(void)returnPasswordChange:(NSData *)responseData{
    NSLog(@"Response: %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    
    NSError *error;
    
    if([responseData length] == 0){
        if(delegate && [delegate respondsToSelector:@selector(passwordChangedSuccessfully)]){
            [delegate passwordChangedSuccessfully];
        }
    }else{
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseData
                                                           options:NSJSONReadingMutableContainers error:&error];
    
        if(!error){
            if([result objectForKey:@"message"] != nil){
                if(delegate && [delegate respondsToSelector:@selector(passwordError:)]){
                    [delegate passwordError:[result objectForKey:@"message"]];
                }
            }
        }else{
            if(delegate && [delegate respondsToSelector:@selector(passwordError:)]){
                [delegate passwordError:NSLocalizedString(@"ConnectionError",@"") ];
            }
        }
    }
}



-(void)retornaConexao:(NSURLResponse *)response responseString:(NSString *)responseString{
    
    NSLog(@"Retorno Conexao [%@] \n\n %@",response, responseString);
    
}

-(void)retornaErroConexao:(NSDictionary *)dictUserInfo response:(NSURLResponse *)response error:(NSError *)error{
    
    NSLog(@"Retorno erro conexão %@, %@", response , error);
        if(delegate && [delegate respondsToSelector:@selector(passwordError:)]){
            [delegate passwordError:NSLocalizedString(@"ConnectionError",@"") ];
        }
}
@end
