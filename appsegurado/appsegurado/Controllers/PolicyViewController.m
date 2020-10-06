//
//  PolicyViewController.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 13/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "PolicyViewController.h"
#import "PolicyView.h"
#import "DetailPolicyViewController.h"
#import "ClaimViewController.h"
#import "InsuranceItensBeans.h"
#import "DocumentsViewController.h"
#import "Open24AssistViewController.h"
#import "AppDelegate.h"
#import "CustomWebViewController.h"
#import <appsegurado-Swift.h>

@interface PolicyViewController(){
    PolicyView * view;
    PolicyModel *model;
    ClaimModel *claimModel;
    NSDictionary*dicClaim;
    BOOL firstLoad;
    BOOL onlyOnePolicy;
    BOOL oldPolices;
    BOOL claimPolices;
    BOOL documentsPolices;
    BOOL assist24hs;
    NSString *textTitle;
    CustomWebViewController *customWebView;
    
}
@end
@implementation PolicyViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    if(!oldPolices){
        [super addLeftMenu];
    }
    firstLoad = true;
    view = (PolicyView *) self.view;
    [view loadView];

    if(claimPolices){
        claimModel = [[ClaimModel alloc] init];
        [claimModel setDelegate:self];
        [claimModel getPolicyItens:dicClaim];
        [self setAnalyticsTitle:@"Acompanhar Sinistro"];
    }else{
        model = [[PolicyModel alloc] init];
        [model setDelegate:self];
        [model setOnlyReturnAutoPolices:claimPolices];
        [model getUserPolices:!oldPolices];
        onlyOnePolicy = false;
        [self setAnalyticsTitle:@"Lista de Apólices"];
    }
    if(textTitle != nil && ![textTitle isEqualToString:@""]){
        [view setTitleTable:textTitle];
    }
    self.title = NSLocalizedString(@"Apolices", @"");
    
    // Do any additional setup after loading the view.
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.title = NSLocalizedString(@"Apolices", @"");
    
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
    if(claimModel != nil){
        [claimModel setDelegate:nil];
        claimModel = nil;
    }
    
}
-(void) loadOldPolices{
    oldPolices = YES;
}

-(void) loadPolicesFromClaim{
    claimPolices = true;
    oldPolices = NO;
}
-(void) loadPolicesFromClaimOff:(NSString*)platePolicy cpf:(NSString*)cpf{
    claimPolices = true;
    oldPolices = NO;
    dicClaim = [[NSDictionary alloc] initWithObjectsAndKeys:platePolicy,@"platePolicy", cpf, @"cpf", nil];
}

-(void) set24hsAssist{
    assist24hs = true;
}
-(void) loadPolicesFromDocuments{
    claimPolices = false;
    oldPolices = NO;
    documentsPolices = true;
}
-(void) setTitleTable:(NSString*) text{
    textTitle = text;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [view numberOfSectionsInTableView:tableView];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [view tableView:tableView numberOfRowsInSection:section];
}

//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    return [view tableView:tableView viewForFooterInSection:section];
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [view tableView:tableView viewForHeaderInSection:section];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [view tableView:tableView heightForHeaderInSection:section];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [view tableView:tableView heightForRowAtIndexPath:indexPath];
}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return [view tableView:tableView heightForFooterInSection:section];
//}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [view tableView:tableView cellForRowAtIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    InsuranceBeans *beans = [view getInsuranceClickedAtIndexPath:indexPath];
    if(beans != nil){
        if(claimPolices){
            //OpenClaim
            if(assist24hs){
//                [self performSegueWithIdentifier:@"Open24Assist" sender:beans];
                [self openNewAsssit:beans];
            }else{
                if([Config newClaimEnable]){
                    AutoClaimWebViewController *claim = [[AutoClaimWebViewController alloc] init];
                    [claim setInsuranceBeans:beans];
                    self.title = @"";
                    [self.navigationController pushViewController:claim animated:YES];
                }else{
                    [self performSegueWithIdentifier:@"OpenClaim" sender:beans];
                }
            }
            
        }else if(documentsPolices){
            [self performSegueWithIdentifier:@"PolicyDocuments" sender:beans];
        }else{
            [self performSegueWithIdentifier:@"ShowDetailPolicy" sender:beans];
        }
    }
    
}

-(void)policyItens:(NSMutableArray *)arrayItens{
    firstLoad = false;
    
        [view loadPolicies:arrayItens];
        if(documentsPolices){
            [view showButonOldPolices:NO];
        }else if(!claimPolices){
            [view showButonOldPolices:!oldPolices];
        }else{
            [view showButonOldPolices:NO];
        }
    
    if([arrayItens count] <= 0){
        [view showLoadingMessage:NSLocalizedString(@"NenhumaApoliceEncontrada", @"")];
    }

}

