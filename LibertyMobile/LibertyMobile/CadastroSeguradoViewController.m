 //
//  CadastroSeguradoViewController.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CadastroSeguradoViewController.h"
#import "LibertyMobileAppDelegate.h"
#import "Util.h"
#import "LS_TextField_TableViewCell.h"
#import "KeyboardNavigationBar.h"
#import "CallWebServices.h"
#import "BotaoAzulTableViewCell.h"
#import "CheckBoxTableViewCell.h"
#import "PoliticaPrivacidadeViewController.h"

@implementation CadastroSeguradoViewController

@synthesize btnEnviar;
@synthesize policyNumber;
@synthesize cpf_cnpj;
@synthesize email;
@synthesize emailConfirm;
@synthesize password;
@synthesize passwordConfirm;
@synthesize indicator;
@synthesize uiAlertView;

//Tag's Defines
#define ROW_TITLE_LABEL      0
#define ROW_POLICY           1
#define ROW_CPF              2
#define ROW_EMAIL            3
#define ROW_EMAIL_CONFIRM    4
#define ROW_PASSWORD_LABEL   5
#define ROW_PASSWORD         6
#define ROW_PASSWORD_CONFIRM 7
#define ROW_CHECKBOX         8
#define ROW_CHECKBOX_LABEL   9
#define ROW_REGISTER         10
#define ROW_TOTAL            11

static NSString *CellIdentifierTextField = @"CellLSTextField";

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

    // Exibe a barra
    [self.navigationController setNavigationBarHidden:NO];
    
    // Titulo
    self.title = @"Cadastre-se";
    
