//
//  PaymentModel.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 01/11/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseModel.h"
#import "DigitableLineBeans.h"

@protocol PaymentModelDelegate <NSObject>
@optional
-(void)extendedPaymentSuccessfully:(NSString*)url;
-(void)extendedPaymentDate:(NSString*) date value:(NSString*)value;
-(void)extendedPaymentFailed:(NSString*)message;
-(void) returnPaymentLine:(DigitableLineBeans*)beans;
-(void) returnOnlinePayment:(NSString*)price;
-(void) returnOnlinePaymentError:(NSString*)error;
-(void) paymentLineFailed:(NSString*)message;
-(void) returnSessionId:(NSString*)sessionId;
-(void) sessionIdFailed:(NSString*)message;

@end
@interface PaymentModel : BaseModel <ConexaoDelegate>

@property (nonatomic) id<PaymentModelDelegate> delegate;
-(void) simulatePaymentNumber:(int)installment contract:(long)contract issuance:(int)issuance ciaCode:(int)ciaCode
                   ClientCode:(long)clientCode typoPayment:(NSString*) typePayment;

-(void) postPonePaymentNumber:(int)installment contract:(long)contract issuance:(int)issuance ciaCode:(int)ciaCode
                   ClientCode:(long)clientCode typoPayment:(NSString*) typePayment;

-(void) getInstallmentPaymentLine:(int)installment contract:(long)contract issuance:(int)issuance;

-(void) getSessionOnlinePayment:(int)installment contract:(long)contract issuance:(int)issuance ciaCode:(int)ciaCode
                  issuingAgency:(int)issuingAgency;

-(void) getOnlinePaymentValue:(int)installment contract:(long)contract issuance:(int)issuance showComponent:(int)showComponent;
@end
