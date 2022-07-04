//
//  QrCodePixViewController.m
//  appsegurado
//
//  Created by Samuel Henrique on 31/03/22.
//  Copyright © 2022 Liberty Seguros. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QrCodePixViewController.h"
#import "../Models/PaymentModel.h"
#import "../Views/QrCodePixView.h"
#import "PaymentModel.h"

@implementation QrCodePixViewController

int numero;
QrCodePixView * view;
PaymentModel * model;
NSString * qrCodeValue;

- (id) initWithPayment: (int)paymentNumber contract: (long)contract insurance: (int)insurance {
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"PaymentPopups"
                                                          bundle:[NSBundle mainBundle]];

    self = [storyboard instantiateViewControllerWithIdentifier:@"PixQrCodeController"];
    model = [[PaymentModel alloc] init];
    [model setDelegate:self];

    [model getInstallmentPaymentLine:paymentNumber
                            contract:contract
                            issuance:insurance];
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    view = (QrCodePixView *)self.view;
    [view loadView];
}

- (void) copyQrCode: (id)sender {
    UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];

    pasteboard.string = qrCodeValue;
    _btnCopyQrCode.tintColor = UIColor.systemGreenColor;
    [_btnCopyQrCode setTitle:@"Código Copiado" forState:UIControlStateNormal];
    [_btnCopyQrCode setNeedsDisplay];
    [NSTimer scheduledTimerWithTimeInterval:3 repeats:NO block:^(NSTimer * time){
         [self dismissViewControllerAnimated:YES completion:nil];
     }];
}

- (void) renderQrCode: (NSString *)payload {
    qrCodeValue = payload;
    view.qrCodeValue = payload;
}

- (void) returnPaymentLine: (DigitableLineBeans *)beans {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self renderQrCode:beans.digitableLine];
    });
}

- (void) paymentLineFailed: (NSString *)message {
    NSLog(@"Error fetching! '%@'", message);
    // !FIXME:
    dispatch_async(dispatch_get_main_queue(), ^{
        [self renderQrCode:@"https://www.libertyseguros.com.br/Pages/Home.aspx"];
    });
}

@end
