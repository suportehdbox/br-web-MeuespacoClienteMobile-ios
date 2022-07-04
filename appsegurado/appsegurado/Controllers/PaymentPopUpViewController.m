//
//  PaymentPopUpViewController.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 21/05/2018.
//  Copyright © 2018 Liberty Seguros. All rights reserved.
//

#import "PaymentPopUpViewController.h"
#import "DigitableLineViewController.h"
#import "ExtendParcelViewController.h"
#import "CustomWebViewController.h"
#import "QrCodePixViewController.h"
#import "../Models/PaymentOpt.h"

@interface PaymentPopUpViewController () {
    PaymentPopUpView * view;
    PaymentBeans * currentPayment;
    long currentContract;
    int currentIssuance;
    int currentCiaCode;
    long currentClientCode;
    int currentIssuingAgency;
    DigitableLineViewController * getDigitableLine;
    QrCodePixViewController * pixController;
    ExtendParcelViewController * extends;
    PaymentModel * model;
}

@end

@implementation PaymentPopUpViewController
@synthesize delegate;

- (id) initPaymentBeans: (PaymentBeans *)beans
    contract: (long)contract
    issuance: (int)issuance ciaCode: (int)ciaCode
    ClientCode: (long)clientCode issuingAgency: (int)issuingAgency; {

    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];

    self = [storyboard instantiateViewControllerWithIdentifier:@"PaymentPopUpController"];
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;

    if (self) {
        currentPayment = beans;
        currentPayment.issuance = issuance;
        currentContract = contract;
        currentIssuance = issuance;
        currentCiaCode = ciaCode;
        currentClientCode = clientCode;
        currentIssuingAgency = issuingAgency;
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    view = (PaymentPopUpView *)self.view;
    [view loadView:currentPayment.showComponent];

    model = [[PaymentModel alloc] init];
    [model setDelegate:self];
    if (currentPayment.showComponent >= 3 &&
        (currentPayment.showComponent < 6 || currentPayment.showComponent >= 9)) { // 3 , 4 or 5 are online payment option
        [model getOnlinePaymentValue:currentPayment.number contract:currentContract issuance:currentIssuance showComponent:currentPayment.showComponent];
        [view startLoading];
    }
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) btCancelClicled: (id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) openDigitalbeline {
    getDigitableLine = [[DigitableLineViewController alloc]
                        initPaymentBeans:currentPayment
                                contract:currentContract
                                issuance:currentIssuance
                                 ciaCode:currentCiaCode
                              ClientCode:currentClientCode];
    [self presentViewController:getDigitableLine animated:YES completion:nil];
}

- (void) openPixQrCode {
    pixController = [[QrCodePixViewController alloc] initWithPayment:currentPayment.number
                                                            contract:currentContract
                                                           insurance:currentIssuance];
    [self presentViewController:pixController animated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) openExtends {
    extends = [[ExtendParcelViewController alloc] initPaymentBeans:currentPayment contract:currentContract issuance:currentIssuance ciaCode:currentCiaCode ClientCode:currentClientCode];
    //                            [extends setDelegate:self];
    [self presentViewController:extends animated:YES completion:nil];
}

- (void) openWebView {
    [model getSessionOnlinePayment:currentPayment.number contract:currentContract issuance:currentIssuance ciaCode:currentCiaCode issuingAgency:currentIssuingAgency];
    [view startLoading];
}

- (IBAction) button1Click: (id)sender {
    switch (currentPayment.showComponent) {
        case PaymentOptTicket:
            // Ticket = 1 à Código de barras
            [self openDigitalbeline];
            break;
        case PaymentOptReprogramming:
            // Reprogramming = 2 à Reprograma
            [self openExtends];
            break;
        case PaymentOptOnline:
            //  OnlinePayment = 3 à Pagamento online
            [self openWebView];
            break;
        case PaymentOptTicketAndOnline:
            // TicketAndOnlinePayment = 4 à Código de barras e Pagamento online
            [self openDigitalbeline];
            break;
        case PaymentOptReprogrammingAndOnline:
            // ReprogrammingAndOnlinePayment = 5 à Reprograma e Pagamento online
            [self openExtends];
//            [_lblPaymentOpt2 setText:NSLocalizedString(@"PagamentoOnline", @"")];
            break;
        case PaymentOptReprogrammingAndOnlineStatus:
            // ReprogrammingAndOnlineStatus = 6  à Reprograma e consulta pgt. online
            [self openExtends];
//            [_lblPaymentOpt2 setText:NSLocalizedString(@"ConsultarPagamento", @"")];
//            [_btPaymentOpt2 setTitle:NSLocalizedString(@"Consultar", @"") forState:UIControlStateNormal];
            break;
        case PaymentOptTicketAndOnlineStatus: // ticket online payment
            [self openDigitalbeline];
            break;
        case PaymentOptOnlineStatus:
            // OnlineStatus = 8 à Consulta pagamento online
            [self openWebView];
            break;
        case PaymentOptPixActive:
            // OnlineStatus = 8 à Consulta pagamento online
            [self openPixQrCode];
            break;
        case PaymentOptPixExpired:
            // OnlineStatus = 8 à Consulta pagamento online
            [self openWebView];
            break;
        default:
            break;
    } /* switch */
} /* button1Click */

- (IBAction) button2Click: (id)sender {
    [self openWebView];
}

#pragma mark - SessionId Delegates

- (void) returnSessionId: (NSString *)sessionId {
    [view stopLoading];

    if (delegate != nil && [delegate respondsToSelector:@selector(openWebView:)]) {
        NSString * params = [NSString stringWithFormat:@"%@?IdSessao=%@&UserID=app", [model getOnlinePaymentUrl], sessionId];
        NSURL * url = [NSURL URLWithString:params];
        CustomWebViewController * webController =  [[CustomWebViewController alloc] initWithUrlRequest:[NSURLRequest requestWithURL:url]];
        [delegate openWebView:webController];
    }
}

- (void) sessionIdFailed: (NSString *)message {
    [view stopLoading];
    [view showMessage:NSLocalizedString(@"Erro", @"") message:message];
}


#pragma mark - Payment price Delegate
- (void) returnOnlinePayment: (NSString *)price {
    [view stopLoading];
    [view setPaymentValues:price];

}

- (void) returnOnlinePaymentError: (NSString *)error {
    [view stopLoading];
    [view showMessage:NSLocalizedString(@"Erro", @"") message:error];

}

#pragma mark - Navigation

//// In a storyboard-based application, you will often want to do a little preparation before navigation
// - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//
//    if([segue.identifier isEqualToString:@"OpenOnlinePayment"]){
//        CustomWebViewController *webController = (CustomWebViewController*) segue.destinationViewController;
//        [webController setUrl:@"https://www.google.com.br"];
//    }
// }


@end
