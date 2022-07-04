//
//  DigitableLineViewController.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 21/03/18.
//  Copyright © 2018 Liberty Seguros. All rights reserved.
//

#import "BaseViewController.h"
#import "PaymentBeans.h"
#import "PaymentModel.h"


@interface DigitableLineViewController : BaseViewController <PaymentModelDelegate>

- (id) initPaymentBeans: (PaymentBeans *)beans
    contract: (long)contract
    issuance: (int)issuance
    ciaCode: (int)ciaCode
    ClientCode: (long)clientCode;
- (void) setPaymentBeans: (PaymentBeans *)beans;


@end
