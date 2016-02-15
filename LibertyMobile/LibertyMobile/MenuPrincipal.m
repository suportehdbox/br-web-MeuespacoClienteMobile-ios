//
//  MenuPrincipal.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 8/27/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MenuPrincipal.h"
#import "Util.h"
#import "PoliticaPrivacidadeViewController.h"
#import "AtendimentoViewController.h"
#import "SinistroMenuViewController.h"
#import "MinhasApolicesViewController.h"
#import "OficinasReferenciadasViewController.h"
#import "ClubeLibertyViewController.h"
#import "CadastroSeguradoViewController.h"
#import "CallWebServices.h"
#import "LibertyMobileAppDelegate.h"
#import "KeychainItemWrapper.h"
#import <DirectAssistLib/DAUserPhone.h>
#import "NotificacaoConsultaViewController.h"

@implementation MenuPrincipal

@synthesize managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        DadosLoginSegurado *myDadosLoginSegurado = [[DadosLoginSegurado alloc] init];
        
        //-- Ao iniciar o app verifica se o usuário optou por manter app logado.
        NSLog(@"Verifica manterLogado");
        
        KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"LibertySeguros" accessGroup:nil];

        NSString *tokenAutenticacao = [keychain objectForKey:(id)kSecAttrDescription];
        NSString *usuarioId         = [keychain objectForKey:(id)kSecAttrAccount];
        NSString *TokenNotificacao  = [keychain objectForKey:(id)kSecAttrComment];
        
        if ([tokenAutenticacao isEqualToString:@""])
        {
            [myDadosLoginSegurado setLogado:NO];
            NSLog(@"        manterLogado : não");
        }
        else
        {
            callingLogonSeguradoToken = YES;
            [myDadosLoginSegurado setCpf:usuarioId];
            [myDadosLoginSegurado setTokenAutenticacao:tokenAutenticacao];
            [myDadosLoginSegurado setTokenNotificacao:TokenNotificacao];
            [myDadosLoginSegurado setLogado:YES];
            
            // No caso te possuir token realiza operação login por token em background.
            if (![Utility hasInternet])
            {
                [Utility showNoInternetWarning];
            }
            else
            {
                CallWebServices *callWs = [[[CallWebServices alloc] init] autorelease];
                [callWs callLogonSeguradoToken:self usuarioId:usuarioId tokenAutenticacao:tokenAutenticacao];
            }
        }
        [keychain release];
        
        LibertyMobileAppDelegate *appDelegate = (LibertyMobileAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate setDadosSegurado:myDadosLoginSegurado];
        
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [GoogleAnalyticsManager send:@"Menu Principal"];
    
    NSString *version = [[UIDevice currentDevice] systemVersion];
    
    if ([version hasPrefix:@"7."] || [version hasPrefix:@"8."] || [version hasPrefix:@"9."]) {
        CGRect scroolFrame = scrollView.frame;
        scroolFrame.origin.y = 20;
        scrollView.frame = scroolFrame;
    }
    
    //[Util initCustomNavigationBar:self.navigationController.navigationBar];

    if (!callingLogonSeguradoToken) {
        [self loginSegurado];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(NSUInteger) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIDeviceOrientationPortraitUpsideDown);
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self formatScroll:toInterfaceOrientation];
}

-(void)viewDidAppear:(BOOL)animated {
    [self formatScroll:[[UIDevice currentDevice] orientation]];
}

#pragma mark - Menus

//Chamadas dos Botões
-(IBAction)btnComunicacaoAcidentePressed:(id)sender
{
    SinistroMenuViewController *defaultViewController = [[SinistroMenuViewController alloc] init];
    defaultViewController.managedObjectContext = self.managedObjectContext;
    [self.navigationController pushViewController:defaultViewController animated:YES];
    [defaultViewController release];
}

-(IBAction)btnAssistencia24HorasPressed:(id)sender
{
    [self.navigationController setNavigationBarHidden:NO];
    
//    [Util initCustomNavigationBar:self.navigationController.navigationBar];
    // Coloca a imagem de fundo na barra:
    UIImage *imagebg = [UIImage imageNamed:@"nav_bg.png"];
    [self.navigationController.navigationBar setBackgroundImage:imagebg forBarMetrics:UIBarStyleDefault];
    
//    DAAssistanceMenuAllViewController *directAssist = [[DAAssistanceMenuAllViewController alloc] initWithNibName:@"DAAssistanceMenuAllViewController" bundle:nil];
    
    DAAssistanceMenuAllViewController *directAssist = [[DAAssistanceMenuAllViewController alloc] initWithNibName:@"DAAssistanceMenuAllViewController" bundle:[NSBundle bundleForClass:[DAAssistanceMenuAllViewController class]]];
    
    directAssist.delegate = self;
    [self.navigationController pushViewController:directAssist animated:YES];
    [directAssist release];
}

