//
//  HomeViewController.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 05/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseViewController.h"
#import "HomeModel.h"
#import "PolicyModel.h"
#import "ExtendParcelViewController.h"
#import "PaymentPopUpViewController.h"
#import "Vision360Model.h"

@interface HomeViewController : BaseViewController <HomeModelDelegate, PolicyModelDelegate, ExtendParcelDelegate, PaymentPopUpDelegate, VisionModelDelegate>
- (IBAction)showPolicyDetail:(id)sender;

- (IBAction)openExtendPayment:(id)sender;
-(IBAction) openParcels:(id)sender;
-(IBAction)openHomeAssist:(id)sender;

@end
