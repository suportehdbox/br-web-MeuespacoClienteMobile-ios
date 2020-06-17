//
//  ConectModel.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 13/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "ContactModel.h"
#import "AppDelegate.h"
#import "ContactBeans.h"
@implementation ContactModel
@synthesize delegate;

-(void) getAgentsContact{

    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if([appDelegate isUserLogged]){
    
        conn = [[Conexao alloc] initWithURL:[NSString stringWithFormat:@"%@Segurado/Seguro/Corretora",[super getBaseUrl:@"v2"]] contentType:@"application/x-www-form-urlencoded"];
    
        [conn addHeaderValue:[NSString stringWithFormat:@"Bearer %@",[appDelegate getLoggeduser].access_token] field:@"Authorization"];
        [conn setDelegate:self];
        [conn setRetornoConexao:@selector(returnAgents:)];
        [conn startRequest];
    }else{
    
        NSData *cachedData = [self getCachedData];
        if(cachedData != nil){
            [self returnAgents:cachedData];
        }else{
            if(delegate && [delegate respondsToSelector:@selector(contactEmpty)]){
                [delegate contactEmpty];
            }
        }
    
    }

}

-(void)returnAgents:(NSData *)responseData{
    NSLog(@"Response: %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);

    
    
    
    NSError *error;
    
  
    id result = [NSJSONSerialization JSONObjectWithData:responseData
                                                           options:NSJSONReadingMutableContainers error:&error];
    
    if(!error){
        if([result isKindOfClass:[NSDictionary class]]){
        
            if([result objectForKey:@"message"] != nil && ![[result objectForKey:@"message"] isEqualToString:@""]){
                if(delegate && [delegate respondsToSelector:@selector(contactError:)]){
                    [delegate contactError:[result objectForKey:@"message"]];
                }
            }else{
                NSMutableArray *arrayBeans = [[NSMutableArray alloc] init];
                NSArray *brokers = [result objectForKey:@"brokers"];
                [self cacheReturn:responseData];
                for (NSDictionary *dic in brokers) {
                    ContactBeans *beans = [[ContactBeans alloc] initWithDictionary:dic];
                    [arrayBeans addObject:beans];
                }
                
                if(delegate && [delegate respondsToSelector:@selector(contactsReturn:)]){
                    [delegate contactsReturn:arrayBeans];
                }
            }
            
        }
        
    }else{
        
        
      
            if(delegate && [delegate respondsToSelector:@selector(contactError:)]){
                [delegate contactError:NSLocalizedString(@"ConnectionError",@"") ];
            }
        
        
    }
}


-(void) cacheReturn:(NSData*)data{
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
    [defaults setObject:responseString forKey:@"AgentsCached"];
    [defaults synchronize];

}

-(NSData*) getCachedData{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
    NSString *str = [defaults objectForKey:@"AgentsCached"];
    if (str != nil && ![str isEqualToString:@""]) {
        NSData *returnData = [str dataUsingEncoding:NSUTF8StringEncoding];
        return returnData;
    }
    return nil;
    
}

-(void)retornaConexao:(NSURLResponse *)response responseString:(NSString *)responseString{
    
    NSLog(@"Retorno Conexao [%@] \n\n %@",response, responseString);
    
}

-(void)retornaErroConexao:(NSDictionary *)dictUserInfo response:(NSURLResponse *)response error:(NSError *)error{
    
    NSLog(@"Retorno erro conexão %@, %@", response , error);
    if(delegate && [delegate respondsToSelector:@selector(contactError:)]){
        [delegate contactError:NSLocalizedString(@"ConnectionError",@"") ];
    }
}
@end
