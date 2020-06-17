//
//  ChangePasswordViewController.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 10/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "ChangePasswordView.h"

@interface ChangePasswordViewController (){
    ChangePasswordView *view;
    ChangePasswordModel *model;
}

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    view= (ChangePasswordView*) self.view;
    [view loadView];
    self.title = NSLocalizedString(@"MeusDadosTitulo", @"");
    model = [[ChangePasswordModel alloc] init];
    [model setDelegate:self];
    [self setAnalyticsTitle:@"Troca de Senha"];
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
    
//    if([self isEmpty:[view getCPF]]){
//        [view showCpfError:NSLocalizedString(@"CPFVazioEsqueceuSenha",@"")];
//        return;
//    }
    if([self isEmpty:[view getOldPwd]]){
        [view showOldPwdError:NSLocalizedString(@"SenhaVazia",@"")];
        return;
    }

    
    if([self isEmpty:[view getNewPwd]]){
        [view showPwdError:NSLocalizedString(@"SenhaVazia",@"")];
        return;
    }
    if([self isEmpty:[view getRepatPwd]]){
        [view showRepeatPwdError:NSLocalizedString(@"SenhaVazia",@"")];
        return;
    }
//   
//    if(![model isValidPassword:[view getOldPwd]]){
//        [view showOldPwdError:NSLocalizedString(@"SenhaInvalida",@"")];
//        return;
//    }
    
   
    if(![[view getNewPwd] isEqualToString:[view getRepatPwd]]){
        [view showRepeatPwdError:NSLocalizedString(@"SenhasNaoCorrespondem",@"")];
        return;
    }
    
    if(![model isValidPassword:[view getNewPwd]]){
        [view showPwdError:NSLocalizedString(@"SenhaInvalida",@"")];
        return;
    }
    
    [view showLoading];
    
    
    [model changePassowrdOldPwd:[view getOldPwd] newPwd:[view getNewPwd]];
    
    
}
- (IBAction)btPopUpSuccess:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)passwordError:(NSString *)message{

    [view stopLoading];
    [view showMessage:NSLocalizedString(@"ErrorTitle", @"") message:message];
    
    
}

-(void)passwordChangedSuccessfully{
    [view stopLoading];
    [view showSuccessMessage];
    
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
