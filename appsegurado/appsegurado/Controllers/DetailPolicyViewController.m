//
//  DetailPolicyViewController.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 17/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "DetailPolicyViewController.h"
#import "PolicyViewController.h"
#import "ParcelsViewController.h"
#import "CoveragesViewController.h"
#import "DetailPolicyView.h"
#import "DigitableLineViewController.h"
#import "ExtractViewController.h"


@interface DetailPolicyViewController (){
    DetailPolicyView *view;
    Vision360Model *modelVision;
    PolicyModel *conn;
    PolicyBeans *currentBeans;
    BOOL showMorePolicesButton;
    ExtendParcelViewController *extends;
    DigitableLineViewController *getDigitableLine;
    PaymentPopUpViewController *paymentController;
    SecondPolicyViewController *secondPolicyController;
}

@end

@implementation DetailPolicyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    view = (DetailPolicyView*) self.view;
    
    [view loadView:currentBeans controller:self];
    
    [view hideVision];
    
    [view showLoading];
    
    modelVision = [[Vision360Model alloc] init];
    [modelVision setDelegate:self];

    
    conn = [[PolicyModel alloc] init];
    [conn setDelegate:self];
    [conn getDetailPolice:currentBeans.insurance.policy];
    self.title = NSLocalizedString(@"Apolices", @"");
   
    if(showMorePolicesButton){
        [super addLeftMenu];
    }
    [self setAnalyticsTitle:@"Detalhe da apólice"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(paymentExtendedObserver:)
                                                 name:PaymentExtendedObserver
                                               object:nil];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
  
}
-(void)dealloc{
    [conn setDelegate:nil];
    conn = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = NSLocalizedString(@"Apolices", @"");

}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    if(showMorePolicesButton){
        [view showButtonOldPolices];
//    }
}
- (IBAction)loadOldPolices:(id)sender {
    [self performSegueWithIdentifier:@"ShowOldPolices" sender:nil];
}

-(void) setInsurance:(PolicyBeans*)beans{
    currentBeans = beans;
}
-(void) showMorePolicesButton:(BOOL)show{
    showMorePolicesButton = show;
}
- (IBAction)clickCallAgent:(id)sender {
    [self doCall:((UIButton*) sender).titleLabel.text];
}


- (IBAction)clickEmailAgent:(id)sender {
    UIButton * bt = sender;
    NSString *toEmail= bt.titleLabel.text;
    //opens mail app with new email started
    NSString *email = [NSString stringWithFormat:@"mailto:%@", toEmail];
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}


- (IBAction)btShowParcels:(id)sender {
    
    
    [self performSegueWithIdentifier:@"ShowParcels" sender:sender];
}

-(void) doCall:(NSString*) number{
    NSString *condensedPhoneNumber = [[number componentsSeparatedByCharactersInSet:
                                       [[NSCharacterSet characterSetWithCharactersInString:@"+0123456789"]
                                        invertedSet]]
                                      componentsJoinedByString:@""];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",condensedPhoneNumber]]];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    self.title = @"";
    if([segue.identifier isEqualToString:@"ShowOldPolices"]){
        PolicyViewController *policy = (PolicyViewController*) segue.destinationViewController;
        [policy loadOldPolices];
    }else if([segue.identifier isEqualToString:@"ShowParcels"]){
        ParcelsViewController *parcels = (ParcelsViewController*) segue.destinationViewController;
        UIButton *btSent = (UIButton*) sender;
        [parcels setPolicy:currentBeans indexPayment:btSent.tag];
    }else if([segue.identifier isEqualToString:@"ViewCoverages"]){
        CoveragesViewController *coverages = (CoveragesViewController*) segue.destinationViewController;
        [coverages setCoveragesInsurace:currentBeans.insurance];
    }else if([segue.identifier isEqualToString:@"OpenExtract"]){
        
        ExtractViewController *extract = (ExtractViewController*) segue.destinationViewController;
        [extract setPolicy:currentBeans.insurance.policy];
        //[extractViewController showMorePolicesButton:YES];
        
    }
    
}


