//
//  ForgotPasswordView.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 29/09/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseView.h"
#import "CustomTextField.h"

@interface ForgotPasswordView : BaseView <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imgLogoLiberty;
@property (strong, nonatomic) IBOutlet UILabel *lblRegister;
@property (strong, nonatomic) IBOutlet CustomTextField *txtEmail;
@property (strong, nonatomic) IBOutlet CustomTextField *txtCpf;
@property (strong, nonatomic) IBOutlet CustomButton *btLogin;
@property (strong, nonatomic) IBOutlet UIButton *btRegister;
@property (strong, nonatomic) IBOutlet UIButton *btPrivacy;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthImage;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *acitivty;

-(void) loadView;
-(void) unloadView;
-(NSString*) getEmail;
-(void) showEmailError:(NSString*)message;
-(NSString*) getCpf;
-(void) showCpfError:(NSString*)message;
-(void) showLoading;
-(void) stopLoading;

@end
