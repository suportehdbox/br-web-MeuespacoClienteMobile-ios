//
//  DigitableLineView.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 21/03/18.
//  Copyright © 2018 Liberty Seguros. All rights reserved.
//

#import "BaseView.h"

@interface DigitableLineView : BaseView

@property (strong, nonatomic) IBOutlet UIView *boxView;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblInstructions1;
@property (strong, nonatomic) IBOutlet UILabel *lblPaymentInstructions;
@property (strong, nonatomic) IBOutlet UILabel *lblDateAndPayment;
@property (strong, nonatomic) IBOutlet CustomButton *btAgreed;
@property (strong, nonatomic) IBOutlet CustomButton *btCopyCode;
@property (strong, nonatomic) IBOutlet UIView *line1;
@property (strong, nonatomic) IBOutlet UIView *line2;
@property (strong, nonatomic) IBOutlet CustomButton *btOk;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (strong, nonatomic) IBOutlet UIButton *btTerms;


-(void) loadView;
-(void) setTitle:(NSString*)title instructions:(NSString*)instructions summaryInstructions:(NSString*)summaryInstructions linecode:(NSString*) linecode completeInstructions:(NSString*) completeInstructions;
-(void) stopLoading;
-(void) showLoading;
-(void) hidePopUp;
-(void) setBtSantander;
-(void) setCodeCopied;
@end
