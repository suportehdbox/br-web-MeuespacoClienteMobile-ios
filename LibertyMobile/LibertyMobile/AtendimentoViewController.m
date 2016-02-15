//
//  AtendimentoViewController.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 8/27/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AtendimentoViewController.h"
#import "Util.h"
#import "BotaoAmareloTableViewCell.h"
#import "TituloTableViewCell.h"

@implementation AtendimentoViewController

@synthesize camposTableView;

#define FIELD_LABEL                             0
#define FIELD_BUTTON                            1

#define FIELD_TOTAL                             2

#define SECTION_ATENDIMENTO_CAPITAL_METROPOLI   0
#define SECTION_ATENDIMENTO_DEMAIS_LOCAIS       1
#define SECTION_ASSISTENCIA_24H_AUTO_VIDA       2
#define SECTION_ASSISTENCIA_24H_EMPRESA_CASA    3

#define SECTION_TOTAL                           4

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

    [self.navigationController setNavigationBarHidden:NO];

    self.title = @"Atendimento";
    
    [GoogleAnalyticsManager send:@"Atendimento"];
    
//    //Adicionando o botão esquerdo na NavigationBar
//    UIBarButtonItem *closeButton = [Util addCustomButtonNavigationBar:self action:@selector(btnMenu:) imageName:@"btn-menu-lm.png"];
//    self.navigationItem.leftBarButtonItem = closeButton;
//    [closeButton release];
    
    [Util addBackButtonNavigationBar:self action:@selector(btnCancelarAtendimento:)];
    
    // Coloca a imagem de fundo na barra:
    UIImage *imagebg = [UIImage imageNamed:@"nav_bg.png"];
    [self.navigationController.navigationBar setBackgroundImage:imagebg forBarMetrics:UIBarStyleDefault];
    
    [Util dropTableBackgroudColor:self.camposTableView];
    
    [camposTableView registerNib:[UINib nibWithNibName:@"BotaoAmareloTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cellButton"];
    [camposTableView registerNib:[UINib nibWithNibName:@"TituloTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cellHeader"];
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
    return FIELD_TOTAL;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (FIELD_LABEL ==  indexPath.row)
    {
        // Caso seja a linha da Label
        
        TituloTableViewCell *cell = (TituloTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cellHeader"];
        
        switch (indexPath.section)
        {
            case SECTION_ATENDIMENTO_CAPITAL_METROPOLI:
                [cell.lblTitulo setText:@"Atendimento Capital e Região Metropolitana"];
                break;
            case SECTION_ATENDIMENTO_DEMAIS_LOCAIS:
                [cell.lblTitulo setText:@"Atendimento demais Localidades"];
                break;
            case SECTION_ASSISTENCIA_24H_AUTO_VIDA:
                [cell.lblTitulo setText:@"Assistência 24h Auto e Vida"];
                break;
            case SECTION_ASSISTENCIA_24H_EMPRESA_CASA:
                [cell.lblTitulo setText:@"Assistência 24h Empresas e Residência"];
                break;
        }
        return cell;
    }
    else if (FIELD_BUTTON ==  indexPath.row)
    {
        // Caso seja a linha do Botão Amarelo
        
        BotaoAmareloTableViewCell *cell = (BotaoAmareloTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cellButton"];
        
        switch (indexPath.section)
        {
            case SECTION_ATENDIMENTO_CAPITAL_METROPOLI:
                [cell.btnAmarelo addTarget:self action:@selector(btnAtendimentoCapital:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnAmarelo setTitle:@"4004 5423" forState:UIControlStateNormal];
                break;
            case SECTION_ATENDIMENTO_DEMAIS_LOCAIS:
                [cell.btnAmarelo addTarget:self action:@selector(btnAtendimentoLocalidades:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnAmarelo setTitle:@"0800 709 5423" forState:UIControlStateNormal];
                break;
            case SECTION_ASSISTENCIA_24H_AUTO_VIDA:
                [cell.btnAmarelo addTarget:self action:@selector(btnAssistenciaAutoVida:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnAmarelo setTitle:@"0800 701 4120" forState:UIControlStateNormal];
                break;
            case SECTION_ASSISTENCIA_24H_EMPRESA_CASA:
                [cell.btnAmarelo addTarget:self action:@selector(btnAssistenciaEmpresas:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnAmarelo setTitle:@"0800 702 5100" forState:UIControlStateNormal];
                break;
        }
        return cell;
    }
    return nil;
}

#pragma mark -s Table view delegate
 
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     // Deselect the row
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (IBAction)btnCancelarAtendimento:(id)sender
{
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnAtendimentoCapital:(id)sender 
{
    [Util callAlert:self alertTitle:@"Ligar para a Central de Atendimento" alertNumber:@"4004 5423"];
}

- (IBAction)btnAtendimentoLocalidades:(id)sender 
{
    [Util callAlert:self alertTitle:@"Ligar para a Central de Atendimento" alertNumber:@"0800 709 5423"];    
}

- (IBAction)btnAssistenciaAutoVida:(id)sender 
{
    [Util callAlert:self alertTitle:@"Ligar para Assistência 24h" alertNumber:@"0800 701 4120"];
}

- (IBAction)btnAssistenciaEmpresas:(id)sender
{
    [Util callAlert:self alertTitle:@"Ligar para Assistência 24h" alertNumber:@"0800 702 5100"];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
	if (buttonIndex == 1) {
        [Util callNumber:self phoneNumber:alertView.message];
	}
}

@end
