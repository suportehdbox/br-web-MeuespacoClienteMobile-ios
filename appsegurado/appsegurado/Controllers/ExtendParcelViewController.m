//
//  ExtendParcelViewController.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 27/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "ExtendParcelViewController.h"
#import "ExtendParcelView.h"

@interface ExtendParcelViewController (){
    
    ExtendParcelView *view;
    
    PaymentModel *model;
    PaymentBeans *currentPayment;
    long currentContract;
    long currentIssuance;
    int currentCiaCode;
    long currentClientCode;
    NSString *urlDownload;

}

@end

@implementation ExtendParcelViewController
@synthesize delegate;
- (id)initPaymentBeans:(PaymentBeans*)beans contract:(long) contract issuance:(int) issuance ciaCode:(int)ciaCode
            ClientCode:(long)clientCode;
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    self = [storyboard instantiateViewControllerWithIdentifier:@"ExtendParcelController"];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    view = (ExtendParcelView*) self.view;
    
    
    model = [[PaymentModel alloc] init];
    [model setDelegate:self];
    
    [view loadView];
    
    [self startSimulating];
    
    [self setAnalyticsTitle:@"Prorrogar Parcela"];
    // Do any additional setup after loading the view.
}


-(void) startSimulating{
    [view showLoading];
    [model simulatePaymentNumber:currentPayment.number contract:currentContract issuance:(int)currentIssuance ciaCode:currentCiaCode ClientCode:currentClientCode typoPayment:currentPayment.codigoTipoModalidadeCobranca];

    //comentar as linhas a cima e descomentar as linhas abaixo para simular uma prorrogação de parcela com sucesso
//    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
//    [nf setLocale:[NSLocale localeWithLocaleIdentifier:@"pt_BR"]];
//    [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
//    
//    [self extendedPaymentDate:@"10/12/2016" value:[nf stringFromNumber:@2600.30]];
//    [self extendedPaymentSuccessfully:@"10499.71201 22517.712125 31524.656514 3 70240000010000"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    if(model != nil){
        [model setDelegate:nil];
        model = nil;
    }
}
- (IBAction)btAgreeClicked:(id)sender {
    [view showLoading];
    [model postPonePaymentNumber:currentPayment.number contract:currentContract issuance:(int)currentIssuance ciaCode:currentCiaCode ClientCode:currentClientCode typoPayment:currentPayment.codigoTipoModalidadeCobranca];

}
- (IBAction)btCancelClicled:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btOpenPdf:(id)sender {
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlDownload]];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = urlDownload;
    
    UIAlertController *alert = [view showSuccessMessageTitle:NSLocalizedString(@"TextoCopiado", @"") message:@"" handler:^(UIAlertAction *action) {
    }];
    [self presentViewController:alert animated:YES completion:nil];

}

- (IBAction)btOkClicked:(id)sender {
    [self btCancelClicled:nil];
}

-(void) setPaymentBeans:(PaymentBeans*)beans{
    currentPayment = beans;
}


-(void)extendedPaymentFailed:(NSString *)message{
    [view hidePopUp];
    UIAlertController *alert = [view showSuccessMessageTitle:NSLocalizedString(@"AvisoProrrogar", @"") message:message handler:^(UIAlertAction *action) {
        [self btCancelClicled:nil];
    }];
    [self presentViewController:alert animated:YES completion:nil];

}

-(void)extendedPaymentDate:(NSString *)date value:(NSString *)value{
    [view setDate:date setValue:value];
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    [nf setLocale:[NSLocale localeWithLocaleIdentifier:@"pt_BR"]];
    [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSNumber *number = [nf numberFromString:value];
    [currentPayment setAmountPayable:[number floatValue]];
    
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"dd/MM/yyyy"];
    NSDate *dueDate = [dateformat dateFromString:date];
    [dateformat setTimeZone:[NSTimeZone localTimeZone]];
    [dateformat setLocale:[NSLocale localeWithLocaleIdentifier:@"pt_BR"]];
    [dateformat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    [currentPayment setDueDate:[dateformat stringFromDate:dueDate]];
    [view stopLoading];
}

- (IBAction)showTerms:(id)sender {
    
    [view showMessage:@"" message:NSLocalizedString(@"TermosProrrogarPopUp", @"")];
}

-(void)extendedPaymentSuccessfully:(NSString *)url{
    urlDownload = url;
    [super sendActionEvent:@"Retorno" label:@"Reprogramar Parcela"];
    [view stopLoading];
    [view showPopUpSuccessfull:url];
    if(delegate != nil && [delegate respondsToSelector:@selector(paymentExtendedSuccessfully:)]){
        [delegate paymentExtendedSuccessfully:currentPayment];
    }
    
    dispatch_async(dispatch_get_main_queue(),^{
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:currentPayment forKey:@"payment"];
        [[NSNotificationCenter defaultCenter] postNotificationName: PaymentExtendedObserver object:nil userInfo:userInfo];
    });
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
