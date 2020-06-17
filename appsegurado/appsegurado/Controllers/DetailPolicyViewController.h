//
//  DetailPolicyViewController.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 17/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//
#import "PolicyBeans.h"

#import "BaseViewController.h"
#import "PolicyModel.h"
#import "ExtendParcelViewController.h"
#import "PaymentPopUpViewController.h"
#import "SecondPolicyViewController.h";
#import "Vision360Model.h"

@interface DetailPolicyViewController : BaseViewController <PolicyModelDelegate,ExtendParcelDelegate, PaymentPopUpDelegate, SecondPolicyDelegate,VisionModelDelegate>

- (IBAction)loadOldPolices:(id)sender;

-(void) setInsurance:(PolicyBeans*)beans;
-(void) showMorePolicesButton:(BOOL)show;
- (IBAction)btShowParcels:(id)sender;
@end

