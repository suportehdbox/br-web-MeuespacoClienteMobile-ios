//
//  ChangeEmailModel.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 11/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "ChangeEmailModel.h"
#import "AppDelegate.h"
#import <CommonCrypto/CommonDigest.h>
@interface ChangeEmailModel(){

    AppDelegate *appDelegate;
}
@end
@implementation ChangeEmailModel
@synthesize delegate;


-(void) changeEmail:(NSString*) newEmail{
    
    if(appDelegate == nil){
        appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    }
    [self changeEmail:newEmail cpf:[appDelegate getCPF]];
    
    
}
-(void) changeEmail:(NSString*) newEmail cpf:(NSString*) cpf{
    
    conn = [[Conexao alloc] initWithURL:[NSString stringWithFormat:@"%@Acesso/Email",[super getBaseUrl]] contentType:@"application/x-www-form-urlencoded"];
    if(appDelegate == nil){
        appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    }
    [conn addHeaderValue:[NSString stringWithFormat:@"Bearer %@",[appDelegate getLoggeduser].access_token] field:@"Authorization"];
//    [conn addPostParameters:[self getToken] key:@"Token"];
    [conn addPostParameters:cpf key:@"CpfCnpj"];
    [conn addPostParameters:newEmail key:@"Email"];
    [conn addPostParameters:brandMarketing key:@"brandMarketing"];
    
    [conn setDelegate:self];
    [conn setRetornoConexao:@selector(returnPasswordChange:)];
    [conn startRequest];
    
    
}

-(void)returnPasswordChange:(NSData *)responseData{
    NSLog(@"Response: %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    
    NSError *error;
    
    if([responseData length] == 0){
        if(delegate && [delegate respondsToSelector:@selector(emailChangedSuccessfully)]){
            [delegate emailChangedSuccessfully];
        }
    }else{
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseData
                                                               options:NSJSONReadingMutableContainers error:&error];
        
        if(!error){
            if([result objectForKey:@"message"] != nil){
                if(delegate && [delegate respondsToSelector:@selector(emailError:)]){
                    [delegate emailError:[result objectForKey:@"message"]];
                }
            }
        }else{
            if(delegate && [delegate respondsToSelector:@selector(emailError:)]){
                [delegate emailError:NSLocalizedString(@"ConnectionError",@"") ];
            }
        }
    }
}



-(void)retornaConexao:(NSURLResponse *)response responseString:(NSString *)responseString{
    
    NSLog(@"Retorno Conexao [%@] \n\n %@",response, responseString);
    
}

-(void)retornaErroConexao:(NSDictionary *)dictUserInfo response:(NSURLResponse *)response error:(NSError *)error{
    
    NSLog(@"Retorno erro conexão %@, %@", response , error);
        if(delegate && [delegate respondsToSelector:@selector(emailError:)]){
            [delegate emailError:NSLocalizedString(@"ConnectionError",@"") ];
        }
}

-(NSString *) getToken{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyyMMddHHmm"];
    NSDate *date = [NSDate date];
//    DateTime.Now.ToString("yyyyMMddHHmm") + "LibertyMobileApp";
    return [self md5:[NSString stringWithFormat:@"%@LibertyMobileApp",[format stringFromDate:date]]];


}

- (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}
@end
