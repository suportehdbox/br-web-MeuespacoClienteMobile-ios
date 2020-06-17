//
//  LoginViewController.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 26/09/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "AppDelegate.h"
#import "ExtendParcelViewController.h"


@interface LoginViewController (){
    LoginView *view;
    LoginModel *model;
    BOOL viewLoaded;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    view = (LoginView*) self.view;
    [view loadView];
    
    
    model = [[LoginModel alloc] init];
    [model setDelegate:self];
    self.title = NSLocalizedString(@"TituloLogin",@"");
    
    if([model shouldAutoLogin]){
        [view showLoading];
    }
    [self setAnalyticsTitle:@"Login"];
    

}

-(void) viewDidAppear:(BOOL)animated{
    self.title = NSLocalizedString(@"TituloLogin",@"");
    [super viewDidAppear:animated];
    
    [[GIDSignIn sharedInstance] signOut];
    [[GIDSignIn sharedInstance] setUiDelegate:self];
    
    if(viewLoaded){
        [view registerForKeyboardNotifications];
        
    }
    [view adjustScreen];
    viewLoaded = true;
    
    AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    if([appDelegate gotoLoginView]){
        [appDelegate setGotoLoginView:NO];
    }
    
//    [view.btGoogle addTarget:self action:@selector(googleSiginClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [view.btGoogle add]g
    
    

    
}

-(void) viewWillDisappear:(BOOL)animated{
    [view unloadView];
    
}
-(void)dealloc{
    [model setDelegate:nil];
    model = nil;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loginButtonClicked:(id)sender {
    if([[[view getEmailCPF] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]){
        [view showEmailCPFError:NSLocalizedString(@"EmailVazio", @"")];
        return;
    }
    if([[[view getPwd] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]){
        [view showPwdError:NSLocalizedString(@"SenhaVazia", @"")];
        return;
    }
    if([[view getEmailCPF] rangeOfString:@"@"].location == NSNotFound){
        //CPF
        if(![model validateCPFWithNSString:[view getEmailCPF]]) {
            //CPF Invalid
            [view showEmailCPFError:NSLocalizedString(@"CPFInvalido", @"")];
            return;
        }
    }else{
        //E-mail
        if(![model isValidEmail:[view getEmailCPF]]){
            //Email invalid
            [view showEmailCPFError:NSLocalizedString(@"EmailInvalido", @"")];
            return;
        }
    }
//    if(![model isValidPassword:[view getPwd]]){
//        [view showPwdError:NSLocalizedString(@"SenhaInvalida", @"")];
//        return;
//    }
    [view showLoading];
    
    [model doLogin:[view getEmailCPF] password:[view getPwd] stayLogged:[view shouldStayLogged]];

}
- (IBAction)forgotPasswordClicked:(id)sender {
    [self performSegueWithIdentifier:@"ForgotPassword" sender:nil];
}
- (IBAction)forgetEmailClicked:(id)sender {
    
    
}
- (IBAction)loginLaterClicked:(id)sender {
    [self performSegueWithIdentifier:@"OpenWithouLogin" sender:nil];
}
- (IBAction)privacyButtonClicked:(id)sender {
    [super openTerms];
}
- (IBAction)registerButtonClicked:(id)sender {
    
    [self performSegueWithIdentifier:@"DoRegister" sender:nil];
}

-(IBAction) googleSiginClicked:(id)sender{
    [view showLoading];
    [super sendActionEvent:@"Clique" label:@"Google Login"];
    [model doGoogleLogin:self];
}

// Stop the UIActivityIndicatorView animation that was started when the user
// pressed the Sign In button
- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    [view showLoading];
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn
presentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loginFacebookClicked:(id)sender {
    [view showLoading];
    [super sendActionEvent:@"Clique" label:@"Facebook Connect"];
    [model doFacebookLogin:self];



}

-(IBAction) changeSwitch:(id)sender{
    [super sendActionEvent:@"Clique" label:@"Manter Logado"];
}


#pragma mark Login Delegates

-(void)loginError:(NSString *)message{
    [view stopLoading];
    if([message isEqualToString:@"-1"]){
        return;
    }
    [view showMessage:NSLocalizedString(@"ErrorTitle",@"") message:message];

}

-(void)loginSuccess:(UserBeans *)userBeans{
    [view stopLoading];
    [view cleanPassword];
    if(userBeans != nil){
        NSLog(@"Sucesso!");
        [self performSegueWithIdentifier:@"OpenAfterLogin" sender:nil];
    }
    
}
-(void) loginFBNotRegistered:(FBUserBeans *)fbUserBeans{
    [view stopLoading];
    [self performSegueWithIdentifier:@"DoRegister" sender:fbUserBeans];
}


-(void)cancelTouchIdLogin{
    [view stopLoading];
}

-(void)touchIdLoginClicked{
    [super sendActionEvent:@"Clique" label:@"Touch ID"];
}
-(void)showRequestPassword:(UIAlertController *)controller{
    [self presentViewController:controller animated:YES completion:nil];

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    self.title = @"";
    if([segue.identifier isEqualToString:@"DoRegister"]){
        FBUserBeans *beans = (FBUserBeans*) sender;
        RegisterViewController *controller = (RegisterViewController*) segue.destinationViewController;
        [controller loadWithFbUserBeans:beans];
    }
}




@end
