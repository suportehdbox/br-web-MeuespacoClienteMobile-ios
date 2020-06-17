//
//  ExtendParcelViewController.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 27/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseViewController.h"
#import "PaymentBeans.h"
#import "PaymentModel.h"

#define PaymentExtendedObserver @"paymentExtended"


@protocol ExtendParcelDelegate <NSObject>
-(void) paymentExtendedSuccessfully:(PaymentBeans*)beans;
@end
@interface ExtendParcelViewController : BaseViewController <PaymentModelDelegate>
@property (nonatomic,assign) id<ExtendParcelDelegate> delegate;
- (id)initPaymentBeans:(PaymentBeans*)beans contract:(long) contract issuance:(int) issuance ciaCode:(int)ciaCode
            ClientCode:(long) clientCode;
-(void) setPaymentBeans:(PaymentBeans*)beans;




@end
