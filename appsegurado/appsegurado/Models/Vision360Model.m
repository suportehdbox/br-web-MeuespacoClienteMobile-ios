//
//  Vision360Model.m
//  appsegurado
//
//  Created by RODRIGO MACEDO on 28/05/19.
//  Copyright © 2019 Liberty Seguros. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vision360Model.h"
#import "AppDelegate.h"

@interface Vision360Model(){
    AppDelegate *appDelegate;
}
@end


@implementation Vision360Model
@synthesize delegate;

-(void) checkEvent:(NSString*) policy{
    conn = [[Conexao alloc] initWithURL:[NSString stringWithFormat:@"%@Segurado/Seguro/Extrato",[super getBaseUrl:@"v1"]] contentType:@"application/x-www-form-urlencoded"];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [conn addHeaderValue:[NSString stringWithFormat:@"Bearer %@",[appDelegate getLoggeduser].access_token] field:@"Authorization"];
    //    [conn addGetParameters:[appDelegate getLoggeduser].cpfCnpj key:@"CpfCnpj"];
    [conn addGetParameters:[NSString stringWithFormat:@"%@",policy] key:@"Policy"];
    [conn addGetParameters:[NSString stringWithFormat:@"%d",true] key:@"onlyCheck"];
    
    [conn setDelegate:self];
    [conn setRetornoConexao:@selector(returnCheckEvent:)];
    [conn startRequest];
}



-(void)returnCheckEvent:(NSData *)responseData{
    NSLog(@"Response: %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    
    NSError *error;
    

        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseData
                                                               options:NSJSONReadingMutableContainers error:&error];
        if(!error){
            if([[result valueForKey:@"possuiEvento"] boolValue]){
                if(delegate && [delegate respondsToSelector:@selector(checkSuccess)]){
                    [delegate checkSuccess];
                }
            }
        }
}

//-(void)retornaErroConexaoEvent:(NSDictionary *)dictUserInfo response:(NSURLResponse *)response error:(NSError *)error{
//}

-(void) getListEvent:(NSString*) policy{
    
    NSLog(@"apolice : %@",[NSString stringWithFormat:@"%@Segurado/Seguro/Extrato",[super getBaseUrl:@"v1"]]);

    
    conn = [[Conexao alloc] initWithURL:[NSString stringWithFormat:@"%@Segurado/Seguro/Extrato",[super getBaseUrl:@"v1"]] contentType:@"application/x-www-form-urlencoded"];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [conn addHeaderValue:[NSString stringWithFormat:@"Bearer %@",[appDelegate getLoggeduser].access_token] field:@"Authorization"];
    //    [conn addGetParameters:[appDelegate getLoggeduser].cpfCnpj key:@"CpfCnpj"];
    [conn addGetParameters:[NSString stringWithFormat:@"%@",policy] key:@"Policy"];
    
    [conn setDelegate:self];
    [conn setRetornoConexao:@selector(returnEvent:)];
    [conn setRetornoErroConexao:@selector(retornaErroConexao:)];
    [conn startRequest];
}

-(void)returnEvent:(NSData *)responseData{
    NSLog(@"Response: %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    
    NSError *error;
    id result = [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingMutableContainers error:&error];
    
        if(!error){
            if([[result valueForKey:@"success"] boolValue]){
                
                    
                    Vision360Beans *vision = [[Vision360Beans alloc] initWithDictionary:result];
                    
                    if(delegate && [delegate respondsToSelector:@selector(visionResult:)]){
                        [delegate visionResult:vision];
                    }
                    
            }else if([result objectForKey:@"message"] != nil){
                if(delegate && [delegate respondsToSelector:@selector(visionError:)]){
                    [delegate visionError:[result objectForKey:@"message"]];
                }
            }
        }else{
            if(delegate && [delegate respondsToSelector:@selector(visionError:)]){
                [delegate visionError:NSLocalizedString(@"ConnectionError",@"") ];
            }
        }

}

-(void)retornaErroConexao:(NSDictionary *)dictUserInfo response:(NSURLResponse *)response error:(NSError *)error{
    
    NSLog(@"Retorno erro conexão %@, %@", response , error);
    if(delegate && [delegate respondsToSelector:@selector(visionError:)]){
        [delegate visionError:NSLocalizedString(@"ConnectionError",@"") ];
    }
}
@end

