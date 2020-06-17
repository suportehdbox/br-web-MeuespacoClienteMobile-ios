//
//  ExtendParcelView.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 27/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseView.h"
#import "CustomButton.h"

@interface ExtendParcelView : BaseView
@property (strong, nonatomic) IBOutlet UIView *boxView;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblInstructions1;
@property (strong, nonatomic) IBOutlet UILabel *lblPaymentInstructions;
@property (strong, nonatomic) IBOutlet UILabel *lblDateAndPayment;
@property (strong, nonatomic) IBOutlet UISwitch *swAgreed;
@property (strong, nonatomic) IBOutlet UILabel *lblTerms;
@property (strong, nonatomic) IBOutlet CustomButton *btAgreed;
@property (strong, nonatomic) IBOutlet UIView *line1;
@property (strong, nonatomic) IBOutlet UIView *line2;
@property (strong, nonatomic) IBOutlet UIView *popUpSuccess;
@property (strong, nonatomic) IBOutlet CustomButton *btOpenPDF;
@property (strong, nonatomic) IBOutlet CustomButton *btOk;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleSuccess;
@property (strong, nonatomic) IBOutlet UILabel *lblInstructionsSuccess;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (strong, nonatomic) IBOutlet UIButton *btTerms;


-(void) loadView;
-(void) setDate:(NSString*)date setValue:(NSString*)value;
-(void) stopLoading;
-(void) showLoading;
-(void) showPopUpSuccessfull:(NSString*) barCode;
-(void) hidePopUp;


@end
