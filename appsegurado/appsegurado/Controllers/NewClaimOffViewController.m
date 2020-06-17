//
//  NewClaimOffViewController.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 28/11/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "NewClaimOffViewController.h"
#import "NewClaimOffView.h"
#import "PolicyViewController.h"
#import "AppDelegate.h"

@interface NewClaimOffViewController (){
    NewClaimOffView *view;
    bool isAssist24hs;
}
@end

@implementation NewClaimOffViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    view = (NewClaimOffView*) self.view;
    [view loadView:isAssist24hs];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(isAssist24hs){
        self.title = NSLocalizedString(@"Assistencia24hs",@"");
    }else{
        self.title = NSLocalizedString(@"Sinistro",@"");
    }
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.title = @"";
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [view unloadView];
}

-(void) setAssist24hs{
    isAssist24hs = true;
    
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    self.title = @"";
    if([segue.identifier isEqualToString:@"ShowClaimItens"]){
        PolicyViewController *controller = (PolicyViewController*) segue.destinationViewController;
        [controller loadPolicesFromClaimOff:[view getPlatePolicy] cpf:[view getCpf]];
        if(isAssist24hs){
            [controller set24hsAssist];
        }
    }
}


- (IBAction)startClaim:(id)sender {
    //ShowClaimItens
    if([[view getPlatePolicy] isEqualToString:@""]){
        [view showPlatePolicyError:NSLocalizedString(@"Campo obrigatório", @"")];
        return;
    }
    if([[view getCpf] isEqualToString:@""]){
        [view showCPFError:NSLocalizedString(@"Campo obrigatório", @"")];
        return;
    }
    
    BaseModel *model = [[BaseModel alloc] init];
    
    if([[view getCpf] length] <= 11){
        NSString *cpf = [view getCpf];
        while([cpf length] < 11){
            cpf = [NSString stringWithFormat:@"0%@",cpf];
        }
        if(![model validateCPFWithNSString:cpf]){
            [view showCPFError:NSLocalizedString(@"CPFInvalido", @"")];
            return;
        }else{
            [view.txtCPF setText:cpf];
        }
    }else{
        if(![model validarCNPJ:[view getCpf]]){
            [view showCPFError:NSLocalizedString(@"CPFInvalido", @"")];
            return;
        }
    }

    [self performSegueWithIdentifier:@"ShowClaimItens" sender:nil];
}

- (IBAction)doLogin:(id)sender {
    AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    [appDelegate setGotoLoginView:YES];
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (IBAction)doRegister:(id)sender{
    [self performSegueWithIdentifier:@"RegisterSegue" sender:nil];
}

- (IBAction)forgotPassword:(id)sender {
    [self performSegueWithIdentifier:@"ForgotSegue" sender:nil];
}
- (IBAction)requestHelp:(id)sender{
    [super showContactViewController];
}
@end
