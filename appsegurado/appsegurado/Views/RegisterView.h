//
//  RegisterView.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 29/09/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseView.h"
#import "CustomTextField.h"
#import "FBUserBeans.h"
@interface RegisterSuccessView : BaseView

@property (strong, nonatomic) IBOutlet UILabel *lblInstructions;
@property (strong, nonatomic) IBOutlet CustomButton *btOk;
@property (strong, nonatomic) IBOutlet UIButton *btSendEmail
;
-(void) loadView;

@end


@interface RegisterView : BaseView <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIView *groupView1;
@property (strong, nonatomic) IBOutlet UILabel *lblInstructions;
@property (strong, nonatomic) IBOutlet UILabel *lblFields;
@property (strong, nonatomic) IBOutlet CustomTextField *txtName;
@property (strong, nonatomic) IBOutlet CustomTextField *txtPolicyNumber;
@property (strong, nonatomic) IBOutlet CustomTextField *txtCpf;

@property (strong, nonatomic) IBOutlet UIView *groupView2;

@property (strong, nonatomic) IBOutlet CustomTextField *txtEmail;
@property (strong, nonatomic) IBOutlet CustomTextField *txtRepeatEmail;


@property (strong, nonatomic) IBOutlet UIView *groupView3;

@property (strong, nonatomic) IBOutlet UILabel *lblPasswordInstruction;

@property (strong, nonatomic) IBOutlet CustomTextField *txtPassword;

@property (strong, nonatomic) IBOutlet CustomTextField *txtRepeatPassword;

@property (strong, nonatomic) IBOutlet UIView *groupView4;

@property (strong, nonatomic) IBOutlet UISwitch *swAgreeTerms;

@property (strong, nonatomic) IBOutlet UIButton *btTerms;
@property (strong, nonatomic) IBOutlet CustomButton *btRegister;
@property (nonatomic) IBOutlet NSLayoutConstraint *widthView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (strong, nonatomic) IBOutlet UIView *pwdBox;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *pwdBoxHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *emailBoxHeight;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *buttonsHeightConstraints;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *positionButtonAuto;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *policyBoxHeightConstraints;

@property (strong, nonatomic) IBOutlet UIButton *btAuto;
@property (strong, nonatomic) IBOutlet UIButton *btHome;
@property (strong, nonatomic) IBOutlet UIButton *btLife;

@property (strong,nonatomic) IBOutlet RegisterSuccessView *popupSuccess;


-(void) loadView;
-(void) unloadView;
-(void) loadValuesWith:(FBUserBeans*)user;
-(void) showLoading;
-(void) stopLoading;


-(NSString*) getName;
-(NSString*) getPolicyNumber;
-(NSString*) getCpf;
-(NSString*) getEmail;
-(NSString*) getRepeatEmail;
-(NSString*) getPwd;
-(NSString*) getRepeatPwd;
-(int) getTypePolice;
-(BOOL) isTermsAgreed;
-(void) showSuccessMessage;
-(void) showNameError:(NSString*)message;
-(void) showPolicyError:(NSString*)message;
-(void) showCpfError:(NSString*)message;
-(void) showEmailError:(NSString*)message;
-(void) showRepeatEmailError:(NSString*)message;
-(void) showPasswordError:(NSString*)message;
-(void) showRepeatPasswordError:(NSString*)message;


@end