//    // Botão Voltar - Seta
//    UIImage *image = [UIImage imageNamed:@"seta.png"];
//    UIButton *face = [UIButton buttonWithType:UIButtonTypeCustom];
//    face.bounds = CGRectMake(0, 0, 30, 30);
//    [face setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//    [face setImage:image forState:UIControlStateNormal];
//    [face addTarget:self action:@selector(btnCancelar:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:face] ;
//    self.navigationItem.leftBarButtonItem = closeButton;
//    [closeButton release];
//
    [Util addBackButtonNavigationBar:self action:@selector(btnCancelar:)];
    
    // Coloca a imagem de fundo na barra:
    UIImage *imagebg = [UIImage imageNamed:@"nav_bg.png"];
    [self.navigationController.navigationBar setBackgroundImage:imagebg forBarMetrics:UIBarStyleDefault];
    
    [GoogleAnalyticsManager send:@"Cadastro Segurado"];

    [camposTableView setDataSource:self];
    [camposTableView setDelegate:self];
    
    [camposTableView registerNib:[UINib nibWithNibName:@"LS_TextField_TableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CellIdentifierTextField];
    [camposTableView registerNib:[UINib nibWithNibName:@"SinistroNovoWebTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CellSinistroWeb"];
    [camposTableView registerNib:[UINib nibWithNibName:@"CheckBoxTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cellCheck"];
    [camposTableView registerNib:[UINib nibWithNibName:@"BotaoAzulTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cellButton"];

    // << SN 11947
    if (![Utility hasInternet]) {
        [Utility showNoInternetWarning];
        return;
    }
    // >>
    
    // Alocar e inicializar o array de mensagens de erros
    dicMensagem = [[NSMutableDictionary alloc] init];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  ROW_TOTAL;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellLabelIdentifier = @"CellLabel";
    
    switch (indexPath.row)
    {
        case ROW_TITLE_LABEL:{
            UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                              reuseIdentifier:CellLabelIdentifier] autorelease];
            cell.textLabel.text = @"Cliente: este cadastro não é nescessário se você já esta cadastrado no Meu Espaço Cliente.";
            [cell.textLabel setFont:[UIFont systemFontOfSize:12.0f]];
            [cell.textLabel setTextColor:[Util colorwithHexString:@"#757575" alpha:1.0]];
            [cell.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
            [cell.textLabel setNumberOfLines:2];
            return cell;
        }break;
        case ROW_POLICY:{
            LS_TextField_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierTextField];
            [cell setup:NO];
            cell.txt_cadastro.delegate = self;
            cell.txt_cadastro.text = self.policyNumber;
            cell.txt_cadastro.placeholder = @"Apólice";
            cell.txt_cadastro.keyboardType = UIKeyboardTypeNumberPad;
            cell.txt_cadastro.tag = ROW_POLICY;
            [cell showErro:[dicMensagem objectForKey:@"POLICY"]];            
            return cell;
        }break;
        case ROW_CPF:{
            LS_TextField_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierTextField];
            [cell setup:NO];
            cell.txt_cadastro.delegate = self;
            cell.txt_cadastro.text = self.cpf_cnpj;
            cell.txt_cadastro.placeholder = @"CPF/CNPJ";
            cell.txt_cadastro.keyboardType = UIKeyboardTypeNumberPad;
            cell.txt_cadastro.tag = ROW_CPF;
            [cell showErro:[dicMensagem objectForKey:@"CPF"]];
            return cell;
        }break;
        case ROW_EMAIL:{
            LS_TextField_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierTextField];
            [cell setup:NO];
            cell.txt_cadastro.delegate = self;
            cell.txt_cadastro.text = self.email;
            cell.txt_cadastro.placeholder = @"E-mail";
            cell.txt_cadastro.keyboardType = UIKeyboardTypeEmailAddress;
            cell.txt_cadastro.tag = ROW_EMAIL;
            [cell showErro:[dicMensagem objectForKey:@"EMAIL"]];
            return cell;
        }break;
        case ROW_EMAIL_CONFIRM:{
            LS_TextField_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierTextField];
            [cell setup:NO];
            cell.txt_cadastro.delegate = self;
            cell.txt_cadastro.text = self.emailConfirm;
            cell.txt_cadastro.placeholder = @"Confirme o e-mail";
            cell.txt_cadastro.keyboardType = UIKeyboardTypeEmailAddress;
            cell.txt_cadastro.tag = ROW_EMAIL_CONFIRM;
            [cell showErro:[dicMensagem objectForKey:@"EMAIL_CONFIRM"]];
            return cell;
        }break;
        case ROW_PASSWORD_LABEL:{
            UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellLabelIdentifier] autorelease];
            UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(8, -5, 300, 46)];
            webView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
            webView.tag = 1001;
            webView.userInteractionEnabled = NO;
            webView.backgroundColor = [UIColor clearColor];
            webView.opaque = NO;
            
            [webView loadHTMLString: @"<!DOCTYPE html><html><style type='text/css' media=screen> p  { font-family: Helvetica; font-size: 0.75em; line-height: 1em; color:#757575;} </style><body><p><b>Atenção:</b> Digite uma combinação de pelo menos seis caracteres, incluindo número, letra e caracter especial (como ! e &amp;)</p></body></html>" baseURL:nil];
            
            [cell addSubview:webView];
            return cell;
        }break;
        case ROW_PASSWORD:{
            LS_TextField_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierTextField];
            [cell setup:YES];
            cell.txt_cadastro.delegate = self;
            cell.txt_cadastro.text = self.password;
            cell.txt_cadastro.placeholder = @"Senha";
            cell.txt_cadastro.keyboardType = UIKeyboardTypeAlphabet;
            cell.txt_cadastro.tag = ROW_PASSWORD;
            [cell showErro:[dicMensagem objectForKey:@"PASSWORD"]];
            return cell;
        }break;
        case ROW_PASSWORD_CONFIRM:{
            LS_TextField_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierTextField];
            [cell setup:YES];
            cell.txt_cadastro.delegate = self;
            cell.txt_cadastro.text = self.passwordConfirm;;
            cell.txt_cadastro.placeholder = @"Confirme a senha";
            cell.txt_cadastro.keyboardType = UIKeyboardTypeAlphabet;
            cell.txt_cadastro.tag = ROW_PASSWORD_CONFIRM;
            [cell showErro:[dicMensagem objectForKey:@"PASSWORD_CONFIRM"]];
            return cell;
        }break;
        case ROW_CHECKBOX:{
            CheckBoxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellCheck"];
            
            // Por não ter propriedade e construtor que receba o atributo, seta valor do componente:
            [cell.link loadHTMLString:@"<!DOCTYPE html><html><style type='text/css' media=screen> p  { font-family: Helvetica; font-size: 0.6em; line-height: 1em; color:#3F72CE;} </style><body><p><u>termos, condições e política de privacidade.</u></p></body></html>" baseURL:nil];
            
            // adiciona evento para o link do Politica de privacidade:
            if ([cell.link gestureRecognizers].count == 0) {
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoPoliticaPrivacidade)];
                [tap setNumberOfTapsRequired:1];
                [tap setDelegate:self]; // Add the <UIGestureRecognizerDelegate> protocol
                [cell.link addGestureRecognizer:tap];
            }
            
            if ( [[dicMensagem objectForKey:@"CHECKBOX"] isEqualToString:@"REQUERIDO"]){
                [cell.lblErro setHidden:NO];
            }else{
                [cell.lblErro setHidden:YES];
            }
            return cell;
        }break;
        case ROW_CHECKBOX_LABEL:{
            UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellCbxLabel"] autorelease];
            [cell setUserInteractionEnabled:NO];
            
            return cell;
        }break;
        case ROW_REGISTER:{
            // Caso seja a linha do Botão azul
            BotaoAzulTableViewCell *cell = (BotaoAzulTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cellButton"];
            [cell.btnAzul addTarget:self action:@selector(btnEnviar:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }break;
        default:
            return nil;
    }
}

#pragma mark -s Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {    
    // Deselect the row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{	
    //Open the Keyboard
    //[Util openKeyBoardTableView:[tableView cellForRowAtIndexPath:indexPath]];
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heightForRow = tableView.rowHeight;
    switch (indexPath.row)
    {
        case ROW_TITLE_LABEL:
            heightForRow = 30;
            break;
        case ROW_PASSWORD_LABEL:
            heightForRow = 48;
            break;
        case ROW_REGISTER:
            heightForRow = 43;
            break;
        case ROW_CHECKBOX:
            heightForRow = 53;
            break;
        case ROW_CHECKBOX_LABEL:
            heightForRow = 7;
            break;
        case ROW_POLICY:
        case ROW_CPF:
        case ROW_EMAIL:
        case ROW_EMAIL_CONFIRM:
        case ROW_PASSWORD:
        case ROW_PASSWORD_CONFIRM:
            heightForRow = 63;
            break;
    }
    return heightForRow;
}

