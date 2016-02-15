//
//  MinhasApolicesDetalheViewController.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 8/31/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MinhasApolicesDetalheViewController.h"
#import "MinhasApolicesParcelasViewController.h"
#import "MinhasApolicesDetalheTableViewCell.h"
#import "MinhasApolicesDetalhe2TableViewCell.h"
#import "Util.h"
#import "CallWebServices.h"
#import "LibertyMobileAppDelegate.h"

#define ROW_HEADER              0
#define ROW_BODY                1

#define SECTION_DETALHE        0
#define SECTION_PAGAMENTO      1
#define SECTION_PARCELA        2

#define SECTION_TOTAL          3

@implementation MinhasApolicesDetalheViewController

@synthesize cellDict;
@synthesize dadosLoginSegurado;
@synthesize indicator;
@synthesize tableDetalhes;
@synthesize heightCellDetalhe;
@synthesize descricaoCoberturas;

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
    
    bLoadDetalhes = FALSE;
    [indicator startAnimating];

//    [Util initCustomNavigationBar:self.navigationController.navigationBar];
    
    [self.navigationController setNavigationBarHidden:NO];    
    self.title = @"Apólice";
    
    [GoogleAnalyticsManager send:@"Minhas Apólices: Detalhe"];
    
//    //Adicionando o botão esquerdo na NavigationBar
//    UIBarButtonItem *voltarButton = [Util addCustomButtonNavigationBar:self action:@selector(btnVoltar:) imageName:@"47_minhaapoliceumaparcela-btn-minha.png"];
//    self.navigationItem.leftBarButtonItem = voltarButton;
//    [voltarButton release];
    
    [Util addBackButtonNavigationBar:self action:@selector(btnVoltar:)];
    
    // Coloca a imagem de fundo na barra:
    UIImage *imagebg = [UIImage imageNamed:@"nav_bg.png"];
    [self.navigationController.navigationBar setBackgroundImage:imagebg forBarMetrics:UIBarStyleDefault];
    
    [Util dropTableBackgroudColor:self.tableDetalhes];
    
    [tableDetalhes setDelegate:self];
    [tableDetalhes setDataSource:self];
    
    [tableDetalhes registerNib:[UINib nibWithNibName:@"MinhasApolicesDetalheTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CellMinhasApolicesDetalhe"];
    [tableDetalhes registerNib:[UINib nibWithNibName:@"MinhasApolicesDetalhe2TableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CellMinhasApolicesDetalhe2"];
    [tableDetalhes registerNib:[UINib nibWithNibName:@"BotaoAmareloTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cellButton"];

    if (![Utility hasInternet]) {
        [Utility showNoInternetWarning];
        [indicator stopAnimating];
        return;
    }
    
    CallWebServices *callWs = [[[CallWebServices alloc] init] autorelease];
    [callWs callGetCoberturasApolice:self
                           usuarioId:dadosLoginSegurado.cpf
                      numeroContrato:[cellDict objectForKey:@"NumeroContrato"]
                       codigoEmissao:[cellDict objectForKey:@"NumeroEmissao"]
                          codigoItem:[cellDict objectForKey:@"CodigoItem"]
                           codigoCIA:[cellDict objectForKey:@"CodigoCIA"]];

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
    if (!bLoadDetalhes) return 0;
    return SECTION_TOTAL;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRowsInSection = 2;
    
    if(!bLoadDetalhes) {
        numberOfRowsInSection = 0;
    } else if (section == SECTION_PARCELA){
        numberOfRowsInSection = 1;
    }
    return numberOfRowsInSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section != SECTION_PARCELA && indexPath.row == ROW_HEADER))
    {
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        cell.textLabel.textColor = [Util getColorHeader];
        
        if (indexPath.section == SECTION_DETALHE) {
            //Titulo do Detalhe
            cell.textLabel.text = @"Informações da apólice";
        }
        else if (indexPath.section == SECTION_PAGAMENTO) {
            //Titulo do Pagamento
            cell.textLabel.text = @"Informações da pagamento";            
        }
        return cell;
    }
    else if (indexPath.section == SECTION_DETALHE && indexPath.row == ROW_BODY)
    {
        // Corpo do Detalhe:
        
        MinhasApolicesDetalheTableViewCell *cell = (MinhasApolicesDetalheTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellMinhasApolicesDetalhe"];

        cell.lblNumeroApolice.text = [cellDict objectForKey:@"NumeroApolice"];
        cell.lblCoberturas.text = descricaoCoberturas;
        cell.lblVigencia.text = [cellDict objectForKey:@"Vigencia"];
        
        CGSize maximumLabelSize = CGSizeMake(296, 9999);
        CGSize expectedLabelSize = [descricaoCoberturas sizeWithFont:cell.lblCoberturas.font constrainedToSize:maximumLabelSize lineBreakMode:cell.lblCoberturas.lineBreakMode];
        CGRect newFrame = cell.lblCoberturas.frame;
        newFrame.size.height = expectedLabelSize.height + 30;
        cell.lblCoberturas.frame = newFrame;
        
        return cell;
    }
    else if (indexPath.section == SECTION_PAGAMENTO && indexPath.row == ROW_BODY)
    {
        // Corpo do Pagamento:
        
        MinhasApolicesDetalhe2TableViewCell *cell = (MinhasApolicesDetalhe2TableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellMinhasApolicesDetalhe2"];

        //Verificando pagamentos das parcelas
        NSMutableArray *parcelas = [cellDict objectForKey:@"Parcelas"];
        BOOL bPendente = FALSE;
        for (NSUInteger iCont = 0; iCont < [parcelas count]; iCont++) {
            NSDictionary *dict = [parcelas objectAtIndex:iCont];
            if (![[dict objectForKey:@"Quitada"] boolValue]) {
                bPendente = TRUE;
                break;
            }
        }
        
        cell.lblStatusPagamento.text = (bPendente ? @"Pendente" : @"Ok");
        cell.lblStatusParcelas.text = (bPendente ? @"Pendente" : @"Ok");

        return cell;
    }
    
    // << EPO: Alteração para redimencionamento correto do botão quando rotacionado
    else if (indexPath.section == SECTION_PARCELA)
    {
        // Caso seja a linha do Botão Amarelo
        return [Util getViewButtonTableViewCell:self action:@selector(btnParcelas_Click:) textButton:@"Parcelas" tableView:tableView];
    }
    // >>

    return nil;
}

#pragma mark -s Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section != SECTION_PAGAMENTO && indexPath.row == ROW_HEADER) {
        return 45.0;
    }
    else if (indexPath.section == SECTION_DETALHE && indexPath.row == ROW_BODY) {
        return heightCellDetalhe;
    }
    else if (indexPath.section == SECTION_PAGAMENTO && indexPath.row == ROW_BODY) {
        return 80.0;
    }

    return tableView.rowHeight;
}