-(IBAction)btnMinhasApolicesPressed:(id)sender
{
    MinhasApolicesViewController *defaultViewController = [[MinhasApolicesViewController alloc] init];
    [self.navigationController pushViewController:defaultViewController animated:YES];
    [defaultViewController release];
}

-(IBAction)btnOficinasReferenciadasPressed:(id)sender
{
    OficinasReferenciadasViewController *defaultViewController = [[OficinasReferenciadasViewController alloc] init];
    [self.navigationController pushViewController:defaultViewController animated:YES];
    [defaultViewController release];
}

-(IBAction)btnClubeLibertyVantagensPressed:(id)sender
{
    ClubeLibertyViewController *defaultViewController = [[ClubeLibertyViewController alloc] init];
    [self.navigationController pushViewController:defaultViewController animated:YES];
    [defaultViewController release];
}

-(IBAction)btnAtendimentoPressed:(id)sender
{
    AtendimentoViewController *defaultViewController = [[AtendimentoViewController alloc] init];
    [self.navigationController pushViewController:defaultViewController animated:YES];
    [defaultViewController release];
}

-(IBAction)btnSetupPressed:(id)sender
{
    LibertyMobileAppDelegate *appDelegate = (LibertyMobileAppDelegate *)[[UIApplication sharedApplication] delegate];
    BOOL isLogado = appDelegate.dadosSegurado.logado;
    
    NSString *destructiveButtonTitle = isLogado ? @"LOGOUT" : nil;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancela"
                                  destructiveButtonTitle:destructiveButtonTitle
                                  otherButtonTitles:@"Notificações", @"Política de Privacidade", nil];
    [actionSheet showInView:self.navigationController.view];
    [actionSheet release];
}
-(IBAction)btnPoliticaPrivacidadePressed:(id)sender
{
    // Politica de privacidade
    [self gotoPoliticaPrivacidade];
}

-(IBAction)btnLoginPressed:(id)sender
{
    //[self skypeMe:sender];
    
    LibertyMobileAppDelegate *appDelegate = (LibertyMobileAppDelegate *)[[UIApplication sharedApplication] delegate];
    BOOL isLogado = appDelegate.dadosSegurado.logado;
    
    if (isLogado) {
        [self logout];
    }
    else {
        LoginViewController *defaultViewController = [[LoginViewController alloc] initWithLogin:self];
        [self.navigationController pushViewController:defaultViewController animated:YES];
        [defaultViewController release];
    }
}

-(IBAction)btnCadastroPressed:(id)sender
{
    CadastroSeguradoViewController *defaultViewController = [[CadastroSeguradoViewController alloc] init];
    defaultViewController.managedObjectContext = self.managedObjectContext;
    [self.navigationController pushViewController:defaultViewController animated:YES];
    [defaultViewController release];
}

#pragma mark - Login Delegate

- (void)loginViewController:(LoginViewController *)controller loginView:(BOOL)isLogin
{
    if (isLogin)
    {
        controller.dadosLoginSegurado.logado = YES;
        
        LibertyMobileAppDelegate *appDelegate = (LibertyMobileAppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString* tokenNotificacao = appDelegate.dadosSegurado.tokenNotificacao;
        
        //-- Realizado o login pode enviar o "TokenNotificacao" para receber Push
        
        if (nil != tokenNotificacao && ![tokenNotificacao isEqual:@""]) {
            CallWebServices *callWs = [[[CallWebServices alloc] init] autorelease];
            [callWs callEnviarToken:self cpfCnpj:controller.dadosLoginSegurado.cpf tokenNotificacao:tokenNotificacao];
            controller.dadosLoginSegurado.tokenNotificacao = tokenNotificacao;
        }
     
        //Atualiza os dados do login do segurado
        [appDelegate atualizaDadosLoginSegurado:controller.dadosLoginSegurado];
        
        /* TESTE EPO
        NSString *telefone = controller.dadosLoginSegurado.telefone;
        //telefone = @"997380371";
        if (manterLogado) {
            DAUserPhone *userPhone = [[DAUserPhone alloc] init];
            userPhone.areaCode = [telefone substringToIndex:2];
            userPhone.phoneNumber = [telefone substringFromIndex:2];
            [userPhone save];
        }*/
        
        [self.navigationController setNavigationBarHidden:YES];
        [self loginSegurado];
    }
    else {
        [self.navigationController setNavigationBarHidden:YES];
        [self logout];
    }
}

#pragma mark - Methods

-(void)logout
{
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"LibertySeguros" accessGroup:nil];
    [keychain resetKeychainItem];
    [keychain release];
    
    LibertyMobileAppDelegate *delegateApp = (LibertyMobileAppDelegate*)[[UIApplication sharedApplication] delegate];
    delegateApp.dadosSegurado = [[DadosLoginSegurado alloc] init];
    delegateApp.dadosSegurado.logado = FALSE;
    [delegateApp reset];
    
    [self loginSegurado];
}

