//
//  PolicyModel.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 13/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "PolicyModel.h"
#import "AppDelegate.h"
#import "InsuranceBeans.h"
@interface PolicyModel () {
    NSString *downloadPdfNumber;
}

@end


@implementation PolicyModel
@synthesize delegate,onlyReturnAutoPolices;

-(void) getUserPolices:(BOOL)active{
    conn = [[Conexao alloc] initWithURL:[NSString stringWithFormat:@"%@Segurado/Seguro",[super getBaseUrl:@"v2"]] contentType:@"application/x-www-form-urlencoded"];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
    [conn addHeaderValue:[NSString stringWithFormat:@"Bearer %@",[appDelegate getLoggeduser].access_token] field:@"Authorization"];
//    [conn addGetParameters:[appDelegate getLoggeduser].cpfCnpj key:@"CpfCnpj"];
    if(active){
        [conn addGetParameters:@"true" key:@"isActive"];
    }else{
        [conn addGetParameters:@"false" key:@"isActive"];
    }
    
//    [conn addGetParameters:@"57947848904" key:@"CpfCnpj"];
    [conn setDelegate:self];
    [conn setRetornoConexao:@selector(returnPolices:)];
    [conn startRequest];
    
    
}
-(void) getDetailPolice:(NSString*)police{
    conn = [[Conexao alloc] initWithURL:[NSString stringWithFormat:@"%@Segurado/Seguro/Detalhe",[super getBaseUrl:@"v2"]] contentType:@"application/x-www-form-urlencoded"];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
    [conn addHeaderValue:[NSString stringWithFormat:@"Bearer %@",[appDelegate getLoggeduser].access_token] field:@"Authorization"];
    //    [conn addGetParameters:[appDelegate getLoggeduser].cpfCnpj key:@"CpfCnpj"];
//    [conn addGetParameters:@"57947848904" key:@"CpfCnpj"];
    [conn addGetParameters:police key:@"Policy"];
    [conn setDelegate:self];
    [conn setRetornoConexao:@selector(returnDetailPolice:)];
    [conn startRequest];
    
    
}