#pragma mark -s Actions

- (IBAction)btnVoltar:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnParcelas_Click:(id)sender
{
    MinhasApolicesParcelasViewController *viewTela = [[MinhasApolicesParcelasViewController alloc] init];
    [self.navigationController pushViewController:viewTela animated:YES];
    viewTela.parcelas = [cellDict objectForKey:@"Parcelas"];
    [viewTela release];
}


#pragma mark - WebServices Delegate

- (void)callWebServicesDidFinish:(CallWebServices *)call
{
    if (call.typeCall == LMCallWsObterCoberturas) {
        
        // Retorno da chamada do serviço que retorna as Coberturas
        
        @try {
            
            NSMutableArray *retGetCoberturasApolice = call.retGetCoberturasApolice;
        
            coberturas = [[NSMutableArray alloc] initWithArray:retGetCoberturasApolice];
        
            if (coberturas != nil) {
                descricaoCoberturas = [[NSMutableString alloc] initWithString:@""];

                heightCellDetalhe = 100.0;
                for (NSUInteger iCont = 0; iCont < [coberturas count]; iCont++) {
                    if (![descricaoCoberturas isEqualToString:@""]) [descricaoCoberturas appendString:@", "];
                    NSDictionary *dict = [coberturas objectAtIndex:iCont];
                    [descricaoCoberturas appendString:[dict objectForKey:@"Nome"]];
                }
                heightCellDetalhe += (([descricaoCoberturas length] / 28) * 20) + 20;

                bLoadDetalhes = TRUE;
                [tableDetalhes reloadData];
            }

            [indicator stopAnimating];
            
        }
        @catch(NSException *e) {
            
            /*
             Caso retGetCoberturasApolice falhe por 'SESSAO_INVALIDA' e escolheu manter logado
             Chama o loginToken em background e depois chama "callGetCoberturasApolice" novamente
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
            [callWs callGetCoberturasApolice:self
                                   usuarioId:dadosLoginSegurado.cpf
                              numeroContrato:[cellDict objectForKey:@"NumeroContrato"]
                               codigoEmissao:[cellDict objectForKey:@"NumeroEmissao"]
                                  codigoItem:[cellDict objectForKey:@"CodigoItem"]
                                   codigoCIA:[cellDict objectForKey:@"CodigoCIA"]];
            
        }
    }
}

- (void)callWebServicesFailWithError:(CallWebServices *)call error:(NSError *)error
{
    [indicator stopAnimating];
    [Util viewMsgErrorConnection:self codeError:error];
}


@end
