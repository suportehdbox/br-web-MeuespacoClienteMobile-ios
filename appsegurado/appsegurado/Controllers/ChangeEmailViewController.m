//
//  ChangeEmailViewController.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 11/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "ChangeEmailViewController.h"
#import "ChangeEmailView.h"
#import "AppDelegate.h"

@interface ChangeEmailViewController (){
    ChangeEmailView * view;
    ChangeEmailModel * model;
}

@end

@implementation ChangeEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    view= (ChangeEmailView*) self.view;
    [view loadView];
    self.title = NSLocalizedString(@"MeusDadosTitulo", @"");
    model = [[ChangeEmailModel alloc] init];
    [model setDelegate:self];
    [self setAnalyticsTitle:@"Troca de Email"];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = NSLocalizedString(@"MeusDadosTitulo", @"");
}
- (IBAction)sendChange:(id)sender {
    
  
    if([self isEmpty:[view getEmail]]){
        [view showEmailError:NSLocalizedString(@"EmailVazioEsqueceuSenha",@"")];
        return;
    }
    if([self isEmpty:[view getRepeatEmail]]){
        [view showRepeatEmailError:NSLocalizedString(@"EmailVazioEsqueceuSenha",@"")];
        return;
    }
    
    if(![[view getRepeatEmail] isEqualToString:[view getEmail]]){
        [view showEmailError:NSLocalizedString(@"EmailsNaoCorrespondemTroca",@"")];
        [view showRepeatEmailError:NSLocalizedString(@"EmailsNaoCorrespondemTroca",@"")];
        return;
    }
    
    if(![model isValidEmail:[view getEmail]]){
        [view showEmailError:NSLocalizedString(@"EmailInvalido",@"")];
        return;
    }
    
    [view showLoading];
    
    
    [model changeEmail:[view getEmail]];
    
    
}
- (IBAction)btPopUpSuccess:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)emailError:(NSString *)message{
    
    [view stopLoading];
    [view showMessage:NSLocalizedString(@"ErrorTitle", @"") message:message];
    
    
}

-(void)emailChangedSuccessfully{
    [view stopLoading];
    [view showSuccessMessage];
    AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    [[appDelegate getLoggeduser] setEmailCpf:[view getEmail]];
    
}

-(BOOL) isEmpty:(NSString*)string{
    if([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]){
        return  true;
    }
    return false;
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
