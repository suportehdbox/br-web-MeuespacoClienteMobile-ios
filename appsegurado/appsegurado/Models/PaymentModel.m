//
//  PaymentModel.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 01/11/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "PaymentModel.h"
#import "AppDelegate.h"
@interface PaymentModel () {
    NSString * newDate;
    float newValue;
    int typeError;
}
@end
@implementation PaymentModel
@synthesize delegate;

- (void) simulatePaymentNumber: (int)installment contract: (long)contract issuance: (int)issuance ciaCode: (int)ciaCode
    ClientCode: (long)clientCode typoPayment: (NSString *)typePayment {

    conn = [[Conexao alloc] initWithURL:[NSString stringWithFormat:@"%@Segurado/Seguro/SimulaProrrogarParcela", [super getBaseUrl]] contentType:@"application/x-www-form-urlencoded"];

    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];


    [conn addHeaderValue:[NSString stringWithFormat:@"Bearer %@", [appDelegate getLoggeduser].access_token] field:@"Authorization"];
    //    [conn addGetParameters:[appDelegate getLoggeduser].cpfCnpj key:@"CpfCnpj"];

    [conn addPostParameters:[NSString stringWithFormat:@"%d", installment] key:@"installment"];
    [conn addPostParameters:[NSString stringWithFormat:@"%ld", contract] key:@"contract"];
    [conn addPostParameters:[NSString stringWithFormat:@"%d", issuance] key:@"issuance"];
    [conn addPostParameters:[NSString stringWithFormat:@"%d", ciaCode] key:@"CiaCode"];
    [conn addPostParameters:[NSString stringWithFormat:@"%ld", clientCode] key:@"ClientCode"];
    NSString * typePay = @"false";

    if (typePayment != nil && [typePayment isEqualToString:@"FB"]) {
        typePay = @"true";
    }
    [conn addPostParameters:typePay key:@"simularboleto"];


    //    [conn addGetParameters:@"57947848904" key:@"CpfCnpj"];
    [conn setDelegate:self];
    [conn setRetornoConexao:@selector(returnPayment:)];
    typeError = 0;

    [conn startRequest];

} /* simulatePaymentNumber */


- (void) returnPayment: (NSData *)responseData {
    NSLog(@"Response: %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);


    NSError * error;


    id result = [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingMutableContainers error:&error];

    if (!error) {
        if ([result isKindOfClass:[NSDictionary class]]) {

            if ([result objectForKey:@"message"] != nil && [result objectForKey:@"message"] != [NSNull null] && ![[result objectForKey:@"message"] isEqualToString:@""]) {
                if (delegate && [delegate respondsToSelector:@selector(extendedPaymentFailed:)]) {
                    [delegate extendedPaymentFailed:[result objectForKey:@"message"]];
                }
            } else {
                @try {
                    // novoVencimento
                    // novoValor
//                    newDate = [[result objectForKey:@"novoVencimento"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
                    newValue = [[result objectForKey:@"novoValor"] floatValue];

                    NSDateFormatter * dateformat = [[NSDateFormatter alloc] init];

                    [dateformat setDateFormat:@"yyyy-MM-dd"];
                    NSDate * nextDueDate = [dateformat dateFromString:[result objectForKey:@"novoVencimento"]];


                    [dateformat setTimeZone:[NSTimeZone localTimeZone]];
                    [dateformat setLocale:[NSLocale localeWithLocaleIdentifier:@"pt_BR"]];
                    [dateformat setDateFormat:@"dd/MM/yyyy"];

                    newDate = [dateformat stringFromDate:nextDueDate];
                    NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];
                    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
                    [numberFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"pt_BR"]];

                    NSString * valuePayment = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[[result objectForKey:@"novoValor"] floatValue]]];

                    if (delegate && [delegate respondsToSelector:@selector(extendedPaymentDate:value:)]) {
                        [delegate extendedPaymentDate:newDate value:valuePayment];
                    }

                } @catch (NSException * exception) {
                    NSLog(@"Exception %@", exception.description);
                    if (delegate && [delegate respondsToSelector:@selector(extendedPaymentFailed:)]) {
                        [delegate extendedPaymentFailed:NSLocalizedString(@"ErroNoSerivdor", @"")];
                    }
                }
            }

        }

    } else {



        if (delegate && [delegate respondsToSelector:@selector(extendedPaymentFailed:)]) {
            [delegate extendedPaymentFailed:NSLocalizedString(@"ConnectionError", @"") ];
        }


    }
} /* returnPayment */


