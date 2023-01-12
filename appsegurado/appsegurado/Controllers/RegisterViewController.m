//
//  RegisterViewController.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 29/09/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterBeans.h"
#import "AppDelegate.h"
#import <appsegurado-Swift.h>
@interface RegisterViewController (){
    FBUserBeans * currentFBUser;
    RegisterView *view;
    RegisterModel *model;
    CustomPopUpViewController *custom;
}

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    view = (RegisterView*) self.view;
    [view loadView];
    if(currentFBUser != nil){
        [view loadValuesWith:currentFBUser];
    }
    model = [[RegisterModel alloc] init];
    [model setDelegate:self];
    
    self.title = NSLocalizedString(@"TituloTelaCadastro", @"");
    if([self.navigationController.viewControllers.firstObject isKindOfClass:[RegisterViewController class]]){
        [super addLeftMenu];
    }
    
    [self setAnalyticsTitle:@"Cadastro"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.title = NSLocalizedString(@"TituloTelaCadastro", @"");
    
    if(currentFBUser.type == Apple){
        custom = [[CustomPopUpViewController alloc] initWithTitle:NSLocalizedString(@"ApplePopUpTitle", @"") text:NSLocalizedString(@"ApplePopUpText", @"") btTitle:NSLocalizedString(@"ApplePopUpButton", @"")];
        [custom addButtonActionWithTarget:self action:@selector(closePopUp) pfor:UIControlEventTouchUpInside];
        [self presentViewController:custom animated:YES completion:nil];
    }
    
}

-(void) loadWithFbUserBeans:(FBUserBeans*) fbUser{
    currentFBUser = fbUser;
}

-(void) viewWillDisappear:(BOOL)animated{
    [view unloadView];

}
-(void)dealloc{
    if(model != nil){
        [model setDelegate:nil];
        model = nil;
    }
}
#pragma mark Actions

