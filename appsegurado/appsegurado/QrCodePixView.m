//
//  QrCodePixView.m
//  appsegurado
//
//  Created by Samuel Henrique on 01/04/22.
//  Copyright © 2022 Liberty Seguros. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QrCodePixView.h"

@implementation QrCodePixView


- (void) loadView {
}

- (void) setQrCodeValue: (NSString *)qrCodeValue {
    CIFilter * filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    NSData * payload = [qrCodeValue dataUsingEncoding:NSUTF8StringEncoding];

    [filter setValue:payload forKey:@"inputMessage"];
    CGAffineTransform transform = CGAffineTransformMakeScale(5, 5);
    CIImage * qrCodeScaled = [filter.outputImage imageByApplyingTransform:transform];
    UIImage * image = [UIImage imageWithCIImage:qrCodeScaled];

    _qrCodeImage.image = image;
    [_qrCodeImage setContentMode:UIViewContentModeScaleToFill];
    [_qrCodeImage sizeToFit];
    [_qrCodeImage setNeedsDisplay];
    _btnCopyQrCode.enabled = true;
    _qrCodeValue = qrCodeValue;
}

@end

