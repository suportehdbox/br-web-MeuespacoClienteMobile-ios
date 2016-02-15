//
//  LoginRecuperacaoViewController.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 12/12/12.
//
//

#import "LoginRecuperacaoViewController.h"
#import "Util.h"
#import "TextFieldTableViewCell.h"

@implementation LoginRecuperacaoViewController

@synthesize userName;
@synthesize cpf;
@synthesize email;

@synthesize indicator;

#define FIELD_TAG_LOGIN             1
#define FIELD_TAG_CPF               2
#define FIELD_TAG_EMAIL             3

#define SECTION_DADOS_LOGIN         0
#define SECTION_DADOS_ENVIAR        1

#define SECTION_TOTAL               2

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [Util initCustomNavigationBar:self.navigationController.navigationBar];
    
    [indicator stopAnimating];
    
    MAX_FIELD_TAG = 3;

    // Pegar o caminho do plist
    NSString* pathArray = [[NSBundle mainBundle] pathForResource:@"RecuperacaoSenhaSegurado" ofType:@"plist"];
    // Alocar e inicializar o array com os conteúdos do plist
    arrayFields = [[NSMutableArray alloc] initWithContentsOfFile:pathArray];
    
    [self.navigationController setNavigationBarHidden:NO];
    self.title = @"Recuperar senha";
    
    [Util dropTableBackgroudColor:self.camposTableView];
    
//    //Adicionando o botão esquerdo na NavigationBar
//    UIBarButtonItem *closeButton = [Util addCustomButtonNavigationBar:self action:@selector(btnCancelar:) imageName:@"btn-cancelar-lm.png"];
//    self.navigationItem.leftBarButtonItem = closeButton;
//    [closeButton release];

    [Util addBackButtonNavigationBar:self action:@selector(btnCancelar:)];
    
    // Coloca a imagem de fundo na barra:
    UIImage *imagebg = [UIImage imageNamed:@"nav_bg.png"];
    [self.navigationController.navigationBar setBackgroundImage:imagebg forBarMetrics:UIBarStyleDefault];
    
    [camposTableView setDelegate:self];
    [camposTableView setDataSource:self];
    
    [camposTableView registerNib:[UINib nibWithNibName:@"TextFieldTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CellTextField"];
    [camposTableView registerNib:[UINib nibWithNibName:@"BotaoAmareloTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cellButton"];
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
    return SECTION_TOTAL;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int iCount = [Util getCountSectionArray:section sourceArray:arrayFields];
    return iCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int iSection = indexPath.section;
    int iPositionReal = [Util getPositionSectionArray:iSection numRow:indexPath.row sourceArray:arrayFields];
    NSMutableDictionary* dict = [arrayFields objectAtIndex:iPositionReal];
    BOOL bHeader = [[dict objectForKey:@"header"] boolValue];
    int iTag = [[dict objectForKey:@"tag"] intValue];
    
    if (bHeader == YES) {
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        
        cell.textLabel.text = [dict objectForKey:@"menuItem"];
        cell.textLabel.textColor = [Util getColorHeader];
        cell.userInteractionEnabled = NO;
        
        return cell;
    }
    
    // << EPO: Alteração para redimencionamento correto do botão quando rotacionado
    if (indexPath.section == SECTION_DADOS_ENVIAR)
    {
        // Caso seja a linha do Botão Amarelo
        return [Util getViewButtonTableViewCell:self action:@selector(btnLogin:) textButton:[dict objectForKey:@"menuItem"] tableView:tableView];
    }
    // >>
    
    TextFieldTableViewCell *cell = (TextFieldTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellTextField"];
    [cell.txtField setDelegate:self];
    
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
        case FIELD_TAG_CPF:
            cell.txtField.text = cpf;
            cell.txtField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case FIELD_TAG_EMAIL:
            cell.txtField.text = email;
            cell.txtField.keyboardType = UIKeyboardTypeEmailAddress;
            break;
    }
    
    return cell;
}


#pragma mark -s Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Open the Keyboard
    //[Util openKeyBoardTableView:[tableView cellForRowAtIndexPath:indexPath]];	
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Deselect the row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.rowHeight;
}


