//
//  LoginViewController.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "Util.h"
#import "KeyboardNavigationBar.h"
#import "LoginRecuperacaoViewController.h"
#import "LibertyMobileAppDelegate.h"
#import "TextFieldTableViewCell.h"
#import "LoginManterLogadoTableViewCell.h"
#import "BotaoAmareloTableViewCell.h"

@implementation LoginViewController

@synthesize delegate;

@synthesize userName;
@synthesize password;

@synthesize indicator;

@synthesize dadosLoginSegurado;

#define FIELD_TAG_LOGIN             1
#define FIELD_TAG_PASSWORD          2

#define MAX_FIELD_TAG               2

#define SECTION_DADOS_LOGIN         0
#define SECTION_DADOS_MARTERLOGADO  1
#define SECTION_DADOS_ENVIAR        2
#define SECTION_DADOS_ESQUECISENHA  3

#define SECTION_TOTAL               4


-(id)initWithLogin:(id)target
{
    if ((self = [super initWithNibName:@"LoginViewController" bundle:nil])){
        self.delegate = target;
    }

    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [Util initCustomNavigationBar:self.navigationController.navigationBar];
    
    [indicator stopAnimating];

    // Pegar o caminho do plist
    NSString* pathArray = [[NSBundle mainBundle] pathForResource:@"Login" ofType:@"plist"];
    // Alocar e inicializar o array com os conteúdos do plist
    arrayFields = [[NSMutableArray alloc] initWithContentsOfFile:pathArray];        
    
    [self.navigationController setNavigationBarHidden:NO];
    self.title = @"Login";
    
    [GoogleAnalyticsManager send:@"Login"];
    
    [Util dropTableBackgroudColor:self.camposTableView];

//    //Adicionando o botão esquerdo na NavigationBar
//    UIBarButtonItem *closeButton = [Util addCustomButtonNavigationBar:self action:@selector(btnCancelar:) imageName:@"btn-cancelar-lm.png"];
//    self.navigationItem.leftBarButtonItem = closeButton;
//    [closeButton release];

    [Util addBackButtonNavigationBar:self action:@selector(btnCancelar:)];
    
    // Coloca a imagem de fundo na barra:
    UIImage *imagebg = [UIImage imageNamed:@"nav_bg.png"];
    [self.navigationController.navigationBar setBackgroundImage:imagebg forBarMetrics:UIBarStyleDefault];
    
    isRecuperarSenha = FALSE;
    
    [camposTableView setDelegate:self];
    [camposTableView setDataSource:self];
    
    [camposTableView registerNib:[UINib nibWithNibName:@"TextFieldTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CellTextField"];
    [camposTableView registerNib:[UINib nibWithNibName:@"LoginManterLogadoTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CellLoginManterLogado"];
    [camposTableView registerNib:[UINib nibWithNibName:@"BotaoAmareloTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cellButton"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
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

- (void)viewWillDisappear:(BOOL)animated 
{
    if (!isRecuperarSenha) {
        [super.activeTextField resignFirstResponder];
        [self.delegate loginViewController:self loginView:isLogin];
    }
	[super viewWillDisappear:animated];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return SECTION_TOTAL;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int iCount = [Util getCountSectionArray:section sourceArray:arrayFields];
    return iCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    int iSection = indexPath.section;
    int iPositionReal = [Util getPositionSectionArray:iSection numRow:indexPath.row sourceArray:arrayFields];
    NSMutableDictionary* dict = [arrayFields objectAtIndex:iPositionReal];
    BOOL bHeader = [[dict objectForKey:@"header"] boolValue];
    int iTag = [[dict objectForKey:@"tag"] intValue];
    
    if (bHeader == YES) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        cell.textLabel.text = [dict objectForKey:@"menuItem"];
        cell.textLabel.textColor = [Util getColorHeader];
        cell.userInteractionEnabled = NO;
        
        tableView.separatorColor = [UIColor lightGrayColor];
        
        return cell;
    }

    // << SN 12136
    if (indexPath.section == SECTION_DADOS_MARTERLOGADO) {
        
        LoginManterLogadoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellLoginManterLogado"];

        cell.lblInfo.text = [dict objectForKey:@"menuItem"];
        [cell.lblInfo setFont:[UIFont boldSystemFontOfSize:14.0f]];
        [cell.switchOnOff addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        
        tableView.separatorColor = [UIColor lightGrayColor];
        
        return cell;
    }
    // >>
    
    if (indexPath.section == SECTION_DADOS_ESQUECISENHA) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        
        cell.textLabel.text = [dict objectForKey:@"menuItem"];
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        
        tableView.separatorColor = [UIColor lightGrayColor];

        return cell;
    }
    
    // << EPO: Alteração para redimencionamento correto do botão quando rotacionado
    if (indexPath.section == SECTION_DADOS_ENVIAR)
    {
        // Caso seja a linha do Botão Amarelo
        return [Util getViewButtonTableViewCell:self action:@selector(btnLogin_Click:) textButton:[dict objectForKey:@"menuItem"] tableView:tableView];
    }
    // >>
    
    TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellTextField"];
    
    cell.txtField.delegate = self;
    
    NSString* sTexto = [dict objectForKey:@"menuItem"];
    cell.lblField.text = sTexto;
    cell.txtField.tag = iTag;
    cell.txtField.placeholder = [dict objectForKey:@"placeholder"];

    switch (iTag)
    {
        case FIELD_TAG_LOGIN:
            cell.txtField.text = userName;
            cell.txtField.keyboardType = UIKeyboardTypeEmailAddress;
            break;
        case FIELD_TAG_PASSWORD:
            cell.txtField.text = password;            
            cell.txtField.secureTextEntry = YES;
            break;        
    }

    return cell;
}

#pragma mark -s Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == SECTION_DADOS_ESQUECISENHA) {
        isRecuperarSenha = TRUE;
        LoginRecuperacaoViewController *defaultViewController = [[[LoginRecuperacaoViewController alloc] init] autorelease];
        [self.navigationController pushViewController:defaultViewController animated:YES];
    }
    
    // Deselect the row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   return tableView.rowHeight;
}

#pragma mark - Text Field Delegate Methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger lengthAfterChange = [textField.text length] + [string length];   
    NSInteger maxLength = [Util getFieldLengthByFieldTagArray:textField.tag sourceArray:arrayFields];

    //only allow the max characters
    if (lengthAfterChange  > maxLength){
        return FALSE;
    }
    
    return TRUE;
}

- (void)textFieldDidEndEditing:(UITextField *)theTextField
{
    if ([theTextField isKindOfClass:[UITextField class]]){
        
        if([theTextField text]){
            
            NSString *mystring = [[NSString alloc] initWithString:[theTextField text]];
            
            switch ([theTextField tag]){
                case FIELD_TAG_LOGIN:
                    [self setUserName:mystring];
                    break;
                case FIELD_TAG_PASSWORD:
                    [self setPassword:mystring];
                    break;
            }
            
            [mystring release];
        }
    }
}

#pragma mark - Action

- (IBAction)btnCancelar:(id)sender {
    isLogin = FALSE;
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)switchAction:(id)sender
{
    bool isOn = [sender isOn];
    
    // caso `on` alertar usuário:
	if (isOn) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Ao manter o aplicativo logado não há necessidade de informar login e senha a cada acesso. Contudo, caso terceiros tenham acesso ao seu celular, dados pessoais poderão ser visualizados."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    manterLogado = isOn;
}

- (IBAction)btnLogin_Click:(id)sender {

    [self setEnabledButtons:FALSE];
    
    if (activeTextField != nil) {
        if ([activeTextField respondsToSelector:@selector(resignFirstResponder)]) {
            [activeTextField resignFirstResponder];
        }
    }
    
    BOOL validaLogin = YES;
    
    if (userName == nil || password == nil) {
        validaLogin = NO;
    } else if ([userName isEqual:@""] || [password isEqual:@""]) {
        validaLogin = NO;
    }
    
    if (!validaLogin) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Por favor informe o login e senha!"
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    [indicator startAnimating];

    if (![Utility hasInternet]) {
        [Utility showNoInternetWarning];
        [indicator stopAnimating];
        return;
    }
    
    CallWebServices *callWs = [[[CallWebServices alloc] init] autorelease];
    [callWs callLogonSegurado:self user:userName password:password manterLogado:(manterLogado ? @"true" : @"false")];
}

- (void)callWebServicesDidFinish:(CallWebServices *)call
{
    if (call.typeCall == LMCallWsLogonSegurado) {
        
        /* << EPO SN 11886
         BOOL bReturn = call.retLogonSegurado;
         if (bReturn) {
         CallWebServices *callWs = [[[CallWebServices alloc] init] autorelease];
         [callWs callObterDadosSegurado:self email:self.userName];
         return;
         }
         >> */
        
        self.dadosLoginSegurado = [call retLogonSegurado];
        
        if (self.dadosLoginSegurado != nil)
        {
            isLogin = TRUE;
            
            // EPO: reset no clube liberty
            LibertyMobileAppDelegate *delegateApp = (LibertyMobileAppDelegate*)[[UIApplication sharedApplication] delegate];
            delegateApp.clubeLiberty = nil;
            
            // reset nos dados do segurado (outro segurado pode logar)
            self.dadosLoginSegurado.minhasApolices = nil;
            self.dadosLoginSegurado.minhasApolicesAnteriores = nil;
            
        }
        else {
            isLogin = FALSE;
            [indicator stopAnimating];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:call.UserErrorMessagesMsg
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }

    [indicator stopAnimating];
    [self setEnabledButtons:TRUE];
    
    if (isLogin) {
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)callWebServicesFailWithError:(CallWebServices *)call error:(NSError *)error
{
    [indicator stopAnimating];
    [self setEnabledButtons:TRUE];
    [Util viewMsgErrorConnection:self codeError:error];
}

-(void)setEnabledButtons:(BOOL)bEnabled
{
    [btnLogin setEnabled:bEnabled];
}

#pragma - metodos para aceitar HTTPS nao confiavel

- (void) connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]
             forAuthenticationChallenge:challenge];
    }
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

- (BOOL) connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    if([[protectionSpace authenticationMethod] isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        return YES;
    }
    return NO;
}
    
@end