-(void)policyError:(NSString *)message{
    [view showMessage:NSLocalizedString(@"ErrorTitle", @"") message:message];
    
    
}

-(void)policyResultDetail:(NSArray *)arrayBeans{
    currentBeans = [arrayBeans objectAtIndex:0];
//    currentBeans.payments = newbeans.payments;
//    currentBeans.insurance = newbeans.
//    currentBeans.broker = newbeans.broker;
////    currentBeans.insuranceStatus = newbeans.insuranceStatus;
//    currentBeans.ipvaRemaining = newbeans.ipvaRemaining;
//    currentBeans.licensingRemaining = newbeans.licensingRemaining;
//    currentBeans.itens = newbeans.itens;
    [modelVision checkEvent: currentBeans.insurance.policy];
    [view loadView:currentBeans controller:self];
    [view stopLoading];
    
    
}
- (IBAction)btExtendPayment:(id)sender {
    UIButton *btExted = (UIButton*) sender;
    PaymentBeans *payment = [currentBeans.payments objectAtIndex:btExted.tag];

//    switch (payment.showComponent) {
//        case 1:
//            //Ticket
//            getDigitableLine = [[DigitableLineViewController alloc] initPaymentBeans:payment contract:currentBeans.insurance.contract issuance:[(NSNumber*)[currentBeans.insurance.issuances objectAtIndex:btExted.tag] intValue] ciaCode:currentBeans.insurance.ciaCode ClientCode:currentBeans.insurance.cifCode];
//            [self presentViewController:getDigitableLine animated:YES completion:nil];
//            break;
//        case 2:
//            extends = [[ExtendParcelViewController alloc] initPaymentBeans:payment contract:currentBeans.insurance.contract issuance:[(NSNumber*)[currentBeans.insurance.issuances objectAtIndex:btExted.tag] intValue] ciaCode:currentBeans.insurance.ciaCode ClientCode:currentBeans.insurance.cifCode];
//            [extends setDelegate:self];
//            [self presentViewController:extends animated:YES completion:nil];
//            break;
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
- (IBAction)btOpenCoverages:(id)sender {
    [self performSegueWithIdentifier:@"ViewCoverages" sender:nil];
    
}

-(IBAction)btOpenPDFPolicy:(id)sender{
    
    secondPolicyController = [[SecondPolicyViewController alloc] initPolicy:currentBeans delegate:self];
    [self presentViewController:secondPolicyController animated:YES completion:nil];
}

-(void)loadPDFViewController:(CustomWebViewController *)viewController{
    [secondPolicyController dismissViewControllerAnimated:NO completion:nil];
    self.title = @"";
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - Payment Observer and Delegate
- (void) paymentExtendedObserver:(NSNotification *) notification
{
    
    NSDictionary *userInfo = notification.userInfo;
    
    if([userInfo objectForKey:@"payment"] != [NSNull null]){
        PaymentBeans *payment = [userInfo objectForKey:@"payment"];
        [self paymentExtendedSuccessfully:payment];
    }else{
//        [self getParcels];
        [conn getDetailPolice:currentBeans.insurance.policy];
        NSLog(@"Reload Screen");
    }
//    NSDictionary *userInfo = notification.userInfo;
//    PaymentBeans *payment = [userInfo objectForKey:@"payment"];
//    [self paymentExtendedSuccessfully:payment];
    
}

-(void)paymentExtendedSuccessfully:(PaymentBeans *)beans{
    
    for (int ind = 0; ind < [currentBeans.insurance.issuances count]; ind++) {
        if([[currentBeans.insurance.issuances objectAtIndex:ind] intValue] == beans.issuance){
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


-(void) checkSuccess{
    [view showVision];
}
@end