#pragma mark - Text Field Delegate Methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger lengthAfterChange = [textField.text length] + [string length];
    NSInteger maxLength = [Util getFieldLengthByFieldTagArray:textField.tag sourceArray:arrayFields];
    
    //only allow the max characters
    if (lengthAfterChange  > maxLength)
    {
        return FALSE;
    }
    
    NSInteger field = textField.tag;
    if (field == FIELD_TAG_CPF) {
        [Util formatInput:textField string:string range:range maskValid:@"999.999.999-99"];
        return NO;
    }

    return TRUE;
}

- (void)textFieldDidEndEditing:(UITextField *)theTextField
{
    //determine which field is being edited and save the data to the right place in the model
    NSInteger field = theTextField.tag;
    
    if([theTextField text]){
        
        NSString *myString = [[NSString alloc] initWithString:[theTextField text]];
    
        switch (field){
            case FIELD_TAG_LOGIN:
                [self setUserName:myString];
                break;
            case FIELD_TAG_EMAIL:
                [self setEmail:myString];
                break;
            case FIELD_TAG_CPF:
                [self setCpf:myString];
                break;
        }
        
        [myString release];
    }
}

#pragma mark - Action

- (IBAction)btnCancelar:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnLogin:(id)sender
{
    [indicator startAnimating];
    
    if (activeTextField != nil) {
        if ([activeTextField respondsToSelector:@selector(resignFirstResponder)]) {
            [activeTextField resignFirstResponder];
        }
    }

    if (![self validateFieldsBlanks]) {
        [indicator stopAnimating];
        return;
    }

    NSString *cpfEnvio = [self.cpf stringByReplacingOccurrencesOfString:@"." withString:@""];
    cpfEnvio = [cpfEnvio stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    // << SN 11947
    if (![Utility hasInternet]) {
        [Utility showNoInternetWarning];
        [indicator stopAnimating];
        return;
    }
    // >>
    
    CallWebServices *callWs = [[[CallWebServices alloc] init] autorelease];
    [callWs callEsqueciMinhaSenhaSegurado:self email:self.email cpf:cpfEnvio];
}

- (void)callWebServicesDidFinish:(CallWebServices *)call
{
    if (call.typeCall == LMCallWsEsqueciMinhaSenhaSegurado) {
        BOOL bRetorno = call.retEsqueciMinhaSenhaSegurado;
        
        if (bRetorno ) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"Uma nova senha foi enviada para seu email!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            [self.navigationController popViewControllerAnimated:YES];

        } else {
            if (![call.UserErrorMessagesMsg isEqualToString:@""]) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:call.UserErrorMessagesMsg
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
            else {
                [Util viewMsgErrorConnection:self codeError:2];
            }
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
    NSMutableString *mensagem = [[NSMutableString alloc] initWithString:@""];
    BOOL bCheckEmail = YES;
    BOOL bCheckCPF = YES;
    
    if(![Util fieldIsValidString:self.cpf andMinChars:1 andMaxChars:100])
    {
        [mensagem appendString:@"Informe o CPF.\n"];
        bCheckCPF = NO;
    }
    if(![Util fieldIsValidString:self.email andMinChars:1 andMaxChars:100])
    {
        [mensagem appendString:@"Informe o email.\n"];
        bCheckEmail = NO;
    }

    if (![Util validateEmail:self.email] && bCheckEmail) {
        [mensagem appendString:@"Email inválido!\n"];
    }

    NSString *cpfValidar = [self.cpf stringByReplacingOccurrencesOfString:@"." withString:@""];
    cpfValidar = [cpfValidar stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if (![Util validaCPF:cpfValidar] && bCheckCPF) {
        [mensagem appendString:@"CPF inválido.\n"];
    }
    
    if (![mensagem isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:mensagem
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        [mensagem release];
        
        return NO;
    }
    
    // << FPB
    [mensagem release];
    // >> FPB
    
    return TRUE;
}

@end
