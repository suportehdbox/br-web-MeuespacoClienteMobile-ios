//
//  HomeModel.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 05/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "HomeModel.h"
#import "AppDelegate.h"
#import <LocalAuthentication/LocalAuthentication.h>

@implementation HomeModel

@synthesize delegate;
-(void) getHomeInfo{


}

-(void) getHome{
    AppDelegate *appDelegate =  (AppDelegate*)[[UIApplication sharedApplication] delegate];
    conn = [[Conexao alloc] initWithURL:[NSString stringWithFormat:@"%@Segurado/Home",[super getBaseUrl:@"v3"]] contentType:@"application/x-www-form-urlencoded"];
    
    [conn addHeaderValue:[NSString stringWithFormat:@"Bearer %@",[appDelegate getLoggeduser].access_token] field:@"Authorization"];
    [conn addGetParameters:[appDelegate getLoggeduser].cpfCnpj key:@"CpfCnpj"];
    [conn setDelegate:self];
    [conn setRetornoConexao:@selector(returnHomeV2:)];
    [conn startRequest];

}

#pragma mark Return Home V2
-(void)returnHomeV2:(NSData *)responseData{
    NSLog(@"Response: %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    
    NSError *error;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseData
                                                           options:NSJSONReadingMutableContainers error:&error];
    
    if(!error){
        @try {
            if([result objectForKey:@"message"] != nil && ![[result objectForKey:@"message"] isEqualToString:@""]){
                
                if(delegate && [delegate respondsToSelector:@selector(homeError:)]){
                    [delegate homeError:[result objectForKey:@"message"]];
                }
                return;
            }else{
                if(delegate && [delegate respondsToSelector:@selector(homeSuccessV2:)]){
                    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                    PolicyBeans *beans = [[PolicyBeans alloc] initWithDictionary:result];
//                    [beans setPayments:nil];
                    [[appDelegate getLoggeduser] setPolicyHome:beans];
                    [delegate homeSuccessV2:beans];

//                    [[MarketingCloudSDK sharedInstance] sfmc_setContactKey:beans.insurance.policy];
//                    [[MarketingCloudSDK sharedInstance] sfmc_setAttributeNamed:@"CPF" value: [[appDelegate getLoggeduser] cpfCnpj]];
//                    [[MarketingCloudSDK sharedInstance] sfmc_setAttributeNamed:@"Ramo" value: beans.insurance.policyBranch];
//                    [[MarketingCloudSDK sharedInstance] sfmc_setAttributeNamed:@"Apólice" value: beans.insurance.policy];
                    
                }
                return;
            }
        } @catch (NSException *exception) {
            NSLog(@"Exception: %@ - %@", exception.name , exception.reason);
        }
    }
    
    if(delegate && [delegate respondsToSelector:@selector(homeError:)]){
        [delegate homeError:NSLocalizedString(@"ConnectionError",@"")];
    }
    
}


-(void) getPaymentInfo{
    AppDelegate *appDelegate =  (AppDelegate*)[[UIApplication sharedApplication] delegate];
    conn = [[Conexao alloc] initWithURL:[NSString stringWithFormat:@"%@Segurado/Seguro/DadosPagamentoSeguro",[super getBaseUrl:@"v2"]] contentType:@"application/x-www-form-urlencoded"];
    
    PolicyBeans *homeBeans = [[appDelegate getLoggeduser] policyHome];
    [conn addHeaderValue:[NSString stringWithFormat:@"Bearer %@",[appDelegate getLoggeduser].access_token] field:@"Authorization"];
    [conn addGetParameters:[NSString stringWithFormat:@"%ld", [[homeBeans insurance] contract]] key:@"Contract"];
    
    for (id issuance in [[homeBeans insurance] issuances]) {
        [conn addGetParameters:[NSString stringWithFormat:@"%d", (int) [issuance intValue]]  key:@"Issuances[]"];
    }
    
    [conn addGetParameters:[NSString stringWithFormat:@"%d",[[homeBeans insurance] ciaCode]] key:@"CiaCode"];
    [conn setDelegate:self];
    [conn setRetornoConexao:@selector(returnPaymentsInfo:)];
    [conn startRequest];

    
}



-(void)returnPaymentsInfo:(NSData *)responseData{
    NSLog(@"Response Payments: %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    
    NSError *error;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseData
                                                           options:NSJSONReadingMutableContainers error:&error];
    
    if(!error){
        @try {
            if([[result objectForKey:@"sucesso"] boolValue] != true ){
                
                if(delegate && [delegate respondsToSelector:@selector(homeError:)]){
                    [delegate homeError:[result objectForKey:@"message"]];
                }
                return;
            }else{
                if(delegate && [delegate respondsToSelector:@selector(paymentsSuccess:)]){
                    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                    PolicyBeans *beans = [[appDelegate getLoggeduser] policyHome];
                    
                    NSMutableArray *arrayPayments = [[NSMutableArray alloc] init];
                    for (NSDictionary *payment in [result objectForKey:@"payments"] ){
                        [arrayPayments addObject:[[PaymentBeans alloc]  initWithDictionary:payment]];
                    }
                    [beans setPayments:arrayPayments];
                    [[appDelegate getLoggeduser] setPolicyHome:beans];
                    [delegate paymentsSuccess:beans];

                    
                }
                return;
            }
        } @catch (NSException *exception) {
            NSLog(@"Exception: %@ - %@", exception.name , exception.reason);
        }
    }
    
    if(delegate && [delegate respondsToSelector:@selector(homeError:)]){
        [delegate homeError:NSLocalizedString(@"ConnectionError",@"")];
    }
    
}


-(void) askToUseTouchId{
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSString *authToken = [appDelegate getAuthToken];
    
    if([authToken isEqualToString:@""]){
        return;
    }
    if([appDelegate usesTouchIDLogin]){
        return;
    }
    
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    NSString *myLocalizedReasonString = NSLocalizedString(@"LoginTouchID", @"");
    
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                  localizedReason:myLocalizedReasonString
                            reply:^(BOOL success, NSError *error) {
                                if (success) {
                                    NSLog(@"User is authenticated successfully");
                                    [appDelegate setUsesTouchID:YES];
                                    
                                } else {
                                    [appDelegate setUsesTouchID:NO];
                                    switch (error.code) {
                                        case LAErrorAuthenticationFailed:
                                            NSLog(@"Authentication Failed");
                                            break;
                                            
                                        case LAErrorUserCancel:
                                            NSLog(@"User pressed Cancel button");
                                           
                                            break;
                                            
                                        case LAErrorUserFallback:
                                            NSLog(@"User pressed \"Enter Password\"");
                                            
                                            break;
                                        default:
                                            NSLog(@"Touch ID is not configured");
                                            
                                            break;
                                    }
                                    NSLog(@"Authentication Fails");
                                }
                            }];
    }else{
        //NSLog(@"Can not evaluate Touch ID");
        [appDelegate setUsesTouchID:NO];
    }
}


-(void)retornaConexao:(NSURLResponse *)response responseString:(NSString *)responseString{
    
    NSLog(@"Retorno Conexao [%@] \n\n %@",response, responseString);
    
}

-(void)retornaErroConexao:(NSDictionary *)dictUserInfo response:(NSURLResponse *)response error:(NSError *)error{
    
    NSLog(@"Retorno erro conexão %@, %@", response , error);
    if(delegate && [delegate respondsToSelector:@selector(homeError:)]){
        [delegate homeError:NSLocalizedString(@"ConnectionError",@"") ];
    }
}
@end
