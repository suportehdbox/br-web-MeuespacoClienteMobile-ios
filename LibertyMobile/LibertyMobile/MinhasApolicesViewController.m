//
//  MinhasApolicesViewController.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 8/30/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MinhasApolicesViewController.h"
#import "Util.h"
#import "MinhasApolicesTableViewCell.h"
#import "MinhasApolicesDetalheViewController.h"
#import "CallWebServices.h"
#import "MinhasApolicesAnterioresViewController.h"
#import "LibertyMobileAppDelegate.h"

#define SECTION_APOLICES    0
#define SECTION_BTN         1

#define SECTION_TOTAL       2

@implementation MinhasApolicesViewController

@synthesize menuTableView;
//@synthesize dadosLoginSegurado;
@synthesize indicator;


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
    
    [indicator startAnimating];

//    [Util initCustomNavigationBar:self.navigationController.navigationBar];

    [self.navigationController setNavigationBarHidden:NO];
    self.title = @"Minhas Apólices";
    
    [GoogleAnalyticsManager send:@"Minhas Apolices"];
    
    [Util dropTableBackgroudColor:self.menuTableView];

//    //Adicionando o botão esquerdo na NavigationBar
//    UIBarButtonItem *closeButton = [Util addCustomButtonNavigationBar:self action:@selector(btnMenu:) imageName:@"btn-menu-lm.png"];
//    self.navigationItem.leftBarButtonItem = closeButton;
//    [closeButton release];
    
    [Util addBackButtonNavigationBar:self action:@selector(btnMenu:)];
    
    // Coloca a imagem de fundo na barra:
    UIImage *imagebg = [UIImage imageNamed:@"nav_bg.png"];
    [self.navigationController.navigationBar setBackgroundImage:imagebg forBarMetrics:UIBarStyleDefault];
    
    [menuTableView setDelegate:self];
    [menuTableView setDataSource:self];
    
    [menuTableView registerNib:[UINib nibWithNibName:@"MinhasApolicesTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CellMinhasApolices"];
    [menuTableView registerNib:[UINib nibWithNibName:@"BotaoAmareloTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cellButton"];
    
    
    LibertyMobileAppDelegate *appDelegate = (LibertyMobileAppDelegate *)[[UIApplication sharedApplication] delegate];
    dadosLoginSegurado = appDelegate.dadosSegurado;
    
    if (dadosLoginSegurado.minhasApolices != nil && [dadosLoginSegurado.minhasApolices count] != 0)
    {
        bLoadApolicesVigentes = TRUE;
        
        apolices = dadosLoginSegurado.minhasApolices;
        [menuTableView reloadData];
        [indicator stopAnimating];
    }
    else
    {
        bLoadApolicesVigentes = FALSE;
        
        if (![Utility hasInternet]) {
            [Utility showNoInternetWarning];
            [indicator stopAnimating];
            return;
        }
        
        CallWebServices *callWs = [[[CallWebServices alloc] init] autorelease];
        [callWs callGetMeusSegurosLiberty:self cpfCnpj:dadosLoginSegurado.cpf tipoFiltro:@"1"];
    }
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
    if (!bLoadApolicesVigentes) return 0;
    return SECTION_TOTAL;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRowsInSection = 0;
    
    if(bLoadApolicesVigentes && section == SECTION_APOLICES) {
        numberOfRowsInSection = [apolices count];
    } else if (section == SECTION_BTN){
        numberOfRowsInSection = 1;
    }
    return numberOfRowsInSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == SECTION_APOLICES)
    {
        MinhasApolicesTableViewCell *cell = (MinhasApolicesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellMinhasApolices"];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        NSMutableDictionary* dict = [apolices objectAtIndex:indexPath.row];
        
        //cell.lblNumeroApolice.text = [dict objectForKey:@"NumeroApolice"];
        
        
        NSString *tipoSeguro    = [dict objectForKey:@"TipoSeguro"];
        NSString *nomeProduto   = [[dict objectForKey:@"NomeProduto"] capitalizedString];
        
        if ([tipoSeguro isEqualToString:@"AUTO"]) {
            NSString *detalhe = [[NSString alloc] initWithFormat:@"%@ (Placa: %@)", nomeProduto, [dict objectForKey:@"DescricaoItem"]];
            cell.lblNumeroApolice.text = detalhe;
            [detalhe release];
        }
        else if ([tipoSeguro isEqualToString:@"RESIDENCIA"]) {
            NSString *detalhe = [[NSString alloc] initWithFormat:@"%@ (CEP: %@)", nomeProduto, [dict objectForKey:@"DescricaoItem"]];
            cell.lblNumeroApolice.text = detalhe;
            [detalhe release];
        }
        else if ([tipoSeguro isEqualToString:@"PESSOAL"]) {
            NSString *detalhe = [[NSString alloc] initWithString:nomeProduto];
            cell.lblNumeroApolice.text = detalhe;
            [detalhe release];
        }
        else if ([tipoSeguro isEqualToString:@"OUTROS"]) {
            NSString *detalhe = [[NSString alloc] initWithString:nomeProduto];
            cell.lblNumeroApolice.text = detalhe;
            [detalhe release];
        }
        else if ([tipoSeguro isEqualToString:@"EMPRESARIAL"]) {
            NSString *detalhe = [[NSString alloc] initWithString:nomeProduto];
            cell.lblNumeroApolice.text = detalhe;
            [detalhe release];
        }
        
        cell.lblDetalhe.text = [dict objectForKey:@"NumeroApolice"];
      
        NSString * situacao = [dict objectForKey:@"SituacaoApolice"];
        if ([situacao isEqualToString:@"ApoliceAtiva"]) {
            cell.imgAlerta.hidden = true;
        }
        else {
            cell.imgAlerta.hidden = false;
        }
        return cell;
    }
    
    // << EPO: Alteração para redimencionamento correto do botão quando rotacionado
    else if (indexPath.section == SECTION_BTN)
    {
        // Caso seja a linha do Botão Amarelo
        return [Util getViewButtonTableViewCell:self action:@selector(btnAnteriores_Click:) textButton:@"Apólices Anteriores" tableView:tableView];
    }
    // >>
    
    return nil;
}


#pragma mark -s Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section != SECTION_BTN)
    {
        MinhasApolicesDetalheViewController *viewTela = [[MinhasApolicesDetalheViewController alloc] init];
        viewTela.cellDict = [apolices objectAtIndex:indexPath.row];
        viewTela.dadosLoginSegurado = dadosLoginSegurado;
        [self.navigationController pushViewController:viewTela animated:YES];
        [viewTela release];
    }

    // Deselect the row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == SECTION_BTN){
        return 50.0;
    }
       
    return 70.0;
}


