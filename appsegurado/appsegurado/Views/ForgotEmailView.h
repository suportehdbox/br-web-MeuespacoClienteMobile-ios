//
//  ForgotEmailView.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 09/11/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseView.h"
#import "CustomTextField.h"

@interface ForgotEmailView : BaseView <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet CustomButton *btNext;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (strong, nonatomic) IBOutlet UIImageView *imgSteps;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIImageView *lblIconTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblDescription;
@property (strong, nonatomic) IBOutlet UILabel *lblSubTitle;
@property (strong, nonatomic) IBOutlet CustomTextField *txtField1;
@property (strong, nonatomic) IBOutlet CustomTextField *txtField2;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthBgView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightView;
@property (strong, nonatomic) IBOutlet UIView *viewSuccess;
@property (strong, nonatomic) IBOutlet UILabel *lblSuccess;
@property (strong, nonatomic) IBOutlet CustomButton *btSucess;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightDesc;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *spaceButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthSteps1;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthSteps2;
-(void) loadView;
-(void) unloadView;
-(NSString*) getField1;
-(void) showField1Error:(NSString*)message;
-(NSString*) getField2;
-(void) showField2Error:(NSString*)message;
-(void) showLoading;
-(void) stopLoading;
-(void) showNewEmailForm;
-(void) showRequestCpf;
-(void) showQuestion:(NSString*) title number:(NSString*)number;
-(void) showSuccessMessage;
@end
