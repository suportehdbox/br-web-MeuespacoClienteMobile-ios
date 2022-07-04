//
//  PaymentPopUpView.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 21/05/2018.
//  Copyright © 2018 Liberty Seguros. All rights reserved.
//

#import "BaseView.h"
#import "../Models/PaymentOpt.h"

@interface PaymentPopUpView : BaseView



// Box Payments
@property (strong, nonatomic) IBOutlet UIView * boxPaymentsMethods;
@property (strong, nonatomic) IBOutlet UILabel * lblTitlePayments;
@property (strong, nonatomic) IBOutlet UIView * viewPayment1;
@property (strong, nonatomic) IBOutlet UIView * viewDivisor;
@property (strong, nonatomic) IBOutlet UILabel * lblPaymentOpt1;
@property (strong, nonatomic) IBOutlet CustomButton * btPaymentOpt1;
@property (strong, nonatomic) IBOutlet UIView * viewPayment2;
@property (strong, nonatomic) IBOutlet UILabel * lblPaymentOpt2;
@property (strong, nonatomic) IBOutlet CustomButton * btPaymentOpt2;
@property (strong, nonatomic) IBOutlet UIStackView * viewButtons;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView * activity;

- (void) loadView: (PaymentOpt)component;
- (void) startLoading;
- (void) stopLoading;
- (void) setPaymentValues: (NSString *)payment;
@end
