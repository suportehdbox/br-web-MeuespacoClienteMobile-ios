//
//  HomeViewController.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 05/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeView.h"
#import "DetailPolicyViewController.h"
#import "DigitableLineViewController.h"
#import "AppDelegate.h"
#import "ParcelsViewController.h"
#import "ParcelsViewController.h"
#import "ExtractViewController.h"
#import <appsegurado-Swift.h>

@interface HomeViewController (){
    HomeModel *model;
    HomeView *view;
    PolicyModel *policyModel;
    PolicyBeans *currentBeans;
    Vision360Model *modelVision;
    ExtendParcelViewController *extends;
    DigitableLineViewController *getDigitableLine;
    PaymentPopUpViewController *paymentController;
    ExtractViewController *extractViewController;
    HomeAssistWebViewController *wvc;
    BOOL isOpenPayments;
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super addLeftMenu];
    view = (HomeView*) self.view;
    [view loadView:nil controller:self];
    
    [view hideVision];
    
    model = [[HomeModel alloc] init];
    
    modelVision = [[Vision360Model alloc] init];
    [modelVision setDelegate:self];
    
    policyModel = [[PolicyModel alloc] init];
    [model setDelegate:self];
    [policyModel setDelegate:self];
    
    [model askToUseTouchId];
    
    
    [model getHome];
    
    isOpenPayments = false;
    
    [self setAnalyticsTitle:@"Home Logado"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(paymentExtendedObserver:)
                                                 name:PaymentExtendedObserver
                                               object:nil];
    
    // Do any additional setup after loading the view.
    
    //[self performSegueWithIdentifier:@"OpenExtract" sender:nil];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.title = NSLocalizedString(@"TituloHomeDeslogada", @"");
    [view loadViewAfterAppeared];
    
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.title = @"";
}
-(void)dealloc{
    [model setDelegate:nil];
    model = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//-(void)homeSuccess:(InsuranceBeans *)beans{
//    [policyModel getUserPolices:YES];
//    [view loadView:beans];
//    currentBeans = beans;
//}

-(void)homeSuccessV2:(PolicyBeans *)beans{
    [policyModel getUserPolices:YES];
    [view loadView:beans controller:self];
    currentBeans = beans;
    [modelVision checkEvent: currentBeans.insurance.policy];
    
    AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    [appDelegate setHas_auto_policy:currentBeans.insurance.isAutoPolicy];
    
}

-(void) checkSuccess{
    [view showVision];
}

- (void)paymentsSuccess:(PolicyBeans *)beans{
    currentBeans = beans;
    
    [view displayPaymentInformation:currentBeans];
    [view expandPayments:YES loading:NO];
}

-(void) homeError:(NSString *)message{
    [view showMessage:NSLocalizedString(@"ErrorTitle", @"") message:message];
    
    UIAlertController *controller = [view showTryAgainMessageHandler:^(UIAlertAction *action) {
        [model getHome];
    } handlerNo:^(UIAlertAction *actionNo) {
        //
        //        [view showButonOldPolices:NO];
        [view hideScrollView];
        [view showErrorLoadingMessage];
        [view stopLoading];
        
    }];
    [self presentViewController:controller animated:YES completion:nil];
}


-(void)policyError:(NSString *)message{
    
    //do nothing here
}

-(void)policyResult:(NSArray *)arrayBeans{
    
    if([arrayBeans count] > 1){
        [view showMorePolicesButton];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"ShowDetailPolicy"]){
        PolicyBeans *beans = (PolicyBeans*) sender;
        DetailPolicyViewController *destiny = (DetailPolicyViewController*) segue.destinationViewController;
        [destiny setInsurance:beans];
        [destiny showMorePolicesButton:YES];
    }else if([segue.identifier isEqualToString:@"ShowParcels"]){
        ParcelsViewController *parcels = (ParcelsViewController*) segue.destinationViewController;
        UIButton *btSent = (UIButton*) sender;
        [parcels setPolicy:currentBeans indexPayment:(int) btSent.tag];
        
    }    if([segue.identifier isEqualToString:@"OpenExtract"]){
        
        ExtractViewController *extract = (ExtractViewController*) segue.destinationViewController;
        [extract setPolicy:currentBeans.insurance.policy];
        //[extractViewController showMorePolicesButton:YES];
        
    }
    
    
}


- (IBAction)showPolicyDetail:(id)sender {
    [self performSegueWithIdentifier:@"ShowDetailPolicy" sender:currentBeans];
}
- (IBAction)showClub:(id)sender {
    [self performSegueWithIdentifier:@"ShowClub" sender:nil];
}


