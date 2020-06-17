//
//  DetailPolicyView.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 17/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseView.h"
#import "CustomButton.h"
#import "CircleTimer.h"
#import "PolicyBeans.h"
#import "DetailPolicyViewController.h"
@interface DetailPolicyView : BaseView

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthCard;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightCard;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *marginBotton;
@property (strong, nonatomic) IBOutlet UIImageView *iconPolicy;
@property (strong, nonatomic) IBOutlet UILabel *lblTitlePolicy;
@property (strong, nonatomic) IBOutlet UILabel *lblPolicyNumber;
//@property (strong, nonatomic) IBOutlet UIImageView *iconTypePolicy;
//@property (strong, nonatomic) IBOutlet UILabel *lblTypePoliy;
//@property (strong, nonatomic) IBOutlet UILabel *lblPolicyDescription;
//@property (strong, nonatomic) IBOutlet UILabel *lblPayment;
//@property (strong, nonatomic) IBOutlet UILabel *lblPaymentDate;
//@property (strong, nonatomic) IBOutlet UILabel *lblPaymentValue;
//@property (strong, nonatomic) IBOutlet UIImageView *imgStatus;
//@property (strong, nonatomic) IBOutlet UIButton *btPay;
//@property (strong, nonatomic) IBOutlet UILabel *lblPaymentDescription;
//@property (strong, nonatomic) IBOutlet CustomButton *btInstallments;
@property (strong, nonatomic) IBOutlet CircleTimer *durationPolicy;
@property (strong, nonatomic) IBOutlet CircleTimer *IPVA;
@property (strong, nonatomic) IBOutlet CircleTimer *licensing;
@property (strong, nonatomic) IBOutlet UILabel *lblTalkAgent;
@property (strong, nonatomic) IBOutlet UILabel *lblAgentName;
@property (strong, nonatomic) IBOutlet UIButton *btPhoneAgent;
@property (strong, nonatomic) IBOutlet UIButton *btMail;
@property (strong, nonatomic) IBOutlet CustomButton *showOldPolices;
@property (strong, nonatomic) IBOutlet CustomButton *btCoverages;
@property (strong, nonatomic) IBOutlet CustomButton *bt2Policy;
@property (strong, nonatomic) IBOutlet UITextView *txtCoverages;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *coverageSpace;
@property (strong, nonatomic) IBOutlet UIView *containerPayments;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightContainer;
@property (strong, nonatomic) IBOutlet UIView *containerCoverage;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightCoverage;
@property (strong, nonatomic) IBOutlet UIView *visionView;
@property (weak, nonatomic) IBOutlet UIView *visionContainer;

-(void) loadView:(PolicyBeans *)policybeans controller:(DetailPolicyViewController*) cont;
-(void) unloadView;
-(void) showLoading;
-(void) stopLoading;
-(void) showButtonOldPolices;
-(void)hideVision;
-(void)showVision;
@end
