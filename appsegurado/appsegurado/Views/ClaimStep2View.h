//
//  ClaimStep2View.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 15/11/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseView.h"
#import "CustomTextField.h"
#import "UserBeans.h"

@interface ClaimStep2View : BaseView <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle2;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIView *bgView2;
@property (strong, nonatomic) IBOutlet UIImageView *imgSteps;
@property (strong, nonatomic) IBOutlet CustomButton *btNext;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *betweenSpace;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthSpace;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *btDoubts;
@property (strong, nonatomic) IBOutlet UIButton *btChoice1;
@property (strong, nonatomic) IBOutlet UIButton *btChoice2;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightDriver;
@property (strong, nonatomic) IBOutlet CustomTextField *txtName;
@property (strong, nonatomic) IBOutlet CustomTextField *txtEmail;
@property (strong, nonatomic) IBOutlet CustomTextField *txtPhone;

@property (strong, nonatomic) IBOutlet CustomTextField *txtDriverName;
@property (strong, nonatomic) IBOutlet CustomTextField *txtDriverBirthdate;
@property (strong, nonatomic) IBOutlet CustomTextField *txtDriverPhone;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

-(void) loadView:(UserBeans*) loggedUser;
-(void) unloadView;
- (void)registerForKeyboardNotifications;
-(NSString*) getName;
-(NSString*) getEmail;
-(NSString*) getPhone;
-(int) getDriver;
-(NSString*) getDriverName;
-(NSString*) getDriverBirthDate;
-(NSString*) getDriverPhone;
-(void) showNameError:(NSString*) msg;
-(void) showEmailError:(NSString*) msg;
-(void) showPhoneError:(NSString*) msg;
-(void) showDriverNameError:(NSString*) msg;
-(void) showDriverBirthdateError:(NSString*) msg;
-(void) showDriverPhoneError:(NSString*) msg;
@end
