//
//  ForgotPasswordViewController.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 29/09/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "ForgotPasswordView.h"

@interface ForgotPasswordViewController (){
    ForgotPasswordView *view;
    ForgotPasswordModel *model;
}

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    model = [[ForgotPasswordModel alloc] init];
    [model setDelegate:self];
    
    view = (ForgotPasswordView*) self.view;
    [view loadView];
    
    self.title = NSLocalizedString(@"TituloEsqueciSenha", @"");
    
    [self setAnalyticsTitle:@"Esqueceu a senha"];
    // Do any additional setup after loading the view.
}
-(void) viewWillDisappear:(BOOL)animated{
    [view unloadView];
    self.title = @"";
    
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = NSLocalizedString(@"TituloEsqueciSenha", @"");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (IBAction)requestFogotPassword:(id)sender {

    if([[[view getCpf] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]){
        [view showCpfError:NSLocalizedString(@"CPFVazioEsqueceuSenha", @"")];
        return;
    }
    if([[[view getEmail] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]){
        [view showEmailError:NSLocalizedString(@"EmailVazioEsqueceuSenha", @"")];
        return;
    }
    
    if(![model validateCPFWithNSString:[view getCpf]]){
        //CPF invalid
        [view showCpfError:NSLocalizedString(@"CPFInvalido", @"")];
        return;
    }
    
    if(![model isValidEmail:[view getEmail]]){
        //Email invalid
        [view showEmailError:NSLocalizedString(@"EmailInvalido", @"")];
        return;
    }
    
    [view showLoading];
    [model requestNewPassword:[view getEmail] cpf:[view getCpf]];

}

-(IBAction)privacyButtonClicked:(id)sender{
    [super openTerms];
}

#pragma mark - Model Delegate
-(void)forgotSuccess{
    [view stopLoading];
    
    [self presentViewController:[view showSuccessMessageTitle:NSLocalizedString(@"Sucesso", @"") message:NSLocalizedString(@"SenhaEviada", @"") handler:^(UIAlertAction *action) {
        [self.navigationController popViewControllerAnimated:YES];
    }] animated:YES completion:nil];
    
}


-(void)forgotError:(NSString *)message{
    [view stopLoading];
    [view showMessage:NSLocalizedString(@"ErrorTitle",@"") message:message];
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
