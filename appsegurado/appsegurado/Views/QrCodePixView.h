//
//  QrCodePixView.h
//  appsegurado
//
//  Created by Samuel Henrique on 01/04/22.
//  Copyright © 2022 Liberty Seguros. All rights reserved.
//

#ifndef QrCodePixView_h
#define QrCodePixView_h

#import "BaseView.h"

@interface QrCodePixView : BaseView

@property (strong, nonatomic) NSString * qrCodeValue;
@property (strong, nonatomic) IBOutlet UIImageView * qrCodeImage;
@property (strong, nonatomic) IBOutlet UIButton * btnCopyQrCode;

- (void) loadView;

@end

#endif /* QrCodePixView_h */