#pragma mark - Text Field Delegate Methods

/* TODO
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger lengthAfterChange = [textField.text length] + [string length];   
    NSInteger maxLength = [Util getFieldLengthByFieldTagArray:textField.tag sourceArray:arrayFields];
    
    //only allow the max characters
    if (lengthAfterChange  > maxLength){
        return FALSE;
    }
    
    NSInteger field = textField.tag;
    if (field == FIELD_TAG_CPF) {
        [Util formatInput:textField string:string range:range maskValid:@"999.999.999-99"];
        return NO;
    }

    return TRUE;
}
 */

- (void)textFieldDidEndEditing:(UITextField *)theTextField
{
    if ([theTextField isKindOfClass:[UITextField class]]){
        
        if([theTextField text]){
            
            NSString *mystring = [[NSString alloc] initWithString:[theTextField text]];
            
            switch ([theTextField tag]){
                case ROW_POLICY:
                    [self setPolicyNumber:mystring];
                    break;
                case ROW_CPF:
                    [self setCpf_cnpj:mystring];
                    break;
                case ROW_EMAIL:
                    [self setEmail:mystring];
                    break;
                case ROW_EMAIL_CONFIRM:
                    [self setEmailConfirm:mystring];
                    break;
                case ROW_PASSWORD:
                    [self setPassword:mystring];
                    break;
                case ROW_PASSWORD_CONFIRM:
                    [self setPasswordConfirm:mystring];
                    break;
            }
            [mystring release];
        }
    }
}