- (void) postPonePaymentNumber: (int)installment contract: (long)contract issuance: (int)issuance ciaCode: (int)ciaCode
    ClientCode: (long)clientCode typoPayment: (NSString *)typePayment {

    conn = [[Conexao alloc] initWithURL:[NSString stringWithFormat:@"%@Segurado/Seguro/ProrrogarParcela", [super getBaseUrl]] contentType:@"application/x-www-form-urlencoded"];

    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];


    [conn addHeaderValue:[NSString stringWithFormat:@"Bearer %@", [appDelegate getLoggeduser].access_token] field:@"Authorization"];
    //    [conn addGetParameters:[appDelegate getLoggeduser].cpfCnpj key:@"CpfCnpj"];

    [conn addPostParameters:[NSString stringWithFormat:@"%d", installment] key:@"installment"];
    [conn addPostParameters:[NSString stringWithFormat:@"%ld", contract] key:@"contract"];
    [conn addPostParameters:[NSString stringWithFormat:@"%d", issuance] key:@"issuance"];
    [conn addPostParameters:[NSString stringWithFormat:@"%d", ciaCode] key:@"CiaCode"];
    [conn addPostParameters:[NSString stringWithFormat:@"%ld", clientCode] key:@"ClientCode"];
    [conn addPostParameters:newDate key:@"NovoVencimento"];
    [conn addPostParameters:[[NSString stringWithFormat:@"%.02f", newValue] stringByReplacingOccurrencesOfString:@"." withString:@","] key:@"NovoValor"];
    NSString * typePay = @"false";

    if (typePayment != nil && [typePayment isEqualToString:@"FB"]) {
        typePay = @"true";
    }
    [conn addPostParameters:typePay key:@"simularboleto"];


    //    [conn addGetParameters:@"57947848904" key:@"CpfCnpj"];
    [conn setDelegate:self];
    typeError = 1;
    [conn setRetornoConexao:@selector(returnPostPonePayment:)];
    [conn startRequest];

} /* postPonePaymentNumber */