-(void)loginSegurado
{    
    LibertyMobileAppDelegate *appDelegate = (LibertyMobileAppDelegate *)[[UIApplication sharedApplication] delegate];
    BOOL isLogin = appDelegate.dadosSegurado.logado;
    
    [self.btnMinhasApolices setEnabled:isLogin];
    
    [self.btnCadastro setHidden:isLogin];
    
    UIImage * image = [UIImage imageNamed:@"01_home-btn-minhaapolices.png"];
    
    [self.btnMinhasApolices setImage:image forState:UIControlStateNormal];
    
    [self.btnLogin setHidden:isLogin];
    
    if (!isLogin){
        [self.btnLogin setTitle:@"LOGIN" forState:UIControlStateNormal];
    }
}


-(void)returnDirectAssist:(NSArray *)caseList
{
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)formatScroll:(UIInterfaceOrientation)rotation
{
    if( UIInterfaceOrientationIsLandscape(rotation) )
    {
        NSString * nibName = [NSString stringWithFormat:@"%@Landscape", NSStringFromClass([self class])];
        
        [[NSBundle mainBundle] loadNibNamed: nibName
                                      owner: self
                                    options: nil];

        CGRect screenBound = [[UIScreen mainScreen] bounds];
        [scrollView setContentSize:CGSizeMake(screenBound.size.width, 568)];

        [self viewDidLoad];
    }
    else
    {
        [[NSBundle mainBundle] loadNibNamed: [NSString stringWithFormat:@"%@", NSStringFromClass([self class])]
                                      owner: self
                                    options: nil];
        [self viewDidLoad];
    }
    
}


-(void)gotoPoliticaPrivacidade
{
    // Politica de privacidade
    PoliticaPrivacidadeViewController *defaultViewController = [[PoliticaPrivacidadeViewController alloc] init];
    [defaultViewController setOrigemDaTela:1];
    [self.navigationController pushViewController:defaultViewController animated:YES];
    [defaultViewController release];
}

-(void)gotoNotificacoes
{
    // Lista de Notificações
    NotificacaoConsultaViewController *defaultViewController = [[NotificacaoConsultaViewController alloc] init];
    [self.navigationController pushViewController:defaultViewController animated:YES];
    [defaultViewController release];
}

#pragma mark UIActionSheet Delegate Methods
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    LibertyMobileAppDelegate *appDelegate = (LibertyMobileAppDelegate *)[[UIApplication sharedApplication] delegate];
    BOOL isLogin = appDelegate.dadosSegurado.logado;
    
    
    if (isLogin) {
        // Caso logado possui 4 botões:
        
        if (buttonIndex == 0){
            // LOGOUT
            [self logout];
        }
        else if (buttonIndex == 1){
            // NOTIFICAÇOES
            [self gotoNotificacoes];
        }
        else if (buttonIndex == 2){
            // Politica de privacidade
            [self gotoPoliticaPrivacidade];
        }
            // cancela - sem acão
    }
    else{
        // Caso contrário 3 botões:
        if (buttonIndex == 0){
            // NOTIFICAÇOES
            [self gotoNotificacoes];
        }
        else if (buttonIndex == 1){
            // Politica de privacidade
            [self gotoPoliticaPrivacidade];
        }
            // cancela - sem acão
    }
}

#pragma mark Delegate de CallWebServices

- (void)callWebServicesDidFinish:(CallWebServices *)call
{
    if (call.typeCall == LMCallWsLogonSeguradoToken) {
        
         DadosLoginSegurado *dadosLoginSeguradoToken = [call retLogonSeguradoToken];
        
        if (dadosLoginSeguradoToken.tokenAutenticacao != nil)
        {
            NSLog(@" efetuou login : sim");
            
            LibertyMobileAppDelegate *appDelegate = (LibertyMobileAppDelegate *)[[UIApplication sharedApplication] delegate];
            NSString *tokenNotificacao = [[appDelegate dadosSegurado] tokenNotificacao];
            
            //TODO ?
            // se o token foi renovado
            if (nil !=  tokenNotificacao && ![tokenNotificacao isEqualToString:@""])
            {
                CallWebServices *callWs = [[[CallWebServices alloc] init] autorelease];
                [callWs callEnviarToken:self cpfCnpj:[dadosLoginSeguradoToken cpf] tokenNotificacao:tokenNotificacao];
            }
            
            //Atualiza os dados do login do segurado
            dadosLoginSeguradoToken.logado = YES;

            [appDelegate atualizaDadosLoginSegurado:dadosLoginSeguradoToken];
        }
        else
        {
            [indicator stopAnimating];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:call.UserErrorMessagesMsg
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        [self loginSegurado];
    }
    
    [indicator stopAnimating];
}

- (void)callWebServicesFailWithError:(CallWebServices *)call error:(NSError *)error
{
    [indicator stopAnimating];
    [Util viewMsgErrorConnection:self codeError:error];
}

- (IBAction)skypeMe:(id)sender
{
    BOOL installed = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"skype:"]];
    if(installed)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"skype:alline-20?call"]];
    }
    else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.com/apps/skype/skype"]];
    }
}

@end