#pragma mark - Action

- (IBAction)btnCancelar:(id)sender
{
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnEnviar:(id)sender
{
    if (activeTextField != nil) {
        if ([activeTextField respondsToSelector:@selector(resignFirstResponder)]) {
            [activeTextField resignFirstResponder];
        }
    }

    if (![self validateFieldsBlanks]) {
        return;
    }
    
    //----------------
//    NSString *cpfEnvio = [ stringByReplacingOccurrencesOfString:@"." withString:@""];
//    cpfEnvio = [cpfEnvio stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    // << SN 11947
    if (![Utility hasInternet]) {
        [Utility showNoInternetWarning];
        return;
    }
    // >>
    
    [indicator startAnimating];
    
    CallWebServices *callWs = [[[CallWebServices alloc] init] autorelease];
    [callWs callCadastrarUsuario:self nome:@""
                                senha:self.password
                                email:self.email
                                cpf:self.cpf_cnpj
                                apolice:self.policyNumber
                                fraseLembrete:@""
                                codigoImagemAcesso:@""];

}

- (void)callWebServicesDidFinish:(CallWebServices *)call
{
    if (call.typeCall == LMCallWsCadastrarUsuario) {
        BOOL retorno = call.retCadastrarUsuario;
        
        if (retorno) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                  message:@"Cadastro efetuado com sucesso!"
                                                  delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert setDelegate:self];
            [alert setTag:400];
            [alert show];
            [alert release];

        } else if (![call.UserErrorMessagesMsg isEqualToString:@""]) {

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:call.UserErrorMessagesMsg
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];

        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"Problemas no envio das informações!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
    
        }
    }
    
    [indicator stopAnimating];
}

- (void)callWebServicesFailWithError:(CallWebServices *)call error:(NSError *)error
{
    [indicator stopAnimating];
    [Util viewMsgErrorConnection:self codeError:error];
}

- (BOOL) validateFieldsBlanks
{
    BOOL isFildsOK = YES;
    
    //APOLICE
    NSString* msgApolice = @"";
    if(![Util fieldIsValidString:self.policyNumber andMinChars:1 andMaxChars:20])
    {
        msgApolice = @"Informe o número da apólice.";
        isFildsOK = NO;
    } else if ([self.policyNumber length] < 7) {
        msgApolice = @"Número inválido de apólice.";
        isFildsOK = NO;
    }
    [dicMensagem setObject:msgApolice forKey:@"POLICY"];

    // CPF CNPJ
    //NSString *cpfValidar = [self.user.cpfNumber stringByReplacingOccurrencesOfString:@"." withString:@""];
    //cpfValidar = [cpfValidar stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString* msgCPF = @"";
    if(![Util fieldIsValidString:self.cpf_cnpj andMinChars:1 andMaxChars:20])
    {
        msgCPF = @"Informe o CPF ou CNPJ.";
        isFildsOK = NO;
    }else{
   
        if([self.cpf_cnpj length ] == 14 ){
            if (![Util checkCnpj:self.cpf_cnpj]){
                msgCPF = @"CNPJ inválido!";
                isFildsOK = NO;
            }
        } else if (![Util checkCPF:self.cpf_cnpj]) {
            msgCPF = @"CPF inválido!";
            isFildsOK = NO;
        }
    }
    [dicMensagem setObject:msgCPF forKey:@"CPF"];
    
    //EMAIL
    NSString* msgEmail = @"";
    if(![Util fieldIsValidString:self.email andMinChars:1 andMaxChars:100])
    {
        msgEmail = @"Informe o email.";
        isFildsOK = NO;
    } else if (![Util validateEmail:self.email]) {
        msgEmail = @"Email inválido!";
        isFildsOK = NO;
    } else if (![self.email isEqualToString:self.emailConfirm]) {
        msgEmail = @"Os emails informados são diferentes.";
        isFildsOK = NO;
    }
    [dicMensagem setObject:msgEmail forKey:@"EMAIL"];
    
    //SENHA
    NSString* msgPwd = @"";
    if (![Util fieldIsValidString:self.password andMinChars:1 andMaxChars:50]) {
        msgPwd = @"Informe a senha.";
        isFildsOK = NO;
    } else if ([self.password length] < 8) {
        msgPwd = @"Sua senha deve possuir no mínimo 8 caracteres.";
        isFildsOK = NO;
    } else if (![self validarSenha:self.password]) {
        msgPwd = @"Sua senha deve conter letras, números e caracteres especiais.";
        isFildsOK = NO;
    } else if (![self.password isEqualToString:self.passwordConfirm]) {
        msgPwd = @"As senhas informadas são diferentes.";
        isFildsOK = NO;
    }
    [dicMensagem setObject:msgPwd forKey:@"PASSWORD"];
    
    //
    NSString* msgCbx = @"";
    if (!_checkBox) {
        msgCbx = @"REQUERIDO";
        isFildsOK = NO;
    }
    [dicMensagem setObject:msgCbx forKey:@"CHECKBOX"];

    [camposTableView reloadData];
    
    return isFildsOK;
}