#pragma mark -s Actions

- (IBAction)btnAnteriores_Click:(id)sender
{
    MinhasApolicesAnterioresViewController *viewTela = [[MinhasApolicesAnterioresViewController alloc] init];
    viewTela.dadosLoginSegurado = dadosLoginSegurado;
    [self.navigationController pushViewController:viewTela animated:YES];
    [viewTela release];
}

- (IBAction)btnMenu:(id)sender
{
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - WebServices Delegate

- (void)callWebServicesDidFinish:(CallWebServices *)call
{
    if ([call typeCall] ==  LMCallWsMeusSeguros){
        
        // Retorno da chamada do serviço que retorna as apólices
        
        @try {
            
            NSMutableArray *retGetMeusSegurosLiberty = call.retGetMeusSegurosLiberty;
            
            apolices = [[NSMutableArray alloc] initWithArray:retGetMeusSegurosLiberty];
            
            if (apolices != nil && [apolices count] > 0){
                bLoadApolicesVigentes = TRUE;
                [menuTableView reloadData];
            }
            
            NSMutableArray *myMinhasApolices = [[NSMutableArray alloc] initWithArray:apolices];
            [dadosLoginSegurado setMinhasApolices:myMinhasApolices];
            
            LibertyMobileAppDelegate *appDelegate = (LibertyMobileAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate atualizaDadosLoginSegurado:dadosLoginSegurado];
            
            [myMinhasApolices release];
            
            [indicator stopAnimating];
            
        }
        @catch(NSException *e) {
            
            /*
             Caso retGetMeusSegurosLiberty falhe por 'SESSAO_INVALIDA' e escolheu manter logado
             Chama o loginToken em background e depois chama "callGetMeusSegurosLiberty" novamente
             */
            
            if ([[e name] isEqualToString:@"SESSAO_INVALIDA"]) {
                if([dadosLoginSegurado tokenAutenticacao] != nil ){
                    CallWebServices *callWs = [[[CallWebServices alloc] init] autorelease];
                    [callWs callLogonSeguradoToken:self usuarioId:[dadosLoginSegurado cpf] tokenAutenticacao:[dadosLoginSegurado tokenAutenticacao] ];
                    
                } else {
                    
                    // Se não escolheu manter logado quando a sessão expira deve logar novamente
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sessão expirada!"
                                                                    message:@"Por favor efetue o login novamente"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                }
            }
        }
    }
    else if ([call typeCall] == LMCallWsLogonSeguradoToken){
        
        // Retorno da chamada do serviço de autenticação
        
        DadosLoginSegurado *dadosLoginSeguradoToken = [call retLogonSeguradoToken];
        
        if (dadosLoginSeguradoToken.tokenAutenticacao != nil)
        {
            //Atualiza os dados do login do segurado
            dadosLoginSegurado.logado = YES;
            dadosLoginSegurado.cpf = dadosLoginSeguradoToken.cpf;
            dadosLoginSegurado.tokenAutenticacao = dadosLoginSeguradoToken.tokenAutenticacao;
            
            // Para atualizar 'dadosLoginSegurado' do 'LibertyMobileAppDelegate'
            LibertyMobileAppDelegate *appDelegate = (LibertyMobileAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate atualizaDadosLoginSegurado:dadosLoginSegurado];
            
            CallWebServices *callWs = [[[CallWebServices alloc] init] autorelease];
            [callWs callGetMeusSegurosLiberty:self cpfCnpj:dadosLoginSegurado.cpf tipoFiltro:@"1"];
            
        }
    }
}

- (void)callWebServicesFailWithError:(CallWebServices *)call error:(NSError *)error
{
    [indicator stopAnimating];
    [Util viewMsgErrorConnection:self codeError:error];
}

@end
