//
//  ClubeLibertyViewController.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ClubeLibertyViewController.h"
#import "Util.h"
#import "ClubeLibertyLocaisViewController.h"
#import "CallWebServices.h"
#import "Constants.h"
#import "LibertyMobileAppDelegate.h"

@implementation ClubeLibertyViewController

@synthesize categoriasTableView;
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
    [indicator startAnimating];
    
    [super viewDidLoad];
//    [Util initCustomNavigationBar:self.navigationController.navigationBar];

    [self.navigationController setNavigationBarHidden:NO];    
    self.title = @"Clube Liberty";
    
    [GoogleAnalyticsManager send:@"Clube Liberty de Vantagens"];
    
    [Util dropTableBackgroudColor:self.categoriasTableView];

//    //Adicionando o botão esquerdo na NavigationBar
//    UIBarButtonItem *closeButton = [Util addCustomButtonNavigationBar:self action:@selector(btnMenu:) imageName:@"btn-menu-lm.png"];
//    self.navigationItem.leftBarButtonItem = closeButton;
//    [closeButton release];
    
    [Util addBackButtonNavigationBar:self action:@selector(btnMenu:)];
    
    // Coloca a imagem de fundo na barra:
    UIImage *imagebg = [UIImage imageNamed:@"nav_bg.png"];
    [self.navigationController.navigationBar setBackgroundImage:imagebg forBarMetrics:UIBarStyleDefault];
    
    LibertyMobileAppDelegate *delegateApp = (LibertyMobileAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (delegateApp.clubeLiberty != nil && [delegateApp.clubeLiberty count] != 0) {
        clubeLiberty = delegateApp.clubeLiberty;
        [self carregaCategorias];
        [categoriasTableView reloadData];
        [indicator stopAnimating];
    }
    else {
        
        // << SN 11947
        if (![Utility hasInternet]) {
            [Utility showNoInternetWarning];
            [indicator stopAnimating];
            return;
        }
        // >>
        
        CallWebServices *callWs = [[[CallWebServices alloc] init] autorelease];
        if (!dadosLoginSegurado.logado) {
            [callWs callGetClubeLiberty:self email:@"mobile"];
        }
        else {
            [callWs callGetClubeLiberty:self email:dadosLoginSegurado.cpf];
        }
    }
    
    [categoriasTableView setDelegate:self];
    [categoriasTableView setDataSource:self];
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
    return [categorias count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    cell.textLabel.text = [categorias objectAtIndex:indexPath.row];

    return cell;
}


#pragma mark -s Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *name = [categorias objectAtIndex:indexPath.row];

    ClubeLibertyLocaisViewController *defaultViewController = [[ClubeLibertyLocaisViewController alloc] init];
    defaultViewController.categoria = name;
    defaultViewController.clubeLiberty = clubeLiberty;
    [self.navigationController pushViewController:defaultViewController animated:YES];
    [defaultViewController release];
    
    // Deselect the row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -s Actions

- (IBAction)btnMenu:(id)sender {
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -s Web Service

- (void)callWebServicesDidFinish:(CallWebServices *)call {
    if (call.typeCall == LMCallWsClubeLiberty) {
        
        clubeLiberty = [[NSMutableArray alloc] initWithArray:call.retGetClubeLiberty];
        
        if ([clubeLiberty count] > 0) {
            
            //NSMutableArray *objsToDelete = [NSMutableArray array];
            
            //Add column image
            for (NSMutableDictionary *dict in clubeLiberty)
            {
                NSString *imagem = [NSString stringWithString:[dict objectForKey:@"Logo"]];

                imagem = [imagem stringByReplacingOccurrencesOfString:LMUrlInterna withString:LMUrlExterna];
                
                NSURL *imageURL = [[NSURL alloc] initWithString:imagem];
                NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                [imageURL release];
                if (imageData != nil)
                    [dict setObject:imageData forKey:@"Imagem"];
                
                //NSLog(@"%@", [dict objectForKey:@"BeneficioExclusivoMeuEspaco"]);
                //BeneficioExclusivoMeuEspaco = "<div></div>";
                //BeneficioExclusivoMeuEspaco = "<div>&nbsp;</div>";
                //BeneficioExclusivoMeuEspaco = "<p>&nbsp;</p>";
             
                // EPO pegando items que não serão exibidos ("Servico" = "N\U00e3o disponivel")
                /*
                if ([@"Não disponivel" isEqualToString:[NSString stringWithString:[dict objectForKey:@"Servico"]]] ) {
                    [objsToDelete addObject:dict];
                }
                */
                
            }
            // EPO removendo items
            //[clubeLiberty removeObjectsInArray:objsToDelete];
            
            [self carregaCategorias];
            
            if (categorias != nil) {
                //sorting array categorias
                [categorias sortUsingSelector:@selector(compare:)];
                
                //force load data
                [categoriasTableView reloadData];
            }
            
            LibertyMobileAppDelegate *delegateApp = (LibertyMobileAppDelegate*)[[UIApplication sharedApplication] delegate];
            NSMutableArray *myClubeLiberty = [[NSMutableArray alloc] initWithArray:clubeLiberty];
            [delegateApp setClubeLiberty:myClubeLiberty];
            [myClubeLiberty release];
        }
    }

    [indicator stopAnimating];
}

- (void)callWebServicesFailWithError:(CallWebServices *)call error:(NSError *)error {
    [indicator stopAnimating];
    [Util viewMsgErrorConnection:self codeError:error];
}

-(void)carregaCategorias
{
    categorias = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in clubeLiberty)
    {
        NSUInteger iIndex = [categorias indexOfObject:[dict objectForKey:@"Servico"]];
        if (iIndex == NSNotFound) {
            // EPO não adiciona caso: "Servico" = "N\U00e3o disponivel")
            //if (![@"Não disponivel" isEqualToString:[NSString stringWithString:[dict objectForKey:@"Servico"]]] ) {
                [categorias addObject:[dict objectForKey:@"Servico"]];
            //}
        }
    }
}

@end