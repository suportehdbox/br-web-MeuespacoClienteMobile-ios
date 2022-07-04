//
//  DigitableLineViewController.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 21/03/18.
//  Copyright © 2018 Liberty Seguros. All rights reserved.
//

#import "DigitableLineViewController.h"
#import "DigitableLineView.h"

@interface DigitableLineViewController () {
    PaymentBeans * currentPayment;
    DigitableLineView * view;
    PaymentModel * model;
    DigitableLineBeans * currentLine;
    long currentContract;
    long currentIssuance;
    int currentCiaCode;
    long currentClientCode;
    NSString * urlDownload;

}

@end

@implementation DigitableLineViewController
- (id) initPaymentBeans: (PaymentBeans *)beans
    contract: (long)contract
    issuance: (int)issuance ciaCode: (int)ciaCode
    ClientCode: (long)clientCode; {

    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];

    self = [storyboard instantiateViewControllerWithIdentifier:@"DigitableLineViewController"];
    //    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    if (self) {
        currentPayment = beans;
        currentPayment.issuance = issuance;
        currentContract = contract;
        currentIssuance = issuance;
        currentCiaCode = ciaCode;
        currentClientCode = clientCode;
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    view = (DigitableLineView *)self.view;
    [view loadView];

    [view showLoading];
    model = [[PaymentModel alloc] init];
    [model setDelegate:self];

    [model getInstallmentPaymentLine:currentPayment.number contract:currentContract issuance:(int)currentIssuance];

    [self setAnalyticsTitle:@"Codigo de barras Parcela"];
    // Do any additional setup after loading the view.
}


- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) dealloc {
    if (model != nil) {
        [model setDelegate:nil];
        model = nil;
    }
}

- (IBAction) btCancelClicled: (id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction) btCopyCode: (id)sender {
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlDownload]];
    UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];

    pasteboard.string = currentLine.digitableLine;
    [view setCodeCopied];
}

- (IBAction) btOkClicked: (id)sender {

    if ([currentLine.summaryInstructions isEqualToString:@""]) {
        [self btCancelClicled:nil];
    } else {
        NSDictionary * options = [[NSDictionary alloc] init];
        // options can be empty
        NSURL * url = [NSURL URLWithString:@"https://www.santander.com.br/br/resolva-on-line/reemissao-de-boleto-vencido"];
        [[UIApplication sharedApplication] openURL:url options:options completionHandler:^(BOOL success){

         }];
    }

}

- (void) setPaymentBeans: (PaymentBeans *)beans {
    currentPayment = beans;
}


- (void) paymentLineFailed: (NSString *)message {
    [view hidePopUp];
    UIAlertController * alert = [view showSuccessMessageTitle:NSLocalizedString(@"AvisoProrrogar", @"") message:message handler:^(UIAlertAction * action) {
                                     [self btCancelClicled:nil];
                                 }];

    [self presentViewController:alert animated:YES completion:nil];

}

- (void) returnPaymentLine: (DigitableLineBeans *)beans {
    currentLine = beans;
    [view stopLoading];

    if ([beans.summaryInstructions isEqualToString:@""]) {
        // pagar
        [view setTitle:NSLocalizedString(@"TituloSegundaVia", @"") instructions:NSLocalizedString(@"SubTituloSegundaVia", @"") summaryInstructions:NSLocalizedString(@"SummaryInstructions", @"") linecode:beans.digitableLine completeInstructions:beans.completeInstructions];
    } else {
        // venceu boleto
        [view setTitle:NSLocalizedString(@"TituloBoletoVencido", @"")
                 instructions:NSLocalizedString(@"SubTituloBoletoVencido", @"")
          summaryInstructions:beans.summaryInstructions
                     linecode:beans.digitableLine
         completeInstructions:beans.completeInstructions];
        [view setBtSantander];
    }
}



- (IBAction) showTerms: (id)sender {
    [view showMessage:@"" message:currentLine.completeInstructions];
}


/*
 #pragma mark - Navigation
 *
 * // In a storyboard-based application, you will often want to do a little preparation before navigation
 * - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 * // Get the new view controller using [segue destinationViewController].
 * // Pass the selected object to the new view controller.
 * }
 */


@end