-(void)policyResult:(NSArray *)arrayBeans{
    firstLoad = false;
    
    if([arrayBeans count] > 1 || oldPolices || documentsPolices){
        [view loadPolicies:arrayBeans];
        if(documentsPolices){
            [view showButonOldPolices:NO];
        }else if(!claimPolices){
            [view showButonOldPolices:!oldPolices];
        }else{
            [view showButonOldPolices:NO];
        }
    }else{
        onlyOnePolicy = true;
        InsuranceBeans *beans = [arrayBeans objectAtIndex:0];
        [self performSegueWithIdentifier:@"ShowDetailPolicyOneItem" sender:beans];
    }
}
-(void) claimError:(NSString *)msg{
    [view showMessage:NSLocalizedString(@"ErrorTitle", @"") message:msg];
    [view loadPolicies:[[NSArray alloc] init]];
    [view showButonOldPolices:NO];
    UIAlertController *controller = [view showTryAgainMessageHandler:^(UIAlertAction *action) {
        [claimModel getPolicyItens:dicClaim];
    } handlerNo:^(UIAlertAction *actionNo) {
        //
        [view showLoadingMessage:msg];
    }];
    [self presentViewController:controller animated:YES completion:nil];
}
-(void)policyError:(NSString *)message{
    
    if(firstLoad){
        if(oldPolices){
            UIAlertController *controller = [view showSuccessMessageTitle:NSLocalizedString(@"ErrorTitle", @"") message:message handler:^(UIAlertAction *action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [self presentViewController:controller animated:YES completion:nil];
        }else{
            [view showMessage:NSLocalizedString(@"ErrorTitle", @"") message:message];
            UIAlertController *controller = [view showTryAgainMessageHandler:^(UIAlertAction *action) {
                [model getUserPolices:YES];
            } handlerNo:^(UIAlertAction *actionNo) {
                //
                [view showButonOldPolices:NO];
            }];
            [self presentViewController:controller animated:YES completion:nil];        
        }
    }else{
        [view showMessage:NSLocalizedString(@"ErrorTitle", @"") message:message];
        [view showButonOldPolices:YES];
    }
}

- (IBAction)clickLoadOldPolicy:(id)sender {
    NSLog(@"Clicou!");
    //UIButton *bt = (UIButton*) sender;
    oldPolices = YES;
    [view showLoadingMorePolices];
    [model getUserPolices:!oldPolices];
}



 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     self.title = @"";
     if([segue.identifier isEqualToString:@"ShowDetailPolicy"]){
        InsuranceBeans *beans = (InsuranceBeans*) sender;
        DetailPolicyViewController *destiny = (DetailPolicyViewController*) segue.destinationViewController;
        PolicyBeans *policy = [[PolicyBeans alloc] init];
        [policy setInsurance:beans];
        [destiny setInsurance:policy];
        [destiny showMorePolicesButton:onlyOnePolicy];
     }else if([segue.identifier isEqualToString:@"ShowDetailPolicyOneItem"]){
         InsuranceBeans *beans = (InsuranceBeans*) sender;
         UINavigationController *nav = (UINavigationController*) segue.destinationViewController;
         DetailPolicyViewController *destiny = (DetailPolicyViewController*) nav.topViewController;
         PolicyBeans *policy = [[PolicyBeans alloc] init];
         [policy setInsurance:beans];
         [destiny setInsurance:policy];
         [destiny showMorePolicesButton:onlyOnePolicy];
     
     }else if([segue.identifier isEqualToString:@"OpenClaim"]){
         InsuranceBeans *beans = (InsuranceBeans*) sender;
         
             
             ClaimViewController *destiny = (ClaimViewController*) segue.destinationViewController;
             [destiny setInsurance:beans cpf:[dicClaim objectForKey:@"cpf"]];
         
     }else if([segue.identifier isEqualToString:@"PolicyDocuments"]){
         InsuranceBeans *beans = (InsuranceBeans*) sender;
         DocumentsViewController *destiny = (DocumentsViewController*) segue.destinationViewController;
         [destiny setPolicyNumber:beans.policy];
         
     }else if([segue.identifier isEqualToString:@"Open24Assist"]){
         InsuranceBeans *beans = (InsuranceBeans*) sender;
         Open24AssistViewController *destiny = (Open24AssistViewController*) segue.destinationViewController;
         [destiny setPlate:beans.licensePlate];
         
     }
     //Open24Assist
     
     //PolicyDocuments
 }


-(void)openNewAsssit:(InsuranceBeans*) beans{
    
//    NSUserDefaults *defaults  = [NSUserDefaults standardUserDefaults];
//    AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
//
//    NSString *cpf = @"";
//    if(dicClaim == nil){
//        cpf = [appDelegate getCPF];
//    }else{
//        cpf = [dicClaim objectForKey:@"cpf"];
//    }
//
//    while([cpf length] < 11){
//        cpf = [NSString stringWithFormat:@"0%@",cpf];
//    }
//
//    [defaults setValue:cpf forKey:@"DirectAssistCPF"];
//    [defaults setValue:beans.licensePlate forKey:@"DirectAssistPlate"];
//    [defaults setValue:@"" forKey:@"DirectAssistChassi"];
//    [defaults synchronize];
//
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"DirectAssist" bundle:[NSBundle bundleForClass:[CallHelpViewController class]]];
//    CallHelpViewController *directAssist = (CallHelpViewController*) [sb instantiateViewControllerWithIdentifier:@"CallHelpViewController"];
//
//    [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(repaint) userInfo:nil repeats:NO];
//    [self.navigationController pushViewController:directAssist animated:YES ];
    if(!claimModel){
        claimModel = [[ClaimModel alloc] init];
    }
 
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?plate=%@",[claimModel getFacilAssist], beans.licensePlate]];
    customWebView = [[CustomWebViewController alloc] initWithAssistWithRequest:[NSURLRequest requestWithURL:url]];
    
    [self.navigationController pushViewController:customWebView animated:YES];
}


-(void) repaint{
    self.navigationController.navigationBar.barTintColor = [BaseView getColor:@"NavBarCollor"];
}


@end
