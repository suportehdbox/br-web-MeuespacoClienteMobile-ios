//
//  UserProfileViewController.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 06/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "UserProfileViewController.h"
#import "UserProfileView.h"
#import "AppDelegate.h"
#import "PolicyViewController.h"



@interface UserProfileViewController (){
    UserProfileView *view;
    LoginModel *model;
    RegisterModel *registerModel;
    AppDelegate *appDelegate;
}

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super addLeftMenu];
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    view = (UserProfileView*) self.view;
    [view loadView];
    self.title = NSLocalizedString(@"MeusDadosTitulo",@"");
    
    [self setAnalyticsTitle:@"Meus Dados"];
    model = [[LoginModel alloc] init];
    [model setDelegate:self];
    
    registerModel = [[RegisterModel alloc] init];
    [registerModel setDelegate:self];
    
    if([[appDelegate getLoggeduser] hasFacebook]){
        [view facebookLinked];
    }
    if([[appDelegate getLoggeduser] hasGooglePlus]){
        [view googleLinked];
    }
    //
    // Do any additional setup after loading the view.
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.title = NSLocalizedString(@"MeusDadosTitulo",@"");
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [view loadViewAfterAppeared];
    [view.btGoogle addTarget:self action:@selector(linkGoogle:) forControlEvents:UIControlEventTouchDown];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [view numberOfRows];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [view tableView:tableView cellForRowAtIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *segue = [view getSegueAtIndexPath:indexPath];
    if(![segue isEqualToString:@""]){
        if([segue isEqualToString:@"dismiss"]){
            
            if([appDelegate isUserLogged]){
                [appDelegate logoutUser];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self performSegueWithIdentifier:segue sender:nil];
        }
    }
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    self.title = @"";
    if([segue.identifier isEqualToString:@"MeusDocumentos"]){
        PolicyViewController *dest = (PolicyViewController*) segue.destinationViewController;
        [dest loadPolicesFromDocuments];
        [dest setTitleTable:NSLocalizedString(@"PolicyDocuments", @"")];
    }
}

-(IBAction)linkFacebook:(id)sender{
    [super sendActionEvent:@"Clique" label:@"Facebook Connect"];
    [model doFacebookLink:self];
}

-(IBAction)linkGoogle:(id)sender{
    [super sendActionEvent:@"Clique" label:@"Google Login"];
    [model doGoogleLink:self];
}
    
#pragma mark - Facebook Delegate
    
-(void)linkFacebookUser:(FBUserBeans *)fbUserBeans{
    [view showLoadingFacebook:YES];
    RegisterBeans *registerBeans = [[RegisterBeans alloc] init];
    [registerBeans setName:[[appDelegate getLoggeduser] userName]];
    [registerBeans setEmail:[[appDelegate getLoggeduser] emailCpf]];
    [registerBeans setCpf:[[appDelegate getLoggeduser] cpfCnpj]];
    [registerBeans setPolicy:[[[[appDelegate getLoggeduser] policyHome] insurance] policy]];
    [registerBeans setFacebookInfo:fbUserBeans];
    [registerModel verifyPolice:registerBeans];
}
    
-(void)registeredFacebook{
    [view facebookLinked];
    [view showMessage:@"Sucesso!" message:@"Agora, você pode acessar o aplicativo também pelo facebook!"];
}

-(void)registerError:(NSString *)message{
    [view showLoadingFacebook:NO];
    [view showMessage:NSLocalizedString(@"TituloErroCadastro", @"") message:message];
}
@end