- (void) returnPostPonePayment: (NSData *)responseData {
    NSLog(@"Response: %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);


    NSError * error;


    id result = [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingMutableContainers error:&error];

    if (!error) {
        if ([result isKindOfClass:[NSDictionary class]]) {

            if ([result objectForKey:@"message"] != nil  && [result objectForKey:@"message"] != [NSNull null] && ![[result objectForKey:@"message"] isEqualToString:@""]) {
                if (delegate && [delegate respondsToSelector:@selector(extendedPaymentFailed:)]) {
                    [delegate extendedPaymentFailed:[result objectForKey:@"message"]];
                }
            } else {
                @try {

//                    NSString *urlFinal =[NSString stringWithFormat:@"%@%@",[result objectForKey:@"urlBoleto"], [result objectForKey:@"boleto"]];
                    NSString * urlFinal = [result objectForKey:@"linhaDigitavel"];

                    if (delegate && [delegate respondsToSelector:@selector(extendedPaymentSuccessfully:)]) {
                        [delegate extendedPaymentSuccessfully:urlFinal];
                    }

                } @catch (NSException * exception) {
                    NSLog(@"Exception %@", exception.description);
                    if (delegate && [delegate respondsToSelector:@selector(extendedPaymentFailed:)]) {
                        [delegate extendedPaymentFailed:NSLocalizedString(@"ErroNoSerivdor", @"")];
                    }
                }
            }

        }

    } else {



        if (delegate && [delegate respondsToSelector:@selector(extendedPaymentFailed:)]) {
            [delegate extendedPaymentFailed:NSLocalizedString(@"ConnectionError", @"") ];
        }


    }
} /* returnPostPonePayment */



- (void) getInstallmentPaymentLine: (int)installment contract: (long)contract issuance: (int)issuance {

    conn = [[Conexao alloc]
            initWithURL:[NSString stringWithFormat:@"%@Segurado/Seguro/GetDigitableLine", [super getBaseUrl:@"v2"]]
            contentType:@"application/x-www-form-urlencoded"];

    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    [conn addHeaderValue:[NSString stringWithFormat:@"Bearer %@", [appDelegate getLoggeduser].access_token] field:@"Authorization"];
    //    [conn addGetParameters:[appDelegate getLoggeduser].cpfCnpj key:@"CpfCnpj"];
    [conn addGetParameters:[NSString stringWithFormat:@"%d", installment] key:@"installment"];
    [conn addGetParameters:[NSString stringWithFormat:@"%ld", contract] key:@"contract"];
    [conn addGetParameters:[NSString stringWithFormat:@"%d", issuance] key:@"issuance"];

    [conn setDelegate:self];
    typeError = 2;
    [conn setRetornoConexao:@selector(returnDigitableLine:)];
    [conn startRequest];

}

- (void) returnDigitableLine: (NSData *)responseData {
    NSLog(@"Response: %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);


    NSError * error;


    id result = [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingMutableContainers error:&error];

    if (!error) {
        if ([result isKindOfClass:[NSDictionary class]]) {

            if (![[result valueForKey:@"sucesso"] boolValue]) {
                if (delegate && [delegate respondsToSelector:@selector(paymentLineFailed:)]) {
                    [delegate paymentLineFailed:[result objectForKey:@"message"]];
                }
            } else {
                @try {
                    DigitableLineBeans * digitable = [[DigitableLineBeans alloc] initWithDictionary:result];
                    if (delegate && [delegate respondsToSelector:@selector(returnPaymentLine:)]) {
                        [delegate returnPaymentLine:digitable];
                    }

                } @catch (NSException * exception) {
                    NSLog(@"Exception %@", exception.description);
                    if (delegate && [delegate respondsToSelector:@selector(paymentLineFailed:)]) {
                        [delegate paymentLineFailed:NSLocalizedString(@"ErroNoSerivdor", @"")];
                    }
                }
            }

        }

    } else {



        if (delegate && [delegate respondsToSelector:@selector(paymentLineFailed:)]) {
            [delegate paymentLineFailed:NSLocalizedString(@"ConnectionError", @"") ];
        }


    }
} /* returnDigitableLine */

- (void) getSessionOnlinePayment: (int)installment contract: (long)contract issuance: (int)issuance ciaCode: (int)ciaCode
    issuingAgency: (int)issuingAgency {

    conn = [[Conexao alloc] initWithURL:[NSString stringWithFormat:@"%@/Segurado/Seguro/PagamentoOnLine", [super getBaseUrl]] contentType:@"application/x-www-form-urlencoded"];

    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    [conn addHeaderValue:[NSString stringWithFormat:@"Bearer %@", [appDelegate getLoggeduser].access_token] field:@"Authorization"];
    //    [conn addGetParameters:[appDelegate getLoggeduser].cpfCnpj key:@"CpfCnpj"];

    [conn addPostParameters:[NSString stringWithFormat:@"%d", ciaCode] key:@"ciaCode"];
    [conn addGetParameters:[NSString stringWithFormat:@"%ld", contract] key:@"contract"];
    [conn addGetParameters:[NSString stringWithFormat:@"%d", installment] key:@"installmentNumber"];
    [conn addGetParameters:[NSString stringWithFormat:@"%d", issuance] key:@"issuance"];
    [conn addPostParameters:[NSString stringWithFormat:@"%d", issuingAgency] key:@"issuingAgency"];

    typeError = 3;
    [conn setDelegate:self];
    [conn setRetornoConexao:@selector(returnSession:)];
    [conn startRequest];
}

- (void) returnSession: (NSData *)responseData {
    NSLog(@"Response: %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);


    NSError * error;


    id result = [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingMutableContainers error:&error];

    if (!error) {
        if ([result isKindOfClass:[NSDictionary class]]) {

            if (![[result valueForKey:@"success"] boolValue]) {
                if (delegate && [delegate respondsToSelector:@selector(sessionIdFailed:)]) {
                    [delegate sessionIdFailed:[result objectForKey:@"message"]];
                }
            } else {
                @try {
                    NSString * sessionId = [result valueForKey:@"sessionId"];
                    if (delegate && [delegate respondsToSelector:@selector(returnSessionId:)]) {
                        [delegate returnSessionId:sessionId];
                    }

                } @catch (NSException * exception) {
                    NSLog(@"Exception %@", exception.description);
                    if (delegate && [delegate respondsToSelector:@selector(sessionIdFailed:)]) {
                        [delegate sessionIdFailed:NSLocalizedString(@"ErroNoSerivdor", @"")];
                    }
                }
            }

        }

    } else {
        if (delegate && [delegate respondsToSelector:@selector(sessionIdFailed:)]) {
            [delegate sessionIdFailed:NSLocalizedString(@"ConnectionError", @"") ];
        }


    }
} /* returnSession */



- (void) getOnlinePaymentValue: (int)installment contract: (long)contract issuance: (int)issuance showComponent: (int)showComponent {

    conn = [[Conexao alloc] initWithURL:[NSString stringWithFormat:@"%@/Segurado/Seguro/Pagamento/Value", [super getBaseUrl]] contentType:@"application/x-www-form-urlencoded"];

    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    [conn addHeaderValue:[NSString stringWithFormat:@"Bearer %@", [appDelegate getLoggeduser].access_token] field:@"Authorization"];
    //    [conn addGetParameters:[appDelegate getLoggeduser].cpfCnpj key:@"CpfCnpj"];

    [conn addGetParameters:[NSString stringWithFormat:@"%ld", contract] key:@"Contract"];
    [conn addGetParameters:[NSString stringWithFormat:@"%d", installment] key:@"Installment"];
    [conn addGetParameters:[NSString stringWithFormat:@"%d", issuance] key:@"Issuance"];
    [conn addGetParameters:[NSString stringWithFormat:@"%d", showComponent] key:@"ShowComponent"];

    typeError = 4;
    [conn setDelegate:self];
    [conn setRetornoConexao:@selector(returnOnlinePayment:)];
    [conn startRequest];
}


- (void) returnOnlinePayment: (NSData *)responseData {
    NSLog(@"Response: %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);


    NSError * error;


    id result = [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingMutableContainers error:&error];

    if (!error) {
        if ([result isKindOfClass:[NSDictionary class]]) {

            if (![[result valueForKey:@"sucesso"] boolValue]) {
                if (delegate && [delegate respondsToSelector:@selector(returnOnlinePaymentError:)]) {
                    [delegate returnOnlinePaymentError:[result objectForKey:@"message"]];
                }
            } else {
                @try {
                    NSString * price = [result valueForKey:@"value"];
                    if (delegate && [delegate respondsToSelector:@selector(returnOnlinePayment:)]) {
                        [delegate returnOnlinePayment:price];
                    }

                } @catch (NSException * exception) {
                    NSLog(@"Exception %@", exception.description);
                    if (delegate && [delegate respondsToSelector:@selector(returnOnlinePaymentError:)]) {
                        [delegate returnOnlinePaymentError:NSLocalizedString(@"ErroNoSerivdor", @"")];
                    }
                }
            }

        }

    } else {
        if (delegate && [delegate respondsToSelector:@selector(sessionIdFailed:)]) {
            [delegate sessionIdFailed:NSLocalizedString(@"ConnectionError", @"") ];
        }


    }
} /* returnOnlinePayment */



- (void) retornaErroConexao: (NSDictionary *)dictUserInfo response: (NSURLResponse *)response error: (NSError *)error {

    NSLog(@"Retorno erro conexão %@, %@", response, error);
    switch (typeError) {
        case 0:
        case 1:
            if (delegate && [delegate respondsToSelector:@selector(extendedPaymentFailed:)]) {
                [delegate extendedPaymentFailed:NSLocalizedString(@"ErroNoSerivdor", @"")];
            }
            break;
        case 2:
            if (delegate && [delegate respondsToSelector:@selector(paymentLineFailed:)]) {
                [delegate paymentLineFailed:NSLocalizedString(@"ConnectionError", @"") ];
            }
            break;
        case 3:
            if (delegate && [delegate respondsToSelector:@selector(sessionIdFailed:)]) {
                [delegate sessionIdFailed:NSLocalizedString(@"ErroNoSerivdor", @"")];
            }
            break;
        case 4:
            if (delegate && [delegate respondsToSelector:@selector(returnOnlinePaymentError:)]) {
                [delegate returnOnlinePaymentError:NSLocalizedString(@"ErroNoSerivdor", @"")];
            }
            break;

        default:
            if (delegate && [delegate respondsToSelector:@selector(extendedPaymentFailed:)]) {
                [delegate extendedPaymentFailed:NSLocalizedString(@"ErroNoSerivdor", @"")];
            }
            break;
    } /* switch */

} /* retornaErroConexao */

@end
