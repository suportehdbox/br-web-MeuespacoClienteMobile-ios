//
//  HomeView.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 05/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseView.h"
#import "CircleTimer.h"
#import "UserInfoView.h"
#import "CircleButton.h"
#import "PolicyBeans.h"
#import "HomeViewController.h"

@interface HomeView : BaseView

@property (weak, nonatomic) IBOutlet UIView *visionButton;
@property (strong, nonatomic) IBOutlet UserInfoView *userInfoView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthView;
@property (strong, nonatomic) IBOutlet CircleButton *btAssist;
@property (strong, nonatomic) IBOutlet CircleButton *btAutoWorkShop;
@property (strong, nonatomic) IBOutlet CircleButton *btClub;
@property (strong, nonatomic) IBOutlet UIImageView *iconPolicy;
@property (strong, nonatomic) IBOutlet UILabel *lblInformation;
@property (strong, nonatomic) IBOutlet UILabel *lblTitlePolicy;
@property (strong, nonatomic) IBOutlet UILabel *lblPolicyNumber;
@property (strong, nonatomic) IBOutlet UIImageView *iconTypePolicy;
@property (strong, nonatomic) IBOutlet UILabel *lblTypePoliy;
@property (strong, nonatomic) IBOutlet UILabel *lblPolicyDescription;

//@property (strong, nonatomic) IBOutlet UILabel *lblPayment;
//@property (strong, nonatomic) IBOutlet UILabel *lblPaymentDate;
//@property (strong, nonatomic) IBOutlet UILabel *lblPaymentValue;
//@property (strong, nonatomic) IBOutlet UIImageView *imgStatus;
//@property (strong, nonatomic) IBOutlet UIButton *btPay;
//@property (strong, nonatomic) IBOutlet UILabel *lblPaymentDescription;

@property (strong, nonatomic) IBOutlet CustomButton *btInstallments;
@property (strong, nonatomic) IBOutlet CircleTimer *durationPolicy;
@property (strong, nonatomic) IBOutlet CircleTimer *IPVA;
@property (strong, nonatomic) IBOutlet CircleTimer *licensing;

@property (strong, nonatomic) IBOutlet UIView *viewPolicy;
@property (strong, nonatomic) IBOutlet UILabel *titlePaymentView;
@property (strong, nonatomic) IBOutlet UIButton *btExpand;
@property (strong, nonatomic) IBOutlet UIButton *btDetailPayment;
@property (strong, nonatomic) IBOutlet UIView *viewParcels;
@property (strong, nonatomic) IBOutlet UIView *viewClaim;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *spaceBetweenTimers;
@property (strong, nonatomic) IBOutlet UIImageView *iconClaim;
@property (strong, nonatomic) IBOutlet UILabel *titleClaim;
@property (strong, nonatomic) IBOutlet UILabel *statusClaim;
@property (strong, nonatomic) IBOutlet UIImageView *imgStatusClaim;

@property (strong, nonatomic) IBOutlet CustomButton *btMorePolices;
@property (strong, nonatomic) IBOutlet CustomButton *btDetails;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;

@property (strong, nonatomic) IBOutlet UIView *containerPayments;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightContainer;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *posXButtonAssist;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *posXButtonAutoWork;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *posXButtonClub;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingPayments;

-(void) loadView:(PolicyBeans*)beans controller:(HomeViewController*)controller;
-(void) loadViewAfterAppeared;
-(void) unloadView;
-(void) showLoading;
-(void) stopLoading;
-(void)hideVision;
-(void)showVision;
-(void) showMorePolicesButton;
-(void) hideScrollView;
-(void)expandPayments:(BOOL) expanded loading:(BOOL)loading;
-(void) displayPaymentInformation:(PolicyBeans*)beans;

@end
