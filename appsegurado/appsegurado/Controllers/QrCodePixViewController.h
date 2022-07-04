//
//  QrCodePixViewController.h
//  appsegurado
//
//  Created by Samuel Henrique on 31/03/22.
//  Copyright © 2022 Liberty Seguros. All rights reserved.
//

#ifndef QrCodePixViewController_h
#define QrCodePixViewController_h

#import "BaseViewController.h"
#import "PaymentModel.h"

@interface QrCodePixViewController : BaseViewController<PaymentModelDelegate>

@property (strong, nonatomic) IBOutlet UIButton * btnCopyQrCode;

- (id) initWithPayment: (int)paymentNumber contract: (long)contract insurance: (int)insurance;
- (void) viewDidLoad;

- (IBAction) copyQrCode: (id)sender;
- (IBAction) clickOutside: (id)sender;
@end

#endif /* QrCodePixViewController_h */
