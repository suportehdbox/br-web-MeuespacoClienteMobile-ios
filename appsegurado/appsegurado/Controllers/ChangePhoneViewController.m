//
//  ChangePasswordViewController.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 10/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "ChangePhoneViewController.h"
#import "ChangePhoneView.h"

@interface ChangePhoneViewController (){
    ChangePhoneView *view;
    ChangePhoneModel *model;
}

@end

@implementation ChangePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    view= (ChangePhoneView*) self.view;
    [view loadView];
    self.title = NSLocalizedString(@"MeusDadosTitulo", @"");
    model = [[ChangePhoneModel alloc] init];
    [model setDelegate:self];
    [model getPhone];
    [self setAnalyticsTitle:@"Troca de Telefone"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
      self.title = NSLocalizedString(@"MeusDadosTitulo", @"");
    [view showLoading];
}

- (IBAction)sendChange:(id)sender {
    
    if([self isEmpty:[view getPhone]] && [self isEmpty:[view getCellPhone]]){
        [view showPhoneError:NSLocalizedString(@"TelefoneVazio",@"")];
        [view showCellPhoneError:NSLocalizedString(@"CelularVazio",@"")];
        return;
    }
    //1112341234
    if([self isEmpty:[view getPhone]] || [[view getPhone] length] < 10){
        [view showPhoneError:NSLocalizedString(@"TelefoneVazio",@"")];
        return;
    }
    if([self isEmpty:[view getCellPhone]] || [[view getCellPhone] length] < 10){
        [view showCellPhoneError:NSLocalizedString(@"CelularVazio",@"")];
        return;
    }
    
    [view showLoading];
    
    [model changePhone:[view getPhone] extension:[view getExtension] cellphone:[view getCellPhone]];
    
//    [model changePassowrdOldPwd:[view getOldPwd] newPwd:[view getNewPwd]];
    
    
}
- (IBAction)btPopUpSuccess:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)phoneChangedSuccessfully{
    [view stopLoading];
    [view showSuccessMessage];
    
}

-(BOOL) isEmpty:(NSString*)string{
    if([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]){
        return  true;
    }
    return false;
}


-(void)phoneError:(NSString *)message{
    [view stopLoading];
    [view showMessage:NSLocalizedString(@"ErrorTitle", @"") message:message];
    
}


-(void)loadedPhone:(NSString *)phone extension:(NSString *)extension cellphone:(NSString *)cellphone{
    [view setPhone:phone];
    [view setExtension:extension];
    [view setCellPhone:cellphone];
    [view stopLoading];
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
