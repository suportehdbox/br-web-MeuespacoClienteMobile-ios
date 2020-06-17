//
//  ChangeEmailModel.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 11/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "ChangePhoneModel.h"
#import "AppDelegate.h"
#import <CommonCrypto/CommonDigest.h>
@interface ChangePhoneModel(){

    AppDelegate *appDelegate;
    long cifCode;
    long homePhoneCode;
    long celPhoneCode;
}
@end
@implementation ChangePhoneModel
@synthesize delegate;

-(void) getPhone{
    
    conn = [[Conexao alloc] initWithURL:[NSString stringWithFormat:@"%@Acesso/GetPhone",[super getBaseUrl]] contentType:@"application/x-www-form-urlencoded"];
    
    if(appDelegate == nil){
        appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    }
    [conn addHeaderValue:[NSString stringWithFormat:@"Bearer %@",[appDelegate getLoggeduser].access_token] field:@"Authorization"];
    [conn addPostParameters:@"1234" key:@"Token"];

    [conn setDelegate:self];
    [conn setRetornoConexao:@selector(returnPhone:)];
    [conn startRequest];
    
}
-(void) returnPhone:(NSData *)responseData{
    NSLog(@"Response: %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    
    NSError *error;
    
 
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
        
    if(!error){
        if([result objectForKey:@"sucesso"]){
            if(delegate && [delegate respondsToSelector:@selector(loadedPhone:extension:cellphone:)]){
                NSString * phone = @"";
                if(![[result valueForKey:@"dddHomePhone"] isEqualToString:@""] && [result valueForKey:@"homePhone"] ){
                    phone = [NSString stringWithFormat:@"(%@) %@-%@",[result valueForKey:@"dddHomePhone"], [[result valueForKey:@"homePhone"] substringToIndex:([[result valueForKey:@"homePhone"] length] / 2)] , [[result valueForKey:@"homePhone"] substringFromIndex:([[result valueForKey:@"homePhone"] length] / 2)]  ];
                }
                
                NSString * cellPhone = @"";
                if(![[result valueForKey:@"dddCelPhone"] isEqualToString:@""] && [result valueForKey:@"celPhone"] ){
                    if([[result valueForKey:@"celPhone"] length] >= 9){
                        cellPhone = [NSString stringWithFormat:@"(%@) %@ %@-%@",[result valueForKey:@"dddCelPhone"], [[result valueForKey:@"celPhone"] substringToIndex:1] ,[[result valueForKey:@"celPhone"] substringWithRange:NSMakeRange(1, 4)] , [[result valueForKey:@"celPhone"] substringWithRange:NSMakeRange(5, 4) ]];
                    }else{
                       cellPhone = [NSString stringWithFormat:@"(%@) %@-%@",[result valueForKey:@"dddCelPhone"], [[result valueForKey:@"celPhone"] substringToIndex:([[result valueForKey:@"celPhone"] length] / 2)] , [[result valueForKey:@"celPhone"] substringFromIndex:([[result valueForKey:@"celPhone"] length] / 2)]  ];
                    }
                 
                }
                NSString *branch = [result valueForKey:@"branchHomePhone"] ;
                if([[result valueForKey:@"branchHomePhone"] isEqualToString:@"9999"]){
                    branch = @"";
                }
                
                cifCode = [[result valueForKey:@"cifCode"] longValue];
                homePhoneCode = [[result valueForKey:@"homePhoneCode"] longValue];
                celPhoneCode = [[result valueForKey:@"celPhoneCode"] longValue];
                
                
                
                [delegate loadedPhone:phone extension:branch  cellphone:cellPhone ];
                return;
            }
        }
    }
    
    
    if(delegate && [delegate respondsToSelector:@selector(phoneError:)]){
        [delegate phoneError:NSLocalizedString(@"ConnectionError",@"") ];
    }
    
}

-(void) changePhone:(NSString*) phone extension:(NSString*) extension cellphone:(NSString*) cellphone{
    
    conn = [[Conexao alloc] initWithURL:[NSString stringWithFormat:@"%@Acesso/Phone",[super getBaseUrl]] contentType:@"application/x-www-form-urlencoded"];
    if(appDelegate == nil){
        appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    }
    [conn addHeaderValue:[NSString stringWithFormat:@"Bearer %@",[appDelegate getLoggeduser].access_token] field:@"Authorization"];
//    [conn addPostParameters:[self getToken] key:@"Token"];
  
    NSString *dddPhoneNumbers = [phone substringToIndex:2];
    NSString *phoneNumbers = [phone substringFromIndex:2];
    NSString *dddCellPhoneNumbers = [cellphone substringToIndex:2];
    NSString *CellphoneNumbers = [cellphone substringFromIndex:2];
    
    if([extension isEqualToString:@""]){
        extension = @"9999";
    }
    
    [conn addPostParameters:dddPhoneNumbers key:@"DDDFoneResidencial"];
    [conn addPostParameters:phoneNumbers key:@"FoneResidencial"];
    [conn addPostParameters:extension key:@"RamalFoneResidencial"];
    [conn addPostParameters:dddCellPhoneNumbers key:@"DDDFoneCelular"];
    [conn addPostParameters:CellphoneNumbers key:@"FoneCelular"];
    [conn addPostParameters:[NSString stringWithFormat:@"%ld", cifCode] key:@"codigoCif"];
    [conn addPostParameters:[NSString stringWithFormat:@"%ld", homePhoneCode] key:@"CodigoFoneResidencial"];
    [conn addPostParameters:[NSString stringWithFormat:@"%ld", celPhoneCode] key:@"CodigoFoneCelular"];
    
    [conn setDelegate:self];
    [conn setRetornoConexao:@selector(returnPhoneUpdate:)];
    [conn startRequest];
    
    
}

-(void)returnPhoneUpdate:(NSData *)responseData{
    NSLog(@"Response: %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    
    NSError *error;
    
    if([responseData length] == 0){
        if(delegate && [delegate respondsToSelector:@selector(phoneChangedSuccessfully)]){
            [delegate phoneChangedSuccessfully];
        }
    }else{
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseData
                                                               options:NSJSONReadingMutableContainers error:&error];
        
        if(!error){
            if([result objectForKey:@"message"] != nil){
                if(delegate && [delegate respondsToSelector:@selector(phoneError:)]){
                    [delegate phoneError:[result objectForKey:@"message"]];
                }
            }
        }else{
            if(delegate && [delegate respondsToSelector:@selector(phoneError:)]){
                [delegate phoneError:NSLocalizedString(@"ConnectionError",@"") ];
            }
        }
    }
}



-(void)retornaConexao:(NSURLResponse *)response responseString:(NSString *)responseString{
    
    NSLog(@"Retorno Conexao [%@] \n\n %@",response, responseString);
    
}

-(void)retornaErroConexao:(NSDictionary *)dictUserInfo response:(NSURLResponse *)response error:(NSError *)error{
    
    NSLog(@"Retorno erro conexão %@, %@", response , error);
        if(delegate && [delegate respondsToSelector:@selector(phoneError:)]){
            [delegate phoneError:NSLocalizedString(@"ConnectionError",@"") ];
        }
}

@end
