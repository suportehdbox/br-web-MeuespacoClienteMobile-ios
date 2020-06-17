//
//  ChangePasswordView.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 10/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseView.h"
#import "UserInfoView.h"
#import "CustomButton.h"
#import "CustomTextField.h"

@interface ChangePasswordView : BaseView <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthBox;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightScrollView;

@property (strong, nonatomic) IBOutlet UserInfoView *userInfoView;

@property (strong, nonatomic) IBOutlet UIView *viewFields;
@property (strong, nonatomic) IBOutlet UIView *viewPassword;
@property (strong, nonatomic) IBOutlet UIImageView *imgIcon;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblInstructionsPassword;

@property (strong, nonatomic) IBOutlet CustomTextField *txtCpf;
@property (strong, nonatomic) IBOutlet CustomTextField *txtPwd;
@property (strong, nonatomic) IBOutlet CustomTextField *txtOldPwd;

@property (strong, nonatomic) IBOutlet CustomTextField *txtRepeatPwd;
@property (strong, nonatomic) IBOutlet CustomButton *btSend;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) IBOutlet UIView *popupSucess;
@property (strong, nonatomic) IBOutlet UILabel *lblSuccess;
@property (strong, nonatomic) IBOutlet CustomButton *btSucess;

-(void) loadView;
-(void) unloadView;
-(NSString*) getCPF;
-(NSString*) getNewPwd;
-(NSString*) getRepatPwd;
-(NSString*) getOldPwd;
-(void) showCpfError:(NSString*)message;
-(void) showPwdError:(NSString*)message;
-(void) showRepeatPwdError:(NSString*)message;
-(void) showOldPwdError:(NSString*)message;
-(void) showSuccessMessage;
-(void) showLoading;
-(void) stopLoading;
@end