- (IBAction)openExtendPayment:(id)sender {
    UIButton *btExted = (UIButton*) sender;
    if(currentBeans.payments == nil || btExted.tag >= [currentBeans.payments count]){
        return;
    }
    
    PaymentBeans *payment = [currentBeans.payments objectAtIndex:btExted.tag];
    //    switch (payment.showComponent) {
    //        case 1:
    //            //Ticket
    //            getDigitableLine = [[DigitableLineViewController alloc] initPaymentBeans:payment contract:currentBeans.insurance.contract issuance:[(NSNumber*)[currentBeans.insurance.issuances objectAtIndex:btExted.tag] intValue] ciaCode:currentBeans.insurance.ciaCode ClientCode:currentBeans.insurance.cifCode];
    //            [self presentViewController:getDigitableLine animated:YES completion:nil];
    //        break;
    //        case 2:
    //            extends = [[ExtendParcelViewController alloc] initPaymentBeans:payment contract:currentBeans.insurance.contract issuance:[(NSNumber*)[currentBeans.insurance.issuances objectAtIndex:btExted.tag] intValue] ciaCode:currentBeans.insurance.ciaCode ClientCode:currentBeans.insurance.cifCode];
    //            [extends setDelegate:self];
    //            [self presentViewController:extends animated:YES completion:nil];
    //        break;
    //        default:
    //            break;
    //    }
    
    if(payment.showComponent > 0){
        paymentController = [[PaymentPopUpViewController alloc] initPaymentBeans:payment contract:currentBeans.insurance.contract issuance:[(NSNumber*)[currentBeans.insurance.issuances objectAtIndex:btExted.tag] intValue] ciaCode:currentBeans.insurance.ciaCode  ClientCode:currentBeans.insurance.cifCode issuingAgency:currentBeans.insurance.issuingAgency];
        [paymentController setDelegate:self];
        [self presentViewController:paymentController animated:YES completion:nil];
        //            [self.navigationController pushViewController:paymentController animated:NO];
    }
    
    
    
}

-(IBAction)expandColapse:(id)sender{
    
    if([[currentBeans payments] count] <= 0 ){
        isOpenPayments = true;
        [model getPaymentInfo];
        [view expandPayments:isOpenPayments loading:TRUE];
        return;
    }
    
    isOpenPayments = !isOpenPayments;
    
    [view expandPayments:isOpenPayments loading:false];
}

-(IBAction) openParcels:(id)sender{
    [self performSegueWithIdentifier:@"ShowParcels" sender:sender];
}

- (void)openHomeAssist:(id)sender{
    if([currentBeans.insurance isAutoPolicy]){
        [self performSegueWithIdentifier:@"ShowHomeAssists" sender:sender];
    }else{
        if(wvc == nil){
            wvc = [[HomeAssistWebViewController alloc] init];
        }
        [self.navigationController pushViewController:wvc animated:YES];
    }
    
}


#pragma mark - Payment Observer and Delegate
- (void) paymentExtendedObserver:(NSNotification *) notification
{
    
    //    NSDictionary *userInfo = notification.userInfo;
    //    PaymentBeans *payment = [userInfo objectForKey:@"payment"];
    //
    //    [self paymentExtendedSuccessfully:payment];
    
    
    
    NSDictionary *userInfo = notification.userInfo;
    
    if([userInfo objectForKey:@"payment"] != [NSNull null]){
        PaymentBeans *payment = [userInfo objectForKey:@"payment"];
        [self paymentExtendedSuccessfully:payment];
    }else{
        //[self getParcels];
        [model getHome];
        NSLog(@"Reload Screen");
    }
    
    
}
-(void)paymentExtendedSuccessfully:(PaymentBeans *)beans{
    
    for (int ind = 0; ind < [currentBeans.insurance.issuances count]; ind++) {
        if([[currentBeans.insurance.issuances objectAtIndex:ind] intValue] == beans.issuance){
            if(currentBeans.payments == nil || [currentBeans.payments count] == 0){
                return;
            }
            
            PaymentBeans *payment = [currentBeans.payments objectAtIndex:ind];
            if(payment.number == beans.number){
                [payment setCanExtend:NO];
                [payment setStatus:3];
                [payment setShowComponent:1];
                [payment setDueDate:beans.dueDate];
                [payment setAmountPayable:beans.amountPayable];
                [currentBeans.payments setObject:payment atIndexedSubscript:ind];
                [view loadView:currentBeans controller:self];
            }
        }
    }
}

-(void)openWebView:(UIViewController *)viewController{
    [paymentController dismissViewControllerAnimated:YES completion:^{
        [self.navigationController pushViewController:viewController animated:YES];
    }];
    
}

@end
