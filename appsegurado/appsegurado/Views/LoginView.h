//
//  LoginView.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 26/09/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseView.h"
#import "CustomTextField.h"
#import "LoginViewController.h"

@import GoogleSignIn;


@interface LoginView : BaseView <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imgLogoLiberty;
@property (strong, nonatomic) IBOutlet UILabel *lblTouchId;
@property (strong, nonatomic) IBOutlet CustomButton *btLoginFacebook;
@property (strong, nonatomic) IBOutlet UILabel *lblOr;
@property (strong, nonatomic) IBOutlet CustomTextField *txtEmailCpf;
@property (strong, nonatomic) IBOutlet CustomTextField *txtPassword;
@property (strong, nonatomic) IBOutlet UISwitch *swLogado;
@property (strong, nonatomic) IBOutlet UILabel *lblSwitch;
@property (strong, nonatomic) IBOutlet CustomButton *btLogin;
@property (strong, nonatomic) IBOutlet UIButton *btForgetPassword;
@property (strong, nonatomic) IBOutlet UIButton *btForgetEmail;
@property (strong, nonatomic) IBOutlet UIButton *btRegister;
@property (strong, nonatomic) IBOutlet UIButton *btPrivacy;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthImage;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *acitivty;
@property (strong, nonatomic) IBOutlet GIDSignInButton *btGoogle;
@property (strong, nonatomic) IBOutlet UIView *viewBtApple;

-(void) loadView:(LoginViewController *)controller;
-(void) unloadView;
-(NSString*) getEmailCPF;
-(void) showEmailCPFError:(NSString*)message;
-(NSString*) getPwd;
-(BOOL) shouldStayLogged;
-(void) showPwdError:(NSString*)message;
-(void) showLoading;
-(void) stopLoading;
-(void) cleanPassword;
- (void)registerForKeyboardNotifications;
-(void) adjustScreen;

@end