-(BOOL)validarSenha:(NSString*)senha
{
    int iMatch = 0;

    //Verificando numeros
    iMatch = 0;
    NSString *regexNumber = @"[ˆ0-9]";
    NSPredicate *regextestNumber = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexNumber];
    for (int iCont = 0; iCont < [senha length]; iCont++) {
        if ([regextestNumber evaluateWithObject:[senha substringWithRange:NSMakeRange(iCont, 1)]]) {
            iMatch++;
        }
    }
    if (iMatch == 0) return NO;

    //Verificando caracteres minusculos
    int iMatchLower = 0;
    NSString *regexCaracteresLower = @"[ˆa-z]";
    NSPredicate *regextestCaracteresLower = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexCaracteresLower];
    for (int iCont = 0; iCont < [senha length]; iCont++) {
        if ([regextestCaracteresLower evaluateWithObject:[senha substringWithRange:NSMakeRange(iCont, 1)]]) {
            iMatchLower++;
        }
    }
    //if (iMatch == 0) return NO;

    //Verificando caracteres maiusculos
    NSString *regexCaracteresUpper = @"[ˆA-Z]";
    int iMatchUpper = 0;
    NSPredicate *regextestCaracteresUpper = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexCaracteresUpper];
    for (int iCont = 0; iCont < [senha length]; iCont++) {
        if ([regextestCaracteresUpper evaluateWithObject:[senha substringWithRange:NSMakeRange(iCont, 1)]]) {
            iMatchUpper++;
        }
    }
    //if (iMatch == 0) return NO;
    
    // Terá pelo menos 1 letra Maiusculas ou Minusculas
    if (iMatchLower == 0 && iMatchUpper == 0) return false;

    //Verificando caracteres especiais
    NSString *regexCaracteresSpecial = @"[ˆ!@#$%&*()_]?";
    iMatch = 0;
    NSPredicate *regextestCaracteresSpecial = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexCaracteresSpecial];
    for (int iCont = 0; iCont < [senha length]; iCont++) {
        if ([regextestCaracteresSpecial evaluateWithObject:[senha substringWithRange:NSMakeRange(iCont, 1)]]) {
            iMatch++;
        }
    }
    if (iMatch == 0) return NO;

    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

-(void)gotoPoliticaPrivacidade
{
    // Politica de privacidade
    PoliticaPrivacidadeViewController *defaultViewController = [[PoliticaPrivacidadeViewController alloc] init];
    
    [self.navigationController pushViewController:defaultViewController animated:YES];
    [defaultViewController release];
}


-(IBAction)btnCheckBox:(id)sender
{
    UIButton* btnCheckBox = (UIButton*)sender;
    btnCheckBox.selected = !btnCheckBox.selected;
    
    self.checkBox = btnCheckBox.selected;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 400) {
        [self.navigationController setNavigationBarHidden:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
