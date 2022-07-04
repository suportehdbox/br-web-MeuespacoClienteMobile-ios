//
//  PaymentPopUpViewController.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 21/05/2018.
//  Copyright © 2018 Liberty Seguros. All rights reserved.
//

#import "BaseViewController.h"
#import "PaymentPopUpView.h"
#import "PaymentBeans.h"
#import "PaymentModel.h"

@protocol PaymentPopUpDelegate <NSObject>
- (void) openWebView: (UIViewController *)viewController;

@end

@interface PaymentPopUpViewController : BaseViewController <PaymentModelDelegate>
@property (nonatomic, assign) id<PaymentPopUpDelegate> delegate;

- (id) initPaymentBeans: (PaymentBeans *)beans
    contract: (long)contract
    issuance: (int)issuance
    ciaCode: (int)ciaCode
    ClientCode: (long)clientCode
    issuingAgency: (int)issuingAgency;
@end