-(void)returnPolices:(NSData *)responseData{
    NSLog(@"Response: %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    

    NSError *error;
    
    
    id result = [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingMutableContainers error:&error];
    
    if(!error){
        if([result isKindOfClass:[NSDictionary class]]){
            
            if([result objectForKey:@"message"] != nil && ![[result objectForKey:@"message"] isEqualToString:@""]){
                if(delegate && [delegate respondsToSelector:@selector(policyError:)]){
                    [delegate policyError:[result objectForKey:@"message"]];
                }
            }else{
                @try {
                    NSMutableArray *arrayBeans = [[NSMutableArray alloc] init];
                    NSArray *insurances = [result objectForKey:@"insurances"];
                    for (NSDictionary *dic in insurances) {
                        InsuranceBeans *beans = [[InsuranceBeans alloc] initWithDictionaryV2:dic];
                        
                        if(onlyReturnAutoPolices){
                            if([beans isAutoPolicy]){
                                [arrayBeans addObject:beans];
                            }
                        }else{
                            [arrayBeans addObject:beans];
                        }
                        
                    }
                    
                    if(delegate && [delegate respondsToSelector:@selector(policyResult:)]){
                        [delegate policyResult:arrayBeans];
                    }

                } @catch (NSException *exception) {
                    NSLog(@"Exception %@", exception.description);
                    if(delegate && [delegate respondsToSelector:@selector(policyError:)]){
                        [delegate policyError:NSLocalizedString(@"ErroNoSerivdor",@"")];
                    }
                }
            }
            
        }
        
    }else{
        
        
        
        if(delegate && [delegate respondsToSelector:@selector(policyError:)]){
            [delegate policyError:NSLocalizedString(@"ConnectionError",@"") ];
        }
        
        
    }
}
-(void)returnDetailPolice:(NSData *)responseData{
    NSLog(@"Response Detail: %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    
    
    NSError *error;
    
    
    id result = [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingMutableContainers error:&error];
    
    if(!error){
        if([result isKindOfClass:[NSDictionary class]]){
            
            if([result objectForKey:@"message"] != nil && ![[result objectForKey:@"message"] isEqualToString:@""]){
                if(delegate && [delegate respondsToSelector:@selector(policyError:)]){
                    [delegate policyError:[result objectForKey:@"message"]];
                }
            }else{
                NSMutableArray *arrayBeans = [[NSMutableArray alloc] init];
                PolicyBeans *beans = [[PolicyBeans alloc] initWithDictionary:result];
                
                
                [arrayBeans addObject:beans];
                if(delegate && [delegate respondsToSelector:@selector(policyResultDetail:)]){
                    [delegate policyResultDetail:arrayBeans];
                }
            }
            
        }
        
    }else{
        
        
        
        if(delegate && [delegate respondsToSelector:@selector(policyError:)]){
            [delegate policyError:NSLocalizedString(@"ConnectionError",@"") ];
        }
        
        
    }
}



-(void) getParcels:(long)contract issuance:(int)issuance ciaCode:(int) ciaCode{

    conn = [[Conexao alloc] initWithURL:[NSString stringWithFormat:@"%@Segurado/Seguro/Pagamento",[super getBaseUrl:@"v2"]] contentType:@"application/x-www-form-urlencoded"];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [conn addHeaderValue:[NSString stringWithFormat:@"Bearer %@",[appDelegate getLoggeduser].access_token] field:@"Authorization"];

    [conn addGetParameters:[NSString stringWithFormat:@"%d",issuance] key:@"Issuances[]"];
    [conn addGetParameters:[NSString stringWithFormat:@"%ld",contract] key:@"Contract"];
    [conn addGetParameters:[NSString stringWithFormat:@"%d",ciaCode] key:@"CiaCode"];
//    
    [conn setDelegate:self];
    [conn setRetornoConexao:@selector(returnParcels:)];
    [conn startRequest];



}
-(void)returnParcels:(NSData *)responseData{
    NSLog(@"Response Detail: %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    
    
    NSError *error;
    
    
    id result = [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingMutableContainers error:&error];
    
    if(!error){
        if([result isKindOfClass:[NSDictionary class]]){
            
            if([result objectForKey:@"message"] != nil && ![[result objectForKey:@"message"] isEqualToString:@""]){
                if(delegate && [delegate respondsToSelector:@selector(policyError:)]){
                    [delegate policyError:[result objectForKey:@"message"]];
                }
            }else{
                @try {
                    NSMutableArray *arrayBeans = [[NSMutableArray alloc] init];
                    NSArray *insurances = [result objectForKey:@"issuances"];
                    for (NSDictionary *dic in insurances) {
                        for (NSDictionary *dicInstallment in [dic objectForKey:@"installments"]) {
                            PaymentBeans *beans = [[PaymentBeans alloc] initWithDictionary:dicInstallment];
                            [arrayBeans addObject:beans];
                        }
                    }
                    
                    if(delegate && [delegate respondsToSelector:@selector(policyPaymentResult:)]){
                        [delegate policyPaymentResult:arrayBeans];
                    }
                    
                } @catch (NSException *exception) {
                    NSLog(@"Exception %@", exception.description);
                    if(delegate && [delegate respondsToSelector:@selector(policyError:)]){
                        [delegate policyError:NSLocalizedString(@"ErroNoSerivdor",@"")];
                    }
                }
            }
            
        }
        
    }else{
        
        
        
        if(delegate && [delegate respondsToSelector:@selector(policyError:)]){
            [delegate policyError:NSLocalizedString(@"ConnectionError",@"") ];
        }
        
        
    }
}


-(void) getSecondPolicyPDF:(NSString*)policyNumber type:(int)type{
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    
    downloadPdfNumber = [policyNumber stringByAppendingString:[NSString stringWithFormat:@"_%@",[dateFormatter stringFromDate:[NSDate date]]]];
    NSString *filePathLocal = [self getExistsFile:[NSString stringWithFormat:@"%@.pdf", downloadPdfNumber]];
    if(filePathLocal != nil){
        if(delegate && [delegate respondsToSelector:@selector(pdfDownloaded:)]){
            [delegate pdfDownloaded:filePathLocal];
            return;
        }
    }
    
    
    conn = [[Conexao alloc] initWithURL:[NSString stringWithFormat:@"%@ApoliceSegundaVia/GetPDFPolicy",[super getBaseUrl:@"v1"]] contentType:@"application/x-www-form-urlencoded"];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [conn addHeaderValue:[NSString stringWithFormat:@"Bearer %@",[appDelegate getLoggeduser].access_token] field:@"Authorization"];
    
    [conn addGetParameters:[NSString stringWithFormat:@"%d",type] key:@"TipoConsulta"];
    [conn addGetParameters:policyNumber key:@"NumeroApolice"];
    //
    [conn setDelegate:self];
    [conn setRetornoConexao:@selector(returnSecondPDF:)];
    [conn startRequest];
    
    
    
}
-(void)returnSecondPDF:(NSData *)responseData{
    NSLog(@"Response PDF: %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    
    
    NSError *error;
    
    
    id result = [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingMutableContainers error:&error];
    
    if(!error){
        if([result isKindOfClass:[NSDictionary class]]){
            
            if([result objectForKey:@"message"] != nil && [result objectForKey:@"message"] !=  [NSNull null] && ![[result objectForKey:@"message"] isEqualToString:@""]){
                if(delegate && [delegate respondsToSelector:@selector(pdfError:)]){
                    [delegate pdfError:[result objectForKey:@"message"]];
                }
            }else{
                NSData *dataFile = [[NSData alloc] initWithBase64EncodedString:[result objectForKey:@"pdf"] options:0];
                NSString *path = [self savePDF:dataFile name:[NSString stringWithFormat:@"%@.pdf",downloadPdfNumber]];
                if(path != nil){
                    if(delegate && [delegate respondsToSelector:@selector(pdfDownloaded:)]){
                        [delegate pdfDownloaded:path];
                    }
                }
            }
            
        }
        
    }else{
        
        
        
        if(delegate && [delegate respondsToSelector:@selector(policyError:)]){
            [delegate policyError:NSLocalizedString(@"ConnectionError",@"") ];
        }
        
        
    }
}

-(void)retornaConexao:(NSURLResponse *)response responseString:(NSString *)responseString{
    
    NSLog(@"Retorno Conexao [%@] \n\n %@",response, responseString);
    
}

-(void)retornaErroConexao:(NSDictionary *)dictUserInfo response:(NSURLResponse *)response error:(NSError *)error{
    
    NSLog(@"Retorno erro conexão %@, %@", response , error);
        if(delegate && [delegate respondsToSelector:@selector(policyError:)]){
            [delegate policyError:NSLocalizedString(@"ConnectionError",@"") ];
        }
}
@end
