//
//  MinhasApolicesAnterioresViewController.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 8/30/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MinhasApolicesAnterioresViewController.h"
#import "Util.h"
#import "MinhasApolicesTableViewCell.h"
#import "MinhasApolicesDetalheViewController.h"
#import "CallWebServices.h"
#import "LibertyMobileAppDelegate.h"

@implementation MinhasApolicesAnterioresViewController

@synthesize menuTableView;
@synthesize dadosLoginSegurado;
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
    self.title = @"Minhas Apólices Anteriores";
    
    [GoogleAnalyticsManager send:@"Minhas Apólices: Anteriores"];

    [Util dropTableBackgroudColor:self.menuTableView];

//    //Adicionando o botão esquerdo na NavigationBar
//    UIBarButtonItem *voltarButton = [Util addCustomButtonNavigationBar:self action:@selector(btnVoltar:) imageName:@"47_minhaapoliceumaparcela-btn-minha.png"];    
//    self.navigationItem.leftBarButtonItem = voltarButton;
//    [voltarButton release];
    
    [Util addBackButtonNavigationBar:self action:@selector(btnVoltar:)];

    // Coloca a imagem de fundo na barra:
    UIImage *imagebg = [UIImage imageNamed:@"nav_bg.png"];
    [self.navigationController.navigationBar setBackgroundImage:imagebg forBarMetrics:UIBarStyleDefault];
    
    // TODO Alterar metodo!!
    
    if (dadosLoginSegurado.minhasApolicesAnteriores != nil && [dadosLoginSegurado.minhasApolicesAnteriores count] != 0) {
        apolicesAnteriores = dadosLoginSegurado.minhasApolicesAnteriores;
        [menuTableView reloadData];
        [indicator stopAnimating];
    }
    else
    {
        if (![Utility hasInternet]) {
            [Utility showNoInternetWarning];
            [indicator stopAnimating];
            return;
        }
        CallWebServices *callWs = [[[CallWebServices alloc] init] autorelease];
        [callWs callGetMeusSegurosLiberty:self cpfCnpj:dadosLoginSegurado.cpf tipoFiltro:@"2"];
    }
    
    [menuTableView setDelegate:self];
    [menuTableView setDataSource:self];
    
    [menuTableView registerNib:[UINib nibWithNibName:@"MinhasApolicesTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CellMinhasApolices"];
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
    return [apolicesAnteriores count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MinhasApolicesTableViewCell *cell = (MinhasApolicesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellMinhasApolices"];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSMutableDictionary* dict = [apolicesAnteriores objectAtIndex:indexPath.row];
    
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


#pragma mark -s Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MinhasApolicesDetalheViewController *viewTela = [[MinhasApolicesDetalheViewController alloc] init];
    viewTela.cellDict = [apolicesAnteriores objectAtIndex:indexPath.row];
    viewTela.dadosLoginSegurado = self.dadosLoginSegurado;
    [self.navigationController pushViewController:viewTela animated:YES];
    [viewTela release];

    // Deselect the row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

#pragma mark -s Actions

- (IBAction)btnVoltar:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - WebServices Delegate

- (void)callWebServicesDidFinish:(CallWebServices *)call
{
    if ([call typeCall] ==  LMCallWsMeusSeguros){
        
        // Retorno da chamada do serviço que retorna as apólices
        
        @try {
            
            NSMutableArray *retGetMeusSegurosLiberty = call.retGetMeusSegurosLiberty;
            
            apolicesAnteriores = [[NSMutableArray alloc] initWithArray:retGetMeusSegurosLiberty];
            
            if (apolicesAnteriores != nil){
                [menuTableView reloadData];
            }
            
            NSMutableArray *myMinhasApolicesAnteriores = [[NSMutableArray alloc] initWithArray:apolicesAnteriores];
            [dadosLoginSegurado setMinhasApolicesAnteriores:myMinhasApolicesAnteriores];
            [myMinhasApolicesAnteriores release];

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
            [callWs callGetMeusSegurosLiberty:self cpfCnpj:dadosLoginSegurado.cpf tipoFiltro:@"2"];
        }
    }
}

- (void)callWebServicesFailWithError:(CallWebServices *)call error:(NSError *)error
{
    [indicator stopAnimating];
    [Util viewMsgErrorConnection:self codeError:error];
}

@end
