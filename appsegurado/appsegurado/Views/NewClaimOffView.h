//
//  NewClaimOffView.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 28/11/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseView.h"
#import "CustomButton.h"
#import "CustomTextField.h"

@interface NewClaimOffView : BaseView<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthBox;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightScrollView;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblOr;

@property (strong, nonatomic) IBOutlet CustomTextField *txtPlatePolicy;
@property (strong, nonatomic) IBOutlet CustomTextField *txtCPF;

@property (strong, nonatomic) IBOutlet CustomButton *btStartClaim;
@property (strong, nonatomic) IBOutlet CustomButton *btLogin;
@property (strong, nonatomic) IBOutlet UIButton *btForgotPassword;
@property (strong, nonatomic) IBOutlet UIButton *btRegister;
@property (strong, nonatomic) IBOutlet UIButton *btDoubts;


-(void) loadView:(bool) isAssist24hs;
-(void) unloadView;
-(NSString*) getPlatePolicy;
-(NSString*) getCpf;
-(void) showPlatePolicyError:(NSString*)message;
-(void) showCPFError:(NSString*)message;
-(void) showLoading;
-(void) stopLoading;

@end
