//
//  ForgotEmailViewController.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 09/11/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "ForgotEmailViewController.h"
#import "ForgotEmailView.h"
#import "AppDelegate.h"
#import "LoginViewController.h"

@interface ForgotEmailViewController (){
    ForgotEmailView *view;
    int indexScreen;
    NSArray *arrayQuestions;
    NSArray *sortedQuestionsId;
    ForgotEmailModel *model;
//    ChangeEmailModel *emailModel;
    NSString *cpf;
}

@end

@implementation ForgotEmailViewController



- (id)initWithIndexScreen:(int)index arrayQuestions:(NSArray*)questions arrayId:(NSArray*) ids userCPF:(NSString*) userCPF{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    self = [storyboard instantiateViewControllerWithIdentifier:@"ForgotEmailScreen"];
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    if (self) {
        indexScreen = index;
        arrayQuestions = questions;
        sortedQuestionsId = ids;
        cpf = userCPF;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    view = (ForgotEmailView*) self.view;
    [view loadView];
    model = [[ForgotEmailModel alloc] init];
    AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    sortedQuestionsId = [appDelegate forgotQuestionsIds];
    if(sortedQuestionsId == nil){
        sortedQuestionsId = [[NSArray alloc] init];
    }
    [model setDelegate:self];
    
    [self controllScreen];
        self.title = NSLocalizedString(@"TituloEsqueciEmail", @"");
    [self setAnalyticsTitle:@"Esqueceu E-mail"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillDisappear:(BOOL)animated{
    [view unloadView];
    self.title = @"";
    
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = NSLocalizedString(@"TituloEsqueciEmail", @"");
}

-(void)dealloc{
    if(model != nil){
        [model setDelegate:nil];
        model = nil;
    }
}
-(void) controllScreen{

    switch (indexScreen) {
        case 0:
            [view showRequestCpf];
            
            break;
        case 1:
        case 2:
        case 3:
            
            [view showQuestion:[[arrayQuestions objectAtIndex:(indexScreen - 1)] desc] number:[NSString stringWithFormat:@"%d",indexScreen]];
            break;
        case 4:
            [view showNewEmailForm];
            break;
        default:
            break;
    }

}

-(BOOL) allowGotoScreen{
    switch (indexScreen) {
        case 0:
            
            if(![model validateCPFWithNSString:[view getField1]]){
                [view showField1Error:NSLocalizedString(@"CPFInvalido",@"")];
                return NO;
            }
            [view showLoading];
            return YES;
            break;
        case 1:
        case 2:
        case 3:
            if([[view getField1] isEqualToString:@""]){
                [view showField1Error:NSLocalizedString(@"RespostaVazia",@"")];
                return NO;
            }
            [[arrayQuestions objectAtIndex:(indexScreen - 1)] setUserAnswer:[view getField1]];
            return YES;
            break;
        case 4:
            if([[view getField1] isEqualToString:@""]){
                [view showField1Error:NSLocalizedString(@"EmailVazioEsqueceuSenha",@"")];
                return NO;
            }
            if([[view getField2] isEqualToString:@""]){
                [view showField2Error:NSLocalizedString(@"EmailVazioEsqueceuSenha",@"")];
                return NO;
            }
            if(![[view getField1] isEqualToString:[view getField2]]){
                [view showField1Error:NSLocalizedString(@"EmailsNaoCorrespondemTroca",@"")];
                [view showField2Error:NSLocalizedString(@"EmailsNaoCorrespondemTroca",@"")];

                return NO;
            }
            if(![model isValidEmail:[view getField1]]){
                [view showField1Error:NSLocalizedString(@"EmailInvalido",@"")];
                return NO;
            }
            
            return YES;
            break;
        default:
            break;
    }
    
    return NO;

    

}

- (IBAction)nextScreenButton:(id)sender {
    
    if([self allowGotoScreen]){
        if(indexScreen == 0){
            cpf =[view getField1];
            [model getQuestions:[view getField1] lastQuestions:sortedQuestionsId];
        
        }else if(indexScreen == 4){
//            [emailModel changeEmail:[view getField1] cpf:cpf];
//            [view showLoading];
            [model sendAnswersCPF:cpf newEmail:[view getField1] questions:arrayQuestions];
            [view showLoading];
        }else{
            [self gotoNextScreen];
        }
    }
}

- (IBAction)successButton:(id)sender {
    AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    [appDelegate setGotoLoginView:YES];
    
    UIViewController *popView;
    for (UIViewController *controller in  self.navigationController.viewControllers) {
        if([controller isKindOfClass:[LoginViewController class]]){
            popView = controller;
            break;
        }
    }
    [self.navigationController popToViewController:popView animated:YES];
}



-(void) gotoNextScreen{
  
    ForgotEmailViewController *nextScreen = [[ForgotEmailViewController alloc] initWithIndexScreen:(indexScreen+1) arrayQuestions:arrayQuestions arrayId:sortedQuestionsId userCPF:cpf];
    [self.navigationController showViewController:nextScreen sender:nil];
    
}

#pragma mark Delegate

-(void)returntQuestions:(ForgotEmailBeans *)forgotBeans{
    arrayQuestions = forgotBeans.questionsList;
    sortedQuestionsId = forgotBeans.sortedQuestions;
    AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    [[appDelegate forgotQuestionsIds] addObjectsFromArray:sortedQuestionsId];
    [view stopLoading];
    [self gotoNextScreen];
}


-(void)questionsError:(NSString *)message{
    [view stopLoading];
    [view showMessage:NSLocalizedString(@"ErrorTitle",@"") message:message];
}

-(void)returnAnswerSucessfully{
    [view stopLoading];
//    [self gotoNextScreen];
    [view showSuccessMessage];
}

-(void)answersError:(NSString *)message{
    [view stopLoading];
    [view showMessage:NSLocalizedString(@"ErrorTitle",@"") message:message];
}
//
//-(void) emailChangedSuccessfully{
//    [view stopLoading];
//    [view showSuccessMessage];
//}
//-(void) emailError:(NSString*)message{
//    [view stopLoading];
//    [view showMessage:NSLocalizedString(@"ErrorTitle",@"") message:message];
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
