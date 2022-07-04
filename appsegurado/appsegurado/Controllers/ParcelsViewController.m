//
//  ParcelsViewController.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 26/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "ParcelsViewController.h"
#import "ParcelsView.h"
#import "DigitableLineViewController.h"
#import "QrCodePixViewController.h"



@interface ParcelsViewController () {
    ParcelsView * view;
    PolicyModel * conn;
    PaymentModel * model;
    PolicyBeans * currentBeans;
    ExtendParcelViewController * extends;
    NSArray * parcels;
    int indexPayment;
    DigitableLineViewController * getDigitableLine;
    PaymentPopUpViewController * paymentController;
    QrCodePixViewController * pixQrCodeController;
}

@end

@implementation ParcelsViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    view = (ParcelsView *)self.view;
    [view loadView];

    conn = [[PolicyModel alloc] init];
    [conn setDelegate:self];
    [self getParcels];

    model = [[PaymentModel alloc] init];
    [model setDelegate:self];

    self.title = NSLocalizedString(@"Apolices", @"");

    [self setAnalyticsTitle:@"Parcelas"];

    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(paymentExtendedObserver:)
                                                 name:PaymentExtendedObserver
                                               object:nil];

    // Do any additional setup after loading the view.
} /* viewDidLoad */

- (void) setPolicy: (PolicyBeans *)beans indexPayment: (int)index {
    indexPayment = index;
    currentBeans = beans;
}

- (void) getParcels {
    NSNumber * issuance = [currentBeans.insurance.issuances objectAtIndex:indexPayment];

    [conn getParcels:currentBeans.insurance.contract
            issuance:[issuance intValue]
             ciaCode:currentBeans.insurance.ciaCode];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear: (BOOL)animated {
    [super viewDidAppear:animated];
    self.title = NSLocalizedString(@"Apolices", @"");
}

- (void) viewWillDisappear: (BOOL)animated {
    [super viewWillDisappear:animated];
    self.title = @"";
}

- (void) dealloc {
    if (conn != nil) {
        [conn setDelegate:nil];
        conn = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSInteger) numberOfSectionsInTableView: (UITableView *)tableView {
    return [view numberOfSectionsInTableView:tableView];
}

- (NSInteger) tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger)section {
    return [view tableView:tableView numberOfRowsInSection:section];
}

- (UIView *) tableView: (UITableView *)tableView viewForHeaderInSection: (NSInteger)section {
    return [view tableView:tableView viewForHeaderInSection:section];
}
- (CGFloat) tableView: (UITableView *)tableView heightForHeaderInSection: (NSInteger)section {
    return [view tableView:tableView heightForHeaderInSection:section];
}
- (CGFloat) tableView: (UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *)indexPath {
    return [view tableView:tableView heightForRowAtIndexPath:indexPath];
}
// -(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return [view tableView:tableView heightForFooterInSection:section];
// }
- (UITableViewCell *) tableView: (UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath {
    return [view tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void) tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath {
    if (indexPath.row > 0) {
        PaymentBeans * payment = [parcels objectAtIndex:indexPath.row - 1];
        if (payment.showComponent > 0) {
            paymentController = [
                [PaymentPopUpViewController alloc]
                initPaymentBeans:payment
                        contract:currentBeans.insurance.contract
                        issuance:[(NSNumber *)[currentBeans.insurance.issuances objectAtIndex:indexPayment] intValue]
                         ciaCode:currentBeans.insurance.ciaCode
                      ClientCode:currentBeans.insurance.cifCode
                   issuingAgency:currentBeans.insurance.issuingAgency];
            [paymentController setDelegate:self];
            [self presentViewController:paymentController animated:YES completion:nil];
        }
    }
} /* tableView */


- (void) policyPaymentResult: (NSArray *)arrayBeans {
    parcels = arrayBeans;
    [view loadParcels:arrayBeans];

}

- (void) policyError: (NSString *)message {
    [view showMessage:NSLocalizedString(@"ErrorTitle", @"") message:message];

    UIAlertController * controller = [view showTryAgainMessageHandler:^(UIAlertAction * action) {
                                          [self getParcels];
                                      } handlerNo:^(UIAlertAction * actionNo) {
                                          [self.navigationController popViewControllerAnimated:YES];
                                      }];

    [self presentViewController:controller animated:YES completion:nil];

}

#pragma mark - Delegate

#pragma mark - Payment Observer and Delegate
- (void) paymentExtendedObserver: (NSNotification *)notification
{
    NSDictionary * userInfo = notification.userInfo;

    if ([userInfo objectForKey:@"payment"] != [NSNull null]) {
        PaymentBeans * payment = [userInfo objectForKey:@"payment"];
        [self paymentExtendedSuccessfully:payment];
    } else {
        [self getParcels];
    }


}
- (void) paymentExtendedSuccessfully: (PaymentBeans *)beans {
    for (PaymentBeans * parcel in parcels) {
        if (parcel.number == beans.number) {

            [parcel setCanExtend:NO];
            [parcel setStatus:3];
            [parcel setShowComponent:1];
            [parcel setDueDate:beans.dueDate];
            [parcel setAmountPayable:beans.amountPayable];

        }
    }
    [view loadParcels:parcels];
}

- (void) returnPaymentLine: (NSString *)message {
    UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];

    [pasteboard setString:message];
    [view showBarCode:message];
}
- (void) paymentLineFailed: (NSString *)message {
    [view hideBarCode];
    [view showMessage:NSLocalizedString(@"ErrorTitle", @"") message:message];
}


- (void) openWebView: (UIViewController *)viewController {
    [paymentController dismissViewControllerAnimated:YES completion:^{
         [self.navigationController pushViewController:viewController animated:YES];
     }];

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void) prepareForSegue: (UIStoryboardSegue *)segue sender: (id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

}


@end
