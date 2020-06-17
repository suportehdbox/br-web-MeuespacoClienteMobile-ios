//
//  ParcelsViewController.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 26/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseViewController.h"
#import "PolicyModel.h"
#import "PolicyBeans.h"
#import "ExtendParcelViewController.h"
#import "PaymentPopUpViewController.h"

@interface ParcelsViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, PolicyModelDelegate, ExtendParcelDelegate, PaymentModelDelegate, PaymentPopUpDelegate>

-(void) setPolicy:(PolicyBeans*)beans indexPayment:(int)index;
@end
