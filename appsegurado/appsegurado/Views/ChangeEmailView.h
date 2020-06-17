//
//  ChangeEmailView.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 11/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseView.h"
#import "UserInfoView.h"
#import "CustomButton.h"
#import "CustomTextField.h"

@interface ChangeEmailView : BaseView <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthBox;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightScrollView;

@property (strong, nonatomic) IBOutlet UserInfoView *userInfoView;

@property (strong, nonatomic) IBOutlet UIView *viewFields;
@property (strong, nonatomic) IBOutlet UIImageView *imgIcon;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

@property (strong, nonatomic) IBOutlet CustomTextField *txtEmail;
@property (strong, nonatomic) IBOutlet CustomTextField *txtRepeatEmail;

@property (strong, nonatomic) IBOutlet CustomButton *btSend;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) IBOutlet UIView *popupSucess;
@property (strong, nonatomic) IBOutlet UILabel *lblSuccess;
@property (strong, nonatomic) IBOutlet CustomButton *btSucess;

-(void) loadView;
-(void) unloadView;
-(NSString*) getEmail;
-(NSString*) getRepeatEmail;
-(void) showEmailError:(NSString*)message;
-(void) showRepeatEmailError:(NSString*)message;
-(void) showSuccessMessage;
-(void) showLoading;
-(void) stopLoading;
@end