-(void) closePopUp{
    [custom dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)viewTermsClicked:(id)sender {
    [super openTerms];
    
}
- (IBAction)registerClicked:(id)sender {
  
    
    AppDelegate *typeApolicy = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    //typeApolicy.typeApolicy
    
    NSLog(@"APOLICE  %@",[view getPolicyNumber]);
    
    NSString *apolicy = [view getPolicyNumber];
    
    if(![apolicy isEqual: @""]){
        
    NSString *codex = [[view getPolicyNumber] substringToIndex:2];
    codex = [apolicy substringWithRange: NSMakeRange(0, 2)];
    
    NSMutableArray *typePolicy = [NSMutableArray arrayWithCapacity:4];
    [typePolicy addObject:@"24"];
    [typePolicy addObject:@"26"];
    [typePolicy addObject:@"31"];
    [typePolicy addObject:@"42"];    
    
    [typePolicy addObject:@"69"];
    [typePolicy addObject:@"77"];
    [typePolicy addObject:@"80"];
    [typePolicy addObject:@"81"];
    [typePolicy addObject:@"82"];
    [typePolicy addObject:@"91"];
    [typePolicy addObject:@"93"];
    [typePolicy addObject:@"98"];
    
    [typePolicy addObject:@"14"];
    
    if (![codex isEqualToString: @"24"] &&
        ![codex isEqualToString: @"26"] &&
        ![codex isEqualToString: @"31"] &&
        ![codex isEqualToString: @"42"] &&
        [typeApolicy.typeApolicy isEqualToString:@"auto"]
        ){
        [view showPolicyError:NSLocalizedString(@"Opa! Algo está errado. Verifique as informações e tente novamente.",@"")];
        return;
    }
    
    if (![codex isEqualToString: @"69"] &&
        ![codex isEqualToString: @"77"] &&
        ![codex isEqualToString: @"80"] &&
        ![codex isEqualToString: @"81"] &&
        ![codex isEqualToString: @"82"] &&
        ![codex isEqualToString: @"91"] &&
        ![codex isEqualToString: @"93"] &&
        ![codex isEqualToString: @"98"] &&
        [typeApolicy.typeApolicy isEqualToString:@"life"]
        ){
        [view showPolicyError:NSLocalizedString(@"Opa! Algo está errado. Verifique as informações e tente novamente.",@"")];
        return;
    }
        
    if (![codex isEqualToString: @"14"] &&
        [typeApolicy.typeApolicy isEqualToString:@"home"]
        ){
        [view showPolicyError:NSLocalizedString(@"Opa! Algo está errado. Verifique as informações e tente novamente.",@"")];
            return;
        }
    }
    
    
    if([self isEmpty:[view getName]]){
        [view showNameError:NSLocalizedString(@"NomeVazio",@"")];
        return;
    }
    if([self isEmpty:[view getPolicyNumber]]){
        [view showPolicyError:NSLocalizedString(@"ApoliceVazio",@"")];
        return;
    }
    if([self isEmpty:[view getCpf]]){
        [view showCpfError:NSLocalizedString(@"CPFVazioEsqueceuSenha",@"")];
        return;
    }
    if(currentFBUser == nil){
        
        if([self isEmpty:[view getPwd]]){
            [view showPasswordError:NSLocalizedString(@"SenhaVazia",@"")];
            return;
        }
        if([self isEmpty:[view getRepeatPwd]]){
            [view showRepeatPasswordError:NSLocalizedString(@"SenhaVaziaConfirmacao",@"")];
            return;
        }
        if(![model isValidPassword:[view getPwd]]){
            [view showPasswordError:NSLocalizedString(@"SenhaInvalida",@"")];
            return;
        }
        
        if(![[view getPwd] isEqualToString:[view getRepeatPwd]]){
            [view showPasswordError:NSLocalizedString(@"SenhasNaoCorrespondem",@"")];
            [view showRepeatPasswordError:NSLocalizedString(@"SenhasNaoCorrespondem",@"")];
            return;
        }
    }
    
    if([self isEmpty:[view getEmail]]){
        [view showEmailError:NSLocalizedString(@"EmailVazioEsqueceuSenha",@"")];
        return;
    }
//    if([self isEmpty:[view getRepeatEmail]]){
//        [view showRepeatEmailError:NSLocalizedString(@"EmailVazioEsqueceuSenha",@"")];
//        return;
//    }
    
    if(![model isValidEmail:[view getEmail]]){
        [view showEmailError:NSLocalizedString(@"EmailInvalido",@"")];
        return;
    }
//    if(![[view getEmail] isEqualToString:[view getRepeatEmail]]){
//        [view showEmailError:NSLocalizedString(@"EmailsNaoCorrespondem",@"")];
//        [view showRepeatEmailError:NSLocalizedString(@"EmailsNaoCorrespondem",@"")];
//        return;
//    }

    
    // marcio
   
    
    if(![view isTermsAgreed]){
        [view showMessage:NSLocalizedString(@"TituloErroCadastro",@"") message:NSLocalizedString(@"ErroTermos",@"")];
        return;
    }
    
    RegisterBeans *beans = [[RegisterBeans alloc] init];
    [beans setName:[view getName]];
    [beans setCpf:[view getCpf]];
    [beans setPolicy:[view getPolicyNumber]];
    [beans setEmail:[view getEmail]];
    [beans setFacebookInfo:currentFBUser];
    [beans setPassword:[view getPwd]];
    [beans setTypePolice:[view getTypePolice]];
    [model verifyPolice:beans];
    [view showLoading];
}


-(BOOL) isEmpty:(NSString*)string{
    if([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]){
        return  true;
    }
    return false;
}



#pragma mark Model Delegates
-(void)registerError:(NSString *)message{
    [view stopLoading];
    [view showMessage:NSLocalizedString(@"TituloErroCadastro",@"") message:message];

}
- (IBAction)btSendEmail:(id)sender {
    [view showLoading];
    RegisterBeans *beans = [[RegisterBeans alloc] init];
    [beans setName:[view getName]];
    [beans setCpf:[view getCpf]];
    [beans setPolicy:[view getPolicyNumber]];
    [beans setEmail:[view getEmail]];
    [beans setFacebookInfo:currentFBUser];
    [beans setPassword:[view getPwd]];
    [beans setTypePolice:[view getTypePolice]];
    [model sendActiveEmail:beans];
}
- (IBAction)btOkEntendi:(id)sender {
    AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    [appDelegate setGotoLoginView:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)registeredSucessfully{
    [view stopLoading];
    [view showSuccessMessage];
//    [self presentViewController:[view showSuccessMessageTitle:NSLocalizedString(@"Sucesso", @"") message:NSLocalizedString(@"CadastroSucesso", @"") handler:^(UIAlertAction *action) {
//        [self performSegueWithIdentifier:@"OpenAfterLogin" sender:nil];
//        [self.navigationController popToRootViewControllerAnimated:NO];
//
//
//    }] animated:YES completion:nil];
    
}

-(void)registeredWithLoginError:(NSString *)message{
    [view stopLoading];
    [view showMessage:NSLocalizedString(@"ErrorTitle",@"") message:message];

}

-(void)emailSent{
    [view stopLoading];
//    [view showMessage:NSLocalizedString(@"Sucesso",@"") message:NSLocalizedString(@"EmailSent", @"")];
    [view showSuccessMessage];
}
-(void)userInactiveError:(NSString *)message beans:(RegisterBeans*)beans{
    [view stopLoading];
    
    UIAlertController * controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"ErrorTitle",@"") message:message preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"Sim", "") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [view showLoading];
        [model sendActiveEmail:beans];
        [controller dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [controller addAction:action];
    
    
    UIAlertAction *actionNo = [UIAlertAction actionWithTitle:NSLocalizedString(@"Nao", "") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [controller dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [controller addAction:actionNo];
    [self presentViewController:controller animated:YES completion:nil];
    
}

-(void)verifyDuplicated:(NSString *)message couldChangeInput:(bool)couldChange{
    [view stopLoading];
    
    UIAlertController * controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"ErrorTitle",@"") message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if(couldChange && currentFBUser == nil){
        [view showEmailError:NSLocalizedString(@"EmailCadastrado", @"")];
        UIAlertAction *actionChange = [UIAlertAction actionWithTitle:NSLocalizedString(@"AlterarDados", "") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [controller dismissViewControllerAnimated:YES completion:nil];
        }];
        [controller addAction:actionChange];
    }
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"IrLogin", "") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [controller dismissViewControllerAnimated:YES completion:nil];
        AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        [appDelegate setGotoLoginView:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [controller addAction:action];
    [self presentViewController:controller animated:YES completion:nil];
    
}
@end
