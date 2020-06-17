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

@interface ChangePhoneView : BaseView <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthBox;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightScrollView;

@property (strong, nonatomic) IBOutlet UserInfoView *userInfoView;

@property (strong, nonatomic) IBOutlet UIView *viewFields;
@property (strong, nonatomic) IBOutlet UIView *viewPassword;
@property (strong, nonatomic) IBOutlet UIImageView *imgIcon;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblInstructionsPassword;

@property (strong, nonatomic) IBOutlet CustomTextField *txtPhone;
@property (strong, nonatomic) IBOutlet CustomTextField *txtExtension;
@property (strong, nonatomic) IBOutlet CustomTextField *txtCellPhone;

@property (strong, nonatomic) IBOutlet CustomButton *btSend;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) IBOutlet UIView *popupSucess;
@property (strong, nonatomic) IBOutlet UILabel *lblSuccess;
@property (strong, nonatomic) IBOutlet CustomButton *btSucess;

-(void) loadView;
-(void) unloadView;
-(NSString*) getPhone;
-(NSString*) getExtension;
-(NSString*) getCellPhone;
-(void) showSuccessMessage;
-(void) showLoading;
-(void) stopLoading;
-(void) showCellPhoneError:(NSString*)message;
-(void) showExtensionError:(NSString*)message;
-(void) showPhoneError:(NSString*)message;
-(void) setPhone:(NSString*)value;
-(void) setExtension:(NSString*)value;
-(void) setCellPhone:(NSString*)value;
@end
